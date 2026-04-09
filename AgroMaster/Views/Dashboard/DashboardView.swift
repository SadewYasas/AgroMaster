import SwiftUI

struct DashboardView: View {
    @Binding var selectedTab: Int
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showSignOutConfirmation = false

    // MARK: - Greeting Logic

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:
            return "Good Morning"
        case 12..<17:
            return "Good Afternoon"
        case 17..<21:
            return "Good Evening"
        default:
            return "Good Night"
        }
    }

    private var userName: String {
        authViewModel.getUserName()
    }

    // MARK: - Body

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24) {
                headerArea
                scanPlantCard
                viewHistoryCard
                plantCareTipsCard
                remindersCard
                nearbySupportCard
                insightOfTheDayCard
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
            .padding(.bottom, 40)
        }
        .background(Color.appBackground.ignoresSafeArea())
        .confirmationDialog(
            "Sign Out",
            isPresented: $showSignOutConfirmation,
            titleVisibility: .visible
        ) {
            Button("Sign Out", role: .destructive) {
                authViewModel.signOut()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to sign out of AgroMaster?")
        }
    }

    // MARK: - 1. Header Area

    private var headerArea: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                Spacer()
                Button {
                    showSignOutConfirmation = true
                } label: {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 39, height: 39)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.primaryGreen, .secondaryGreen],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
            }

            (
                Text("Welcome back to your\n")
                    .foregroundColor(.textPrimary)
                +
                Text("Digital Greenhouse.")
                    .foregroundColor(.primaryGreen)
            )
            .font(.heading1)
            .lineSpacing(2)

            Text("\(greeting), \(userName)")
                .font(.bodySmall)
                .foregroundColor(.accentBrown)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 8)
    }

    // MARK: - 2. Scan Plant Card (Hero)

    private var scanPlantCard: some View {
        Button {
            selectedTab = 2
        } label: {
            ZStack(alignment: .bottomTrailing) {
                // Background plant imagery
                Image(systemName: "leaf.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 180, height: 180)
                    .foregroundColor(.white.opacity(0.12))
                    .rotationEffect(.degrees(-20))
                    .offset(x: 30, y: 20)

                VStack(alignment: .leading, spacing: 16) {
                    // Frosted glass icon
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ultraThinMaterial)
                            .frame(width: 48, height: 48)

                        Image(systemName: "camera.viewfinder")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.lightGreenTint)
                    }

                    Spacer()

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Scan Plant")
                            .font(.heading2Large)
                            .foregroundColor(.lightGreenTint)

                        Text("Point your camera at any plant to identify diseases and get instant care advice.")
                            .font(.bodyRegular)
                            .foregroundColor(.lightGreenTint.opacity(0.8))
                            .lineSpacing(3)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    // Launch Camera pill button
                    HStack(spacing: 6) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Launch Camera")
                            .font(.button)
                    }
                    .foregroundColor(.secondaryGreen)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        Capsule()
                            .fill(.white)
                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    )
                }
                .padding(24)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(minHeight: 280)
            .background(
                RoundedRectangle(cornerRadius: 32)
                    .fill(
                        LinearGradient(
                            colors: [.secondaryGreen, .primaryGreen],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: 32))
        }
        .buttonStyle(.plain)
    }

    // MARK: - 3. View History Card

    private var viewHistoryCard: some View {
        Button {
            selectedTab = 3
        } label: {
            VStack(alignment: .leading, spacing: 14) {
                // Icon container
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.surfaceLight)
                        .frame(width: 48, height: 48)

                    Image(systemName: "clock.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.textSecondary)
                }

                Text("View History")
                    .font(.heading3)
                    .foregroundColor(.textPrimary)

                Text("Browse your past scans, diagnoses, and treatment logs all in one place.")
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)

                Text("12 Reports >")
                    .font(.bodySmall.weight(.semibold))
                    .foregroundColor(.primaryGreen)
            }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 32)
                    .fill(.white)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - 4. Plant Care Tips Card

    private var plantCareTipsCard: some View {
        Button {
            selectedTab = 1
        } label: {
            VStack(alignment: .leading, spacing: 14) {
                // Icon container
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.white)
                        .frame(width: 48, height: 48)

                    Image(systemName: "leaf.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.primaryGreen)
                }

                Text("Care Tips")
                    .font(.heading3)
                    .foregroundColor(.textPrimary)

                Text("Seasonal advice, pest prevention, and expert-backed techniques to keep your crops thriving.")
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 32)
                    .fill(Color.surfaceDark)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - 5. Reminders Card

    private var remindersCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Action required badge
            HStack(spacing: 6) {
                Circle()
                    .fill(Color.alertRed)
                    .frame(width: 8, height: 8)

                Text("ACTION REQUIRED")
                    .font(.label)
                    .tracking(1.5)
                    .foregroundColor(.alertRed)
                    .textCase(.uppercase)
            }

            Text("Watering Schedule")
                .font(.heading2)
                .foregroundColor(.textPrimary)

            Text("Your tomatoes and basil are due for watering today. Tap to review your full schedule.")
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)

            // Stat card
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("02")
                        .font(.heading1)
                        .foregroundColor(.textPrimary)

                    Text("Active Alerts")
                        .font(.caption2)
                        .foregroundColor(.textSecondary)
                }
                Spacer()

                Image(systemName: "drop.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.primaryGreen.opacity(0.3))
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.white)
            )
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 32)
                .fill(Color.surfaceLight)
        )
    }

    // MARK: - 6. Nearby Support Card

    private var nearbySupportCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Icon container
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.textPrimary)
                    .frame(width: 48, height: 48)

                Image(systemName: "mappin.and.ellipse")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
            }

            Text("Nearby Support")
                .font(.heading3)
                .foregroundColor(.textPrimary)

            Text("Find agricultural experts, nurseries, and supply shops in your area for hands-on assistance.")
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)

            // Frosted pill
            HStack(spacing: 6) {
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primaryGreen)

                Text("3 Experts Nearby")
                    .font(.bodySmall.weight(.semibold))
                    .foregroundColor(.textPrimary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(.ultraThinMaterial)
            )
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 32)
                .fill(Color.surfaceMedium)
        )
    }

    // MARK: - 7. Insight of the Day Card

    private var insightOfTheDayCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("INSIGHT OF THE DAY")
                .font(.label)
                .tracking(1.5)
                .foregroundColor(.accentBrown)
                .textCase(.uppercase)

            Text("\"Healthy soil is the foundation of healthy food.\"")
                .font(.heading2Large)
                .foregroundColor(.accentBrown)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)

            Text("Crop rotation isn't just tradition -- it's science. Alternating plant families each season breaks pest cycles and replenishes essential nutrients naturally.")
                .font(.bodySmall)
                .foregroundColor(.accentBrown.opacity(0.75))
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)

            // Read Full Article pill
            HStack(spacing: 6) {
                Text("Read Full Article")
                    .font(.button)

                Image(systemName: "arrow.right")
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                Capsule()
                    .fill(Color.accentBrown)
            )
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 32)
                .fill(Color.coral)
        )
    }
}

// MARK: - Preview

#Preview {
    DashboardView(selectedTab: .constant(0))
        .environmentObject(AuthViewModel())
}
