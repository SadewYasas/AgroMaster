import SwiftUI

// MARK: - Data Model

struct ScanHistoryItem: Identifiable {
    let id = UUID()
    let plantName: String
    let diseaseName: String
    let scanDate: Date
    let category: String
    let status: ScanStatus
    let healthScore: Int
    let systemImage: String

    enum ScanStatus: String {
        case healthy = "Healthy"
        case treatmentInProgress = "Treatment in Progress"
        case critical = "Critical"

        var color: Color {
            switch self {
            case .healthy: return .primaryGreen
            case .treatmentInProgress: return .orange
            case .critical: return .alertRed
            }
        }

        var backgroundColor: Color {
            switch self {
            case .healthy: return .lightGreenTint
            case .treatmentInProgress: return Color.orange.opacity(0.12)
            case .critical: return Color.alertRed.opacity(0.12)
            }
        }
    }
}

// MARK: - History View

struct HistoryView: View {
    @State private var searchText = ""
    @State private var selectedCategory: String? = nil
    @State private var scanItems: [ScanHistoryItem] = ScanHistoryItem.mockData

    private let categories = ["All", "Vegetable", "Fruit"]

    private var filteredItems: [ScanHistoryItem] {
        var items = scanItems

        if let category = selectedCategory, category != "All" {
            items = items.filter { $0.category == category }
        }

        if !searchText.isEmpty {
            items = items.filter {
                $0.plantName.localizedCaseInsensitiveContains(searchText) ||
                $0.diseaseName.localizedCaseInsensitiveContains(searchText)
            }
        }

        return items
    }

    private var groupedItems: [(String, [ScanHistoryItem])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: filteredItems) { item -> String in
            if calendar.isDateInToday(item.scanDate) {
                return "Today, \(item.scanDate.formatted(.dateTime.month(.wide).year()))"
            } else {
                return item.scanDate.formatted(.dateTime.month(.wide).day().year())
            }
        }
        return grouped.sorted { lhs, rhs in
            guard let lhsDate = lhs.value.first?.scanDate,
                  let rhsDate = rhs.value.first?.scanDate else { return false }
            return lhsDate > rhsDate
        }
    }

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24) {
                    statsOverview
                    searchAndFilter
                    scanList
                }
                .padding(.bottom, 32)
            }
        }
    }

    // MARK: - Stats Overview

    private var statsOverview: some View {
        VStack(spacing: 16) {
            // Total scans card
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("PLANT SCANS COMPLETED")
                        .font(.label)
                        .tracking(1.5)
                        .foregroundColor(.accentBrown)

                    Text("\(scanItems.count)")
                        .font(.custom("Manrope", size: 40, relativeTo: .largeTitle).weight(.heavy))
                        .foregroundColor(.textPrimary)

                    // Category filter pills
                    HStack(spacing: 8) {
                        ForEach(categories, id: \.self) { category in
                            CategoryPill(
                                title: category,
                                isSelected: (selectedCategory ?? "All") == category
                            ) {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedCategory = category == "All" ? nil : category
                                }
                            }
                        }
                    }
                    .padding(.top, 4)
                }

                Spacer()

                // Plant graphic
                ZStack {
                    Circle()
                        .fill(Color.lightGreenTint.opacity(0.5))
                        .frame(width: 88, height: 88)
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.primaryGreen, .secondaryGreen],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
            }
            .padding(24)
            .background(Color.surfaceLight)
            .cornerRadius(24)
            .padding(.horizontal, 20)

            // Diagnosis accuracy stat
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Diagnosis Accuracy")
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                    Text("99.2%")
                        .font(.heading2)
                        .foregroundColor(.primaryGreen)
                }

                Spacer()

                ZStack {
                    Circle()
                        .stroke(Color.surfaceDark, lineWidth: 4)
                        .frame(width: 48, height: 48)
                    Circle()
                        .trim(from: 0, to: 0.992)
                        .stroke(Color.primaryGreen, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                        .frame(width: 48, height: 48)
                        .rotationEffect(.degrees(-90))
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.primaryGreen)
                }
            }
            .padding(20)
            .background(Color.surfaceLight)
            .cornerRadius(24)
            .padding(.horizontal, 20)
        }
        .padding(.top, 16)
    }

    // MARK: - Search & Filter

    private var searchAndFilter: some View {
        HStack(spacing: 12) {
            // Search bar
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16))
                    .foregroundColor(.textSecondary)

                TextField("Search plant or disease...", text: $searchText)
                    .font(.bodySmall)
                    .foregroundColor(.textPrimary)

                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.textSecondary)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.surfaceLight)
            .cornerRadius(12)

            // Filter button
            Button {
                // Filter action
            } label: {
                Image(systemName: "line.3.horizontal.decrease")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primaryGreen)
                    .frame(width: 48, height: 48)
                    .background(Color.lightGreenTint.opacity(0.4))
                    .cornerRadius(12)
            }
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Scan List

    private var scanList: some View {
        LazyVStack(spacing: 0) {
            ForEach(groupedItems, id: \.0) { dateLabel, items in
                // Date separator
                dateSeparator(dateLabel)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 12)

                ForEach(items) { item in
                    ScanHistoryCard(item: item)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 12)
                }
            }

            if filteredItems.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 40))
                        .foregroundColor(.surfaceDark)
                    Text("No scans found")
                        .font(.heading4)
                        .foregroundColor(.textSecondary)
                    Text("Try adjusting your search or filters.")
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                }
                .padding(.vertical, 48)
            }
        }
    }

    // MARK: - Date Separator

    private func dateSeparator(_ label: String) -> some View {
        HStack(spacing: 12) {
            Text(label)
                .font(.label)
                .foregroundColor(.textSecondary)

            VStack {
                Divider()
            }
        }
    }
}

