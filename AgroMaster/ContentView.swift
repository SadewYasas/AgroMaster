import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some View {
        Group {
            if !hasCompletedOnboarding {
                OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
                    .accessibilityIdentifier("OnboardingView")
            } else if authViewModel.user != nil {
                LandingView()
                    .accessibilityIdentifier("LandingView")
            } else {
                LoginView()
                    .accessibilityIdentifier("LoginView")
            }
        }
    }
}
