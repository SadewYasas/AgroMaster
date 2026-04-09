import SwiftUI

struct OnboardingPage {
    let title: String
    let highlightedWord: String?
    let description: String
    let systemImage: String
}

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentPage = 0

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Smarter Farming.",
            highlightedWord: "Smarter",
            description: "Your AI-powered companion for healthier crops and better harvests. Scan, diagnose, and nurture your plants with precision.",
            systemImage: "leaf.fill"
        ),
        OnboardingPage(
            title: "AI-powered scanning.",
            highlightedWord: "AI-powered",
            description: "Point your camera at any plant to instantly identify diseases and get treatment recommendations backed by machine learning.",
            systemImage: "camera.viewfinder"
        ),
        OnboardingPage(
            title: "Stay informed.",
            highlightedWord: "informed",
            description: "Get timely reminders for watering, treatments, and seasonal care tips tailored to your local crop variety.",
            systemImage: "bell.badge"
        ),
        OnboardingPage(
            title: "Let's get started.",
            highlightedWord: nil,
            description: "Join thousands of farmers using AgroMaster to protect their crops and maximize yields.",
            systemImage: "arrow.right.circle.fill"
        )
    ]

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                // Brand header
                HStack {
                    Text("AGROMASTER")
                        .font(.label)
                        .tracking(2)
                        .foregroundColor(.primaryGreen)
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                // Page content
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageContent(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                // Bottom controls
                VStack(spacing: 16) {
                    // Page indicator
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { i in
                            Capsule()
                                .fill(i == currentPage ? Color.primaryGreen : Color.surfaceDark)
                                .frame(width: i == currentPage ? 24 : 8, height: 8)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }

                    // Continue button
                    GradientButton(
                        title: currentPage == pages.count - 1 ? "Get Started" : "Continue"
                    ) {
                        if currentPage < pages.count - 1 {
                            withAnimation {
                                currentPage += 1
                            }
                        } else {
                            hasCompletedOnboarding = true
                        }
                    }
                    .padding(.horizontal, 24)
                    .accessibilityIdentifier("onboardingContinueButton")

                    // Skip button
                    if currentPage < pages.count - 1 {
                        Button("Skip") {
                            hasCompletedOnboarding = true
                        }
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                        .accessibilityIdentifier("onboardingSkipButton")
                    }
                }
                .padding(.bottom, 40)
            }
        }
    }
}

// MARK: - Page Content

private struct OnboardingPageContent: View {
    let page: OnboardingPage

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // Hero icon
            Image(systemName: page.systemImage)
                .font(.system(size: 120))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.primaryGreen, .secondaryGreen],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 200)

            Spacer()

            // Text content
            VStack(alignment: .leading, spacing: 12) {
                Text(page.title)
                    .font(.heading1Large)
                    .foregroundColor(.textPrimary)

                Text(page.description)
                    .font(.bodyRegular)
                    .foregroundColor(.textSecondary)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 24)

            Spacer()
        }
    }
}
