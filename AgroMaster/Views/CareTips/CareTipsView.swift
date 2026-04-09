import SwiftUI

// MARK: - Care Tips View

struct CareTipsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showSettings = false

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 28) {
                    header
                    featuredTipCard
                    secondaryTipsGrid
                    seasonalMaintenanceSection
                    Spacer(minLength: 32)
                }
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
                .environmentObject(authViewModel)
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Top row: back arrow + avatar
            HStack {
                Button {
                    // Back action
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.textPrimary)
                        .frame(width: 40, height: 40)
                        .background(Color.surfaceLight)
                        .cornerRadius(12)
                }

                Spacer()

                Button {
                    showSettings = true
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.lightGreenTint)
                            .frame(width: 40, height: 40)
                        Image(systemName: "person.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.primaryGreen)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)

            // Label
            Text("PLANT HEALTH INSIGHTS")
                .font(.label)
                .tracking(2)
                .foregroundColor(.accentBrown)
                .padding(.horizontal, 20)

            // Heading
            Text("Cultivating\nResilience")
                .font(.heading1)
                .foregroundColor(.textPrimary)
                .padding(.horizontal, 20)

            // Description
            Text("Science-backed strategies to strengthen your crops against disease, optimize soil health, and build a thriving farm ecosystem.")
                .font(.bodyRegular)
                .foregroundColor(.textSecondary)
                .lineSpacing(4)
                .padding(.horizontal, 20)
        }
    }

    // MARK: - Featured Tip Card

    private var featuredTipCard: some View {
        ZStack(alignment: .bottomLeading) {
            // Background with gradient
            RoundedRectangle(cornerRadius: 32)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.primaryGreen,
                            Color.secondaryGreen,
                            Color.primaryGreen.opacity(0.85)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 240)

            // Decorative leaf shapes
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.06))
                    .frame(width: 180, height: 180)
                    .offset(x: 120, y: -60)

                Circle()
                    .fill(Color.white.opacity(0.04))
                    .frame(width: 120, height: 120)
                    .offset(x: 140, y: 20)

                Image(systemName: "leaf.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white.opacity(0.07))
                    .rotationEffect(.degrees(-20))
                    .offset(x: 100, y: -30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .clipped()

            // Content overlay
            VStack(alignment: .leading, spacing: 12) {
                // Category pills
                HStack(spacing: 8) {
                    TipCategoryPill(text: "Spring", icon: "sun.max.fill")
                    TipCategoryPill(text: "Organic", icon: "leaf.circle.fill")
                }

                Spacer()

                Text("Common Disease\nPrevention")
                    .font(.heading2Large)
                    .foregroundColor(.white)

                Text("Advanced strategies for plant longevity, disease prevention, and seasonal adaptation curated by our agricultural experts.")
                    .font(.bodySmall)
                    .foregroundColor(.white.opacity(0.85))
                    .lineSpacing(3)
                    .lineLimit(3)
            }
            .padding(24)
        }
        .frame(height: 240)
        .cornerRadius(32)
        .padding(.horizontal, 20)
    }

    // MARK: - Secondary Tips Grid

    private var secondaryTipsGrid: some View {
        VStack(spacing: 14) {
            SecondaryTipCard(
                icon: "drop.fill",
                title: "Precision Irrigation",
                description: "Saving watering techniques to prevent moisture mapping and rot in your crops."
            )

            SecondaryTipCard(
                icon: "leaf.circle.fill",
                title: "Organic Nutrients",
                description: "Natural compost blends for earth-rich soil amendments that boost yields."
            )
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Seasonal Maintenance Section

    private var seasonalMaintenanceSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section header
            HStack {
                Text("Seasonal")
                    .font(.heading2)
                    .foregroundColor(.textPrimary)

                Spacer()

                Button {
                    // See all action
                } label: {
                    Text("See all")
                        .font(.bodySmall)
                        .foregroundColor(.primaryGreen)
                }
            }
            .padding(.horizontal, 20)

            // Horizontal scroll of season cards
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    SeasonCard(
                        season: "Spring",
                        icon: "sun.and.horizon.fill",
                        iconColor: .orange,
                        backgroundColor: Color.orange.opacity(0.08),
                        checklist: [
                            "Prepare seedbeds and amend soil with compost",
                            "Apply pre-emergent herbicides before planting",
                            "Start transplanting cool-season crops outdoors"
                        ]
                    )

                    SeasonCard(
                        season: "Summer",
                        icon: "sun.max.fill",
                        iconColor: Color(hex: "E8A317"),
                        backgroundColor: Color.yellow.opacity(0.08),
                        checklist: [
                            "Increase irrigation frequency during heat waves",
                            "Scout fields weekly for pest and disease pressure",
                            "Side-dress nitrogen on corn at V6 growth stage"
                        ]
                    )

                    SeasonCard(
                        season: "Autumn",
                        icon: "leaf.fill",
                        iconColor: .accentBrown,
                        backgroundColor: Color.accentBrown.opacity(0.08),
                        checklist: [
                            "Plant cover crops to prevent soil erosion",
                            "Harvest remaining produce before first frost",
                            "Collect soil samples for off-season testing"
                        ]
                    )

                    SeasonCard(
                        season: "Winter",
                        icon: "snowflake",
                        iconColor: Color(hex: "5B9BD5"),
                        backgroundColor: Color(hex: "5B9BD5").opacity(0.08),
                        checklist: [
                            "Review crop performance data and plan rotations",
                            "Service and maintain all farm equipment",
                            "Order seeds and inputs for the coming season"
                        ]
                    )
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

// MARK: - Tip Category Pill

private struct TipCategoryPill: View {
    let text: String
    let icon: String

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10))
            Text(text)
                .font(.system(size: 11, weight: .semibold))
        }
        .foregroundColor(.white)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Color.white.opacity(0.2))
        .cornerRadius(20)
    }
}

// MARK: - Secondary Tip Card

private struct SecondaryTipCard: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color.lightGreenTint)
                    .frame(width: 44, height: 44)
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primaryGreen)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.heading4)
                    .foregroundColor(.textPrimary)

                Text(description)
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)

                // Explore Guide link
                Button {
                    // TODO: open guide
                } label: {
                    HStack(spacing: 6) {
                        Text("EXPLORE GUIDE")
                            .font(.label)
                            .tracking(1.5)
                        Image(systemName: "arrow.right")
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .foregroundColor(.primaryGreen)
                }
                .padding(.top, 4)
            }

            Spacer(minLength: 0)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(24)
    }
}

// MARK: - Season Card

private struct SeasonCard: View {
    let season: String
    let icon: String
    let iconColor: Color
    let backgroundColor: Color
    let checklist: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Season icon and name
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 40, height: 40)
                    Image(systemName: icon)
                        .font(.system(size: 17))
                        .foregroundColor(iconColor)
                }

                Text(season)
                    .font(.heading4)
                    .foregroundColor(.textPrimary)
            }

            // Divider
            Rectangle()
                .fill(Color.surfaceDark)
                .frame(height: 1)

            // Checklist
            VStack(alignment: .leading, spacing: 10) {
                ForEach(checklist, id: \.self) { item in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.primaryGreen)
                            .padding(.top, 1)

                        Text(item)
                            .font(.caption2)
                            .foregroundColor(.textSecondary)
                            .lineSpacing(2)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
        .padding(18)
        .frame(width: 260)
        .background(backgroundColor)
        .cornerRadius(24)
    }
}

// MARK: - Preview

#Preview {
    CareTipsView()
        .environmentObject(AuthViewModel())
}
