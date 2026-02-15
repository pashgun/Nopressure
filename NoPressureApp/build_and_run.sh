#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  $1"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${NC}"
}

print_step() {
    echo -e "${BLUE}→ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# 1. Check prerequisites
check_xcode() {
    print_step "Checking for Xcode..."
    if ! command -v xcodebuild &> /dev/null; then
        print_error "Xcode not found"
        echo ""
        echo "Please install Xcode from the App Store"
        exit 1
    fi

    XCODE_VERSION=$(xcodebuild -version | head -1)
    print_success "Xcode found: $XCODE_VERSION"
}

check_homebrew() {
    print_step "Checking for Homebrew..."
    if ! command -v brew &> /dev/null; then
        print_warning "Homebrew not found"
        print_step "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        print_success "Homebrew installed"
    else
        print_success "Homebrew found"
    fi
}

check_xcodegen() {
    print_step "Checking for xcodegen..."
    if ! command -v xcodegen &> /dev/null; then
        print_step "Installing xcodegen..."
        brew install xcodegen
        print_success "xcodegen installed"
    else
        print_success "xcodegen ready"
    fi
}

check_xcbeautify() {
    if ! command -v xcbeautify &> /dev/null; then
        print_step "Installing xcbeautify for better output..."
        brew install xcbeautify
    fi
}

# 2. Generate Xcode project
generate_project() {
    print_step "Generating Xcode project from project.yml..."

    if [ ! -f "project.yml" ]; then
        print_error "project.yml not found"
        exit 1
    fi

    xcodegen generate

    if [ -f "NoPressureApp.xcodeproj/project.pbxproj" ]; then
        print_success "NoPressureApp.xcodeproj created"
    else
        print_error "Failed to generate Xcode project"
        exit 1
    fi
}

# 3. Resolve SPM dependencies
resolve_deps() {
    print_step "Resolving Swift Package dependencies (FSRS)..."

    xcodebuild \
        -resolvePackageDependencies \
        -project NoPressureApp.xcodeproj \
        -scheme NoPressureApp \
        2>&1 | grep -E "(Resolved source packages|FSRS)" || true

    print_success "FSRS package resolved"
}

# 4. Build project
build_project() {
    print_step "Building NoPressureApp..."
    echo ""

    # Auto-detect first available iPhone simulator
    DEVICE_NAME=$(xcrun simctl list devices available | grep "iPhone" | head -1 | sed 's/^ *//;s/ (.*//')

    if [ -z "$DEVICE_NAME" ]; then
        print_error "No iPhone simulator found"
        exit 1
    fi

    echo "→ Using simulator: $DEVICE_NAME"
    echo ""

    if command -v xcbeautify &> /dev/null; then
        xcodebuild \
            -project NoPressureApp.xcodeproj \
            -scheme NoPressureApp \
            -sdk iphonesimulator \
            -destination "platform=iOS Simulator,name=$DEVICE_NAME" \
            -configuration Debug \
            build \
            CODE_SIGN_IDENTITY="" \
            CODE_SIGNING_REQUIRED=NO \
            CODE_SIGNING_ALLOWED=NO \
            2>&1 | xcbeautify
    else
        xcodebuild \
            -project NoPressureApp.xcodeproj \
            -scheme NoPressureApp \
            -sdk iphonesimulator \
            -destination "platform=iOS Simulator,name=$DEVICE_NAME" \
            -configuration Debug \
            build \
            CODE_SIGN_IDENTITY="" \
            CODE_SIGNING_REQUIRED=NO \
            CODE_SIGNING_ALLOWED=NO
    fi

    echo ""
    print_success "Build successful"
}

# 5. Boot simulator
boot_simulator() {
    # Auto-detect first available iPhone simulator
    DEVICE_NAME=$(xcrun simctl list devices available | grep "iPhone" | head -1 | sed 's/^ *//;s/ (.*//')
    DEVICE_ID=$(xcrun simctl list devices available | grep "iPhone" | head -1 | grep -oE '[0-9A-F-]{36}')

    if [ -z "$DEVICE_ID" ]; then
        print_error "No iPhone simulator found"
        exit 1
    fi

    print_step "Starting iOS Simulator ($DEVICE_NAME)..."

    # Boot simulator if not already booted
    xcrun simctl boot "$DEVICE_ID" 2>/dev/null || true

    # Open Simulator app
    open -a Simulator

    # Wait for simulator to fully boot
    print_step "Waiting for simulator to boot..."
    MAX_WAIT=60
    WAITED=0
    while [ $WAITED -lt $MAX_WAIT ]; do
        if xcrun simctl bootstatus "$DEVICE_ID" 2>/dev/null | grep -q "Boot status: Booted"; then
            break
        fi
        sleep 1
        WAITED=$((WAITED + 1))
    done

    if [ $WAITED -ge $MAX_WAIT ]; then
        print_error "Simulator failed to boot within ${MAX_WAIT}s"
        exit 1
    fi

    print_success "Simulator ready (UDID: ${DEVICE_ID:0:8}...)"
}

# 6. Install and launch app
install_and_run() {
    print_step "Installing NoPressureApp on simulator..."

    # Find built .app bundle
    APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData -name "NoPressureApp.app" -type d | head -1)

    if [ -z "$APP_PATH" ]; then
        print_error "NoPressureApp.app not found in DerivedData"
        echo ""
        echo "Build artifacts location:"
        echo "~/Library/Developer/Xcode/DerivedData/"
        exit 1
    fi

    # Get the booted iPhone simulator
    DEVICE_ID=$(xcrun simctl list devices available | grep "iPhone" | head -1 | grep -oE '[0-9A-F-]{36}')

    if [ -z "$DEVICE_ID" ]; then
        print_error "No iPhone simulator found"
        exit 1
    fi

    # Install app
    xcrun simctl install "$DEVICE_ID" "$APP_PATH"
    print_success "App installed"

    # Launch app
    print_step "Launching NoPressureApp..."
    xcrun simctl launch "$DEVICE_ID" com.nopressure.app

    echo ""
    print_header "✨ No Pressure Flashcards is running! ✨"
    echo ""
    echo "📱 Check your iOS Simulator"
    echo "🎯 App should open with onboarding flow"
    echo ""
    echo "🧪 Test features:"
    echo "   • Complete onboarding (goal, time, interests)"
    echo "   • Browse 2 sample decks (Spanish + Swift)"
    echo "   • Tap 'Start Learning' to review cards"
    echo "   • Flip cards by tapping"
    echo "   • Rate cards: Again/Hard/Good/Easy"
    echo ""
    echo "📝 To rebuild:"
    echo "   ./build_and_run.sh"
    echo ""
    echo "🔧 To open in Xcode:"
    echo "   open NoPressureApp.xcodeproj"
    echo ""
}

# Main execution
main() {
    print_header "No Pressure Flashcards - Build & Run"

    echo "Step 1/6: Checking prerequisites..."
    check_xcode
    check_homebrew
    check_xcodegen
    check_xcbeautify
    echo ""

    echo "Step 2/6: Generating Xcode project..."
    generate_project
    echo ""

    echo "Step 3/6: Resolving dependencies..."
    resolve_deps
    echo ""

    echo "Step 4/6: Building project..."
    build_project
    echo ""

    echo "Step 5/6: Starting simulator..."
    boot_simulator
    echo ""

    echo "Step 6/6: Installing and launching..."
    install_and_run
}

main "$@"
