import SwiftUI

struct ScanResultView: View {
    let image: UIImage
    let result: ScanResultData

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                scannedImageSection
                diagnosisSection
                treatmentSection
            }
        }
        .background(Color.appBackground)
        .navigationBarHidden(true)
        .ignoresSafeArea(edges: .top)
    }

    // MARK: - Scanned Image with Glassmorphism Tag

    private var scannedImageSection: some View {
        ZStack(alignment: .topLeading) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 340)
                .clipped()

            LinearGradient(
                colors: [.black.opacity(0.4), .clear, .clear, .black.opacity(0.15)],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 340)

            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    Spacer()
                }
                .padding(.top, 56)
                .padding(.horizontal, 24)

                Spacer()

                HStack {
                    Spacer()
                    analyzingCompleteTag
                        .padding(.trailing, 24)
                        .padding(.bottom, 20)
                }
            }
            .frame(height: 340)
        }
    }

    private var analyzingCompleteTag: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(Color.primaryGreen)
                .frame(width: 8, height: 8)

            Text("ANALYSIS COMPLETE")
                .font(.label)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
    }

    // MARK: - Diagnosis Section

    private var diagnosisSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                if let disease = result.diseaseName {
                    Text(disease)
                        .font(.heading2)
                        .foregroundColor(.textPrimary)
                } else {
                    Text("No Disease Detected")
                        .font(.heading2)
                        .foregroundColor(.primaryGreen)
                }

                Text(result.plantName)
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
            }

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("CONFIDENCE SCORE")
                        .font(.label)
                        .tracking(1.5)
                        .foregroundColor(.primaryGreen)

                    Spacer()

                    Text(healthPercentageText)
                        .font(.heading3)
                        .foregroundColor(.primaryGreen)
                }

                healthMeterBar
            }

            Text(diagnosisDescription)
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 16) {
                infoChip(icon: "calendar", text: formattedDate)
                infoChip(icon: "leaf.fill", text: result.plantName)
            }
        }
        .padding(24)
    }

    // MARK: - Health Meter Bar

    private var healthMeterBar: some View {
        GeometryReader { geometry in
            let barWidth = geometry.size.width
            let indicatorPosition = barWidth * result.healthScore

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: [.alertRed, .coral, Color.orange, Color.yellow, .primaryGreen],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 12)

                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.black.opacity(0.05))
                    .frame(height: 12)

                indicatorMarker
                    .offset(x: max(0, min(indicatorPosition - 10, barWidth - 20)))
            }
        }
        .frame(height: 28)
    }

    private var indicatorMarker: some View {
        VStack(spacing: 2) {
            Triangle()
                .fill(Color.textPrimary)
                .frame(width: 10, height: 6)

            RoundedRectangle(cornerRadius: 3)
                .fill(Color.textPrimary)
                .frame(width: 20, height: 16)
                .overlay(
                    RoundedRectangle(cornerRadius: 3)
                        .stroke(Color.white, lineWidth: 2)
                )
        }
    }

    // MARK: - Treatment Section

    private var treatmentSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 10) {
                Image(systemName: "leaf.circle.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.primaryGreen)

                Text("Treatment Recommendations")
                    .font(.heading3)
                    .foregroundColor(.textPrimary)
            }

            VStack(alignment: .leading, spacing: 18) {
                ForEach(result.treatments) { treatment in
                    treatmentRow(treatment: treatment)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 24)
        .padding(.bottom, 32)
    }

    private func treatmentRow(treatment: Treatment) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(Color.primaryGreen)
                .frame(width: 8, height: 8)
                .padding(.top, 6)

            VStack(alignment: .leading, spacing: 6) {
                Text(treatment.category.uppercased())
                    .font(.label)
                    .tracking(1.2)
                    .foregroundColor(.textPrimary)

                Text(treatment.description)
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Info Chip

    private func infoChip(icon: String, text: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(.primaryGreen)

            Text(text)
                .font(.caption2)
                .foregroundColor(.textSecondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.surfaceLight)
        .cornerRadius(10)
    }

    // MARK: - Computed Properties

    private var healthPercentageText: String {
        String(format: "%.1f%%", result.healthScore * 100)
    }

    private var healthColor: Color {
        switch result.healthScore {
        case 0..<0.4:
            return .alertRed
        case 0.4..<0.7:
            return Color.orange
        default:
            return .primaryGreen
        }
    }

    private var diagnosisDescription: String {
        if let disease = result.diseaseName {
            return "Our AI analysis has detected signs of \(disease) on your \(result.plantName) plant. The overall health score of \(healthPercentageText) indicates \(severityLabel) severity. We recommend following the treatment plan below to restore your plant to optimal condition. Early intervention significantly improves recovery outcomes."
        } else {
            return "Great news! Our AI analysis shows your \(result.plantName) plant is in excellent condition with a health score of \(healthPercentageText). No signs of disease, pest damage, or nutrient deficiency were detected. Continue your current care routine and schedule periodic scans to maintain plant health."
        }
    }

    private var severityLabel: String {
        switch result.healthScore {
        case 0..<0.3:
            return "critical"
        case 0.3..<0.5:
            return "moderate-to-high"
        case 0.5..<0.7:
            return "mild-to-moderate"
        default:
            return "low"
        }
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: result.scanDate)
    }
}

// MARK: - Triangle Shape

private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

// MARK: - Preview

#Preview {
    let mockResult = ScanResultData(
        plantName: "Tomato",
        diseaseName: "Early Blight",
        healthScore: 0.736,
        treatments: [
            Treatment(category: "Chemical Control", description: "Apply chlorothalonil or copper-based fungicide every 7-10 days. Ensure thorough leaf coverage."),
            Treatment(category: "Pruning", description: "Remove and destroy all infected lower leaves immediately. Prune to improve air circulation."),
            Treatment(category: "Soil Health", description: "Add 2-inch layer of organic mulch around the base to prevent soil splash."),
            Treatment(category: "Follow-Up Scan", description: "Re-scan in 5-7 days to monitor disease progression.")
        ],
        scanDate: Date()
    )

    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 300, height: 300))
    let previewImage = renderer.image { ctx in
        UIColor.systemGreen.setFill()
        ctx.fill(CGRect(x: 0, y: 0, width: 300, height: 300))
    }

    NavigationStack {
        ScanResultView(image: previewImage, result: mockResult)
    }
}
