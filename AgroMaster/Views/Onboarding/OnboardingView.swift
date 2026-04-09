import SwiftUI

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentPage = 0

    private let totalPages = 3

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
                .padding(.top, 12)

                // Page content
                TabView(selection: $currentPage) {
                    SmarterFarmingPage().tag(0)
                    AIDiagnosisPage().tag(1)
                    GrowWithConfidencePage().tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)

                // Bottom controls
                VStack(spacing: 14) {
                    // Page indicator
                    HStack(spacing: 8) {
                        ForEach(0..<totalPages, id: \.self) { i in
                            Capsule()
                                .fill(i == currentPage ? Color.primaryGreen : Color.surfaceDark)
                                .frame(width: i == currentPage ? 24 : 8, height: 8)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }

                    // Continue / Get Started button
                    GradientButton(
                        title: currentPage == totalPages - 1 ? "Get Started" : "Continue",
                        icon: "arrow.right"
                    ) {
                        if currentPage < totalPages - 1 {
                            withAnimation { currentPage += 1 }
                        } else {
                            hasCompletedOnboarding = true
                        }
                    }
                    .padding(.horizontal, 24)
                    .accessibilityIdentifier("onboardingContinueButton")

                    // Skip button
                    if currentPage < totalPages - 1 {
                        Button("SKIP") {
                            hasCompletedOnboarding = true
                        }
                        .font(.label)
                        .tracking(1.5)
                        .foregroundColor(.textSecondary)
                        .accessibilityIdentifier("onboardingSkipButton")
                    } else {
                        // Reserve space so layout doesn't shift
                        Text(" ")
                            .font(.label)
                    }
                }
                .padding(.bottom, 32)
            }
        }
    }
}

// MARK: - Page 1: Smarter Farming

private struct SmarterFarmingPage: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Hero illustration area
            ZStack(alignment: .topTrailing) {
                // Background gradient
                RoundedRectangle(cornerRadius: 32)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.lightGreenTint.opacity(0.6),
                                Color.primaryGreen.opacity(0.85),
                                Color.secondaryGreen
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                // Decorative leaves
                Image(systemName: "leaf.fill")
                    .font(.system(size: 240))
                    .foregroundColor(.white.opacity(0.18))
                    .rotationEffect(.degrees(-25))
                    .offset(x: 20, y: 30)

                Image(systemName: "leaf.fill")
                    .font(.system(size: 140))
                    .foregroundColor(.white.opacity(0.12))
                    .rotationEffect(.degrees(35))
                    .offset(x: -100, y: 140)

                // Glassmorphism accuracy tag
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                    VStack(alignment: .leading, spacing: 0) {
                        Text("98.4%")
                            .font(.heading4)
                            .foregroundColor(.white)
                        Text("AI ACCURACY")
                            .font(.system(size: 8, weight: .semibold))
                            .tracking(1)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(.ultraThinMaterial)
                        .overlay(
                            Capsule()
                                .stroke(Color.white.opacity(0.4), lineWidth: 1)
                        )
                )
                .padding(.top, 20)
                .padding(.trailing, 20)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 360)
            .clipShape(RoundedRectangle(cornerRadius: 32))
            .padding(.horizontal, 24)

            // Text content
            VStack(alignment: .leading, spacing: 10) {
                Text("WELCOME TO AGROMASTER")
                    .font(.label)
                    .tracking(2)
                    .foregroundColor(.accentBrown)

                Text("Smarter\nFarming.")
                    .font(.heading1Large)
                    .foregroundColor(.textPrimary)
                    .lineSpacing(0)

                Text("Your AI-powered companion for smarter farming and gardening. Analyze soil health, detect pests, and optimize your harvest with a single scan.")
                    .font(.bodyRegular)
                    .foregroundColor(.textSecondary)
                    .lineSpacing(4)
                    .padding(.top, 4)
            }
            .padding(.horizontal, 24)

            Spacer(minLength: 0)
        }
        .padding(.top, 20)
    }
}

// MARK: - Page 2: AI-Powered Diagnosis

