import SwiftUI
import MapKit

// MARK: - Support Center Detail View

struct SupportCenterDetailView: View {
    let center: SupportCenter
    let distance: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24) {
                // Drag indicator spacer
                Spacer()
                    .frame(height: 4)

                // Center icon (large)
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.lightGreenTint, Color.lightGreenTint.opacity(0.4)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 88, height: 88)

                    Image(systemName: center.icon)
                        .font(.system(size: 36, weight: .semibold))
                        .foregroundColor(.primaryGreen)
                }

                // Center name
                Text(center.name)
                    .font(.heading2)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)

                // Distance badge
                HStack(spacing: 6) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 12, weight: .semibold))
                    Text(distance)
                        .font(.caption2)
                }
                .foregroundColor(.secondaryGreen)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.lightGreenTint.opacity(0.5))
                .cornerRadius(20)

                // Description
                Text(center.description)
                    .font(.bodyRegular)
                    .foregroundColor(.textSecondary)
                    .lineSpacing(4)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 8)

                // Category tags
                HStack(spacing: 8) {
                    ForEach(center.categories, id: \.self) { category in
                        HStack(spacing: 4) {
                            Circle()
                                .fill(Color.primaryGreen)
                                .frame(width: 6, height: 6)
                            Text(category)
                                .font(.caption2)
                                .foregroundColor(.textPrimary)
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color.surfaceLight)
                        .cornerRadius(20)
                    }
                }

                // Phone number (if available)
                if let phone = center.phone {
                    Button {
                        let cleaned = phone.replacingOccurrences(of: " ", with: "")
                        if let url = URL(string: "tel://\(cleaned)") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(Color.primaryGreen.opacity(0.1))
                                    .frame(width: 44, height: 44)
                                Image(systemName: "phone.fill")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.primaryGreen)
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Phone")
                                    .font(.caption2)
                                    .foregroundColor(.textSecondary)
                                Text(phone)
                                    .font(.bodySmall.weight(.semibold))
                                    .foregroundColor(.textPrimary)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.textSecondary)
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color.surfaceLight)
                        )
                    }
                    .buttonStyle(.plain)
                }

                // Get Directions button
                GradientButton(title: "Get Directions", icon: "arrow.triangle.turn.up.right.diamond.fill") {
                    let destination = MKMapItem(
                        placemark: MKPlacemark(coordinate: center.coordinate)
                    )
                    destination.name = center.name
                    destination.openInMaps(launchOptions: [
                        MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
                    ])
                }

                // Close button
                Button {
                    dismiss()
                } label: {
                    Text("Close")
                        .font(.button)
                        .foregroundColor(.textSecondary)
                        .frame(maxWidth: .infinity, minHeight: 52)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.surfaceLight)
                        )
                }

                Spacer(minLength: 16)
            }
            .padding(.horizontal, 24)
        }
        .background(Color.appBackground.ignoresSafeArea())
    }
}

// MARK: - Preview

#Preview {
    SupportCenterDetailView(
        center: SupportCenter(
            name: "GreenLeaf Agro Center",
            description: "Your one-stop shop for premium agricultural supplies, organic pesticides, and expert pest management consultations for all crop types.",
            latitude: 6.9175,
            longitude: 79.8613,
            distance: "1.1 km",
            categories: ["Retail", "Pest Management"],
            phone: "+94 11 234 5678",
            icon: "leaf.circle.fill"
        ),
        distance: "1.1 km"
    )
}
