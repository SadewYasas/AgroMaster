import SwiftUI

struct LandingView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isAnimating = false
    @State private var navigateToMain = false

    var body: some View {
        Group {
            if navigateToMain {
                MainTabView()
                    .transition(.opacity)
            } else {
                landingContent
            }
        }
        .animation(.easeInOut(duration: 0.5), value: navigateToMain)
    }

    private var landingContent: some View {
        VStack(spacing: 16) {
            Spacer()

            // Animated logo
            Image(systemName: "leaf.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.primaryGreen, .secondaryGreen],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .scaleEffect(isAnimating ? 1.0 : 0.5)
                .opacity(isAnimating ? 1.0 : 0.0)

            Text("Welcome back,")
                .font(.heading2)
                .foregroundColor(.textSecondary)
                .opacity(isAnimating ? 1.0 : 0.0)

            Text(authViewModel.getUserName())
                .font(.heading1)
                .foregroundColor(.primaryGreen)
                .opacity(isAnimating ? 1.0 : 0.0)

            Spacer()

            // Loading indicator
            ProgressView()
                .tint(.primaryGreen)
                .opacity(isAnimating ? 1.0 : 0.0)
                .padding(.bottom, 60)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground)
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                isAnimating = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                navigateToMain = true
            }
        }
    }
}
