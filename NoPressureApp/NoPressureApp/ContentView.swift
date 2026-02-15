import SwiftUI

struct ContentView: View {
    @AppStorage("isOnboardingComplete") private var isOnboardingComplete = false

    var body: some View {
        if isOnboardingComplete {
            MainTabView()
        } else {
            OnboardingCoordinator(isOnboardingComplete: $isOnboardingComplete)
        }
    }
}
