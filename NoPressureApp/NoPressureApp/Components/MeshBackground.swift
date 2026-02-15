import SwiftUI

/// App-wide background — solid lavender #EBE8FC
/// Replaces the old dark mesh gradient background
struct MeshBackground: View {
    var body: some View {
        NP.Colors.background
            .ignoresSafeArea()
    }
}