// MARK: - Category Pill

private struct CategoryPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption2)
                .foregroundColor(isSelected ? .white : .textSecondary)
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(isSelected ? Color.primaryGreen : Color.surfaceMedium)
                .cornerRadius(20)
        }
    }
}

// MARK: - Scan History Card

private struct ScanHistoryCard: View {
    let item: ScanHistoryItem

    var body: some View {
        HStack(spacing: 14) {
            // Plant image placeholder
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.lightGreenTint.opacity(0.4))
                    .frame(width: 72, height: 72)

                Image(systemName: item.systemImage)
                    .font(.system(size: 28))
                    .foregroundColor(.primaryGreen)
            }

            // Info
            VStack(alignment: .leading, spacing: 6) {
                Text(item.plantName)
                    .font(.heading4)
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)

                // Date and time
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: 11))
                    Text(item.scanDate.formatted(.dateTime.month(.abbreviated).day().hour().minute()))
                        .font(.caption2)
                }
                .foregroundColor(.textSecondary)

                // Tags
                HStack(spacing: 6) {
                    TagChip(text: item.diseaseName, color: .accentBrown)
                    TagChip(text: item.category, color: .secondaryGreen)
                }
            }

            Spacer()

            // Status badge
            StatusBadge(status: item.status)
        }
        .padding(16)
        .background(Color.surfaceLight)
        .cornerRadius(24)
    }
}

// MARK: - Tag Chip

private struct TagChip: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(.system(size: 10, weight: .semibold))
            .foregroundColor(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(color.opacity(0.12))
            .cornerRadius(6)
    }
}

// MARK: - Status Badge

private struct StatusBadge: View {
    let status: ScanHistoryItem.ScanStatus

    var body: some View {
        Text(status.rawValue)
            .font(.system(size: 9, weight: .bold))
            .foregroundColor(status.color)
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(status.backgroundColor)
            .cornerRadius(8)
            .fixedSize()
    }
}

// MARK: - Mock Data

extension ScanHistoryItem {
    static let mockData: [ScanHistoryItem] = {
        let calendar = Calendar.current
        let now = Date()

        let todayMorning = calendar.date(bySettingHour: 9, minute: 32, second: 0, of: now)!
        let todayAfternoon = calendar.date(bySettingHour: 14, minute: 15, second: 0, of: now)!
        let todayEvening = calendar.date(bySettingHour: 17, minute: 48, second: 0, of: now)!

        let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: now)!
        let threeDaysAgo = calendar.date(byAdding: .day, value: -3, to: now)!

        let twoWeeksAgo = calendar.date(byAdding: .day, value: -14, to: now)!
        let threeWeeksAgo = calendar.date(byAdding: .day, value: -21, to: now)!
        let fourWeeksAgo = calendar.date(byAdding: .day, value: -28, to: now)!

        return [
            ScanHistoryItem(
                plantName: "Tomato Plant",
                diseaseName: "Early Blight",
                scanDate: todayMorning,
                category: "Vegetable",
                status: .treatmentInProgress,
                healthScore: 62,
                systemImage: "camera.macro"
            ),
            ScanHistoryItem(
                plantName: "Basil",
                diseaseName: "Healthy",
                scanDate: todayAfternoon,
                category: "Vegetable",
                status: .healthy,
                healthScore: 97,
                systemImage: "leaf.fill"
            ),
            ScanHistoryItem(
                plantName: "Strawberry",
                diseaseName: "Leaf Scorch",
                scanDate: todayEvening,
                category: "Fruit",
                status: .critical,
                healthScore: 28,
                systemImage: "camera.macro"
            ),
            ScanHistoryItem(
                plantName: "Pepper Bell",
                diseaseName: "Bacterial Spot",
                scanDate: twoDaysAgo,
                category: "Vegetable",
                status: .treatmentInProgress,
                healthScore: 55,
                systemImage: "camera.macro"
            ),
            ScanHistoryItem(
                plantName: "Apple Tree",
                diseaseName: "Cedar Rust",
                scanDate: threeDaysAgo,
                category: "Fruit",
                status: .treatmentInProgress,
                healthScore: 48,
                systemImage: "tree.fill"
            ),
            ScanHistoryItem(
                plantName: "Corn Stalk",
                diseaseName: "Healthy",
                scanDate: twoWeeksAgo,
                category: "Vegetable",
                status: .healthy,
                healthScore: 94,
                systemImage: "leaf.fill"
            ),
            ScanHistoryItem(
                plantName: "Grape Vine",
                diseaseName: "Black Rot",
                scanDate: threeWeeksAgo,
                category: "Fruit",
                status: .critical,
                healthScore: 31,
                systemImage: "camera.macro"
            ),
            ScanHistoryItem(
                plantName: "Potato Plant",
                diseaseName: "Late Blight",
                scanDate: fourWeeksAgo,
                category: "Vegetable",
                status: .treatmentInProgress,
                healthScore: 44,
                systemImage: "camera.macro"
            ),
        ]
    }()
}

// MARK: - Preview

#Preview {
    HistoryView()
}