private struct AIDiagnosisPage: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Heading at the top
            VStack(alignment: .leading, spacing: 10) {
                Text("AI-Powered\nDiagnosis")
                    .font(.heading1Large)
                    .foregroundColor(.textPrimary)
                    .lineSpacing(0)

                Text("Simply snap a photo to identify diseases and nutrient deficiencies in seconds.")
                    .font(.bodyRegular)
                    .foregroundColor(.textSecondary)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)

            // Scan visualization
            ZStack(alignment: .bottom) {
                // Background gradient card
                RoundedRectangle(cornerRadius: 32)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.secondaryGreen,
                                Color.primaryGreen,
                                Color.primaryGreen.opacity(0.9)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                // Decorative leaf
                Image(systemName: "leaf.fill")
                    .font(.system(size: 200))
                    .foregroundColor(.white.opacity(0.15))
                    .rotationEffect(.degrees(15))
                    .offset(y: -10)

                // Scanning corner brackets overlay
                VStack {
                    HStack {
                        scannerCorner.rotationEffect(.degrees(0))
                        Spacer()
                        scannerCorner.rotationEffect(.degrees(90))
                    }
                    Spacer()
                    HStack {
                        scannerCorner.rotationEffect(.degrees(-90))
                        Spacer()
                        scannerCorner.rotationEffect(.degrees(180))
                    }
                }
                .padding(40)

                // Diagnosis result card overlay
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(Color.lightGreenTint)
                                .frame(width: 28, height: 28)
                            Image(systemName: "checkmark")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.primaryGreen)
                        }
                        Text("Healthy Leaf Detected")
                            .font(.heading4)
                            .foregroundColor(.textPrimary)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        diagnosisRow(text: "No pests detected")
                        diagnosisRow(text: "Nitrogen levels optimal")
                    }
                    .padding(.leading, 4)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white)
                        .shadow(color: .black.opacity(0.15), radius: 12, y: 4)
                )
                .padding(20)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 360)
            .clipShape(RoundedRectangle(cornerRadius: 32))
            .padding(.horizontal, 24)

            Spacer(minLength: 0)
        }
        .padding(.top, 20)
    }

    private var scannerCorner: some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 24))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 24, y: 0))
        }
        .stroke(Color.lightGreenTint, lineWidth: 3)
        .frame(width: 24, height: 24)
    }

    private func diagnosisRow(text: String) -> some View {
        HStack(spacing: 6) {
            Circle()
                .fill(Color.primaryGreen)
                .frame(width: 5, height: 5)
            Text(text)
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
        }
    }
}

// MARK: - Page 3: Grow with Confidence

private struct GrowWithConfidencePage: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            // Reminder tip card at top
            VStack(alignment: .leading, spacing: 14) {
                // Reminder header
                HStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(.white)
                            .frame(width: 28, height: 28)
                        Image(systemName: "bell.fill")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.accentBrown)
                    }

                    VStack(alignment: .leading, spacing: 0) {
                        Text("AGROMASTER REMINDER")
                            .font(.label)
                            .tracking(1.5)
                            .foregroundColor(.accentBrown)
                        Text("Time to water Fiddle Leaf Fig")
                            .font(.caption2)
                            .foregroundColor(.accentBrown.opacity(0.75))
                    }
                }

                Text("Optimize Sunlight\nExposure")
                    .font(.heading2Large)
                    .foregroundColor(.accentBrown)
                    .lineSpacing(0)

                Text("Rotate your plant 90° every week to ensure even growth and prevent leaning towards light sources.")
                    .font(.bodySmall)
                    .foregroundColor(.accentBrown.opacity(0.85))
                    .lineSpacing(3)

                HStack(spacing: 6) {
                    ZStack {
                        Circle()
                            .fill(Color.accentBrown.opacity(0.15))
                            .frame(width: 22, height: 22)
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.accentBrown)
                    }
                    Text("by Aria Theme")
                        .font(.caption2)
                        .foregroundColor(.accentBrown.opacity(0.75))
                }
                .padding(.top, 4)
            }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 32)
                    .fill(Color.coral)
            )
            .padding(.horizontal, 24)
            .padding(.top, 16)

            Spacer(minLength: 0)

            // Heading + description at bottom
            VStack(alignment: .leading, spacing: 10) {
                Text("Grow with\nConfidence")
                    .font(.heading1Large)
                    .foregroundColor(.textPrimary)
                    .lineSpacing(0)

                Text("Personalized care tips and reminders to keep every plant thriving with smart notifications.")
                    .font(.bodyRegular)
                    .foregroundColor(.textSecondary)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 24)
        }
    }
}

// MARK: - Preview

#Preview {
    OnboardingView(hasCompletedOnboarding: .constant(false))
}
