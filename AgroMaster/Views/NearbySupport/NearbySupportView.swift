import SwiftUI
import MapKit

// MARK: - Nearby Support View

struct NearbySupportView: View {
    @StateObject private var viewModel = LocationViewModel()
    @State private var showDetail = false

    var body: some View {
        ZStack(alignment: .top) {
            Color.appBackground.ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    mapSection
                    searchFilterBar
                        .offset(y: -28)
                        .zIndex(1)
                    resultsSection
                        .padding(.top, -12)
                }
            }
        }
        .sheet(isPresented: $showDetail) {
            if let center = viewModel.selectedCenter {
                SupportCenterDetailView(
                    center: center,
                    distance: viewModel.distanceFromUser(to: center)
                )
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
            }
        }
    }

    // MARK: - Map Section

    private var mapSection: some View {
        ZStack(alignment: .topTrailing) {
            Map(coordinateRegion: $viewModel.region,
                showsUserLocation: true,
                annotationItems: viewModel.filteredCenters
            ) { center in
                MapAnnotation(coordinate: center.coordinate) {
                    Button {
                        viewModel.selectedCenter = center
                        showDetail = true
                    } label: {
                        VStack(spacing: 0) {
                            ZStack {
                                Circle()
                                    .fill(Color.primaryGreen)
                                    .frame(width: 36, height: 36)
                                    .shadow(color: .primaryGreen.opacity(0.4), radius: 6, x: 0, y: 3)

                                Image(systemName: center.icon)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                            }

                            Image(systemName: "triangle.fill")
                                .font(.system(size: 10))
                                .foregroundColor(.primaryGreen)
                                .rotationEffect(.degrees(180))
                                .offset(y: -3)
                        }
                    }
                }
            }
            .frame(height: 340)
            .cornerRadius(0)

            // Map controls
            VStack(spacing: 12) {
                Button {
                    if let userLocation = viewModel.userLocation {
                        withAnimation {
                            viewModel.region.center = userLocation
                        }
                    }
                } label: {
                    Image(systemName: "location.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primaryGreen)
                        .frame(width: 44, height: 44)
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                }

                Button {
                    withAnimation {
                        viewModel.region = MKCoordinateRegion(
                            center: viewModel.region.center,
                            span: MKCoordinateSpan(latitudeDelta: 0.06, longitudeDelta: 0.06)
                        )
                    }
                } label: {
                    Image(systemName: "compass")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.textPrimary)
                        .frame(width: 44, height: 44)
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                }
            }
            .padding(.trailing, 16)
            .padding(.top, 60)
        }
    }

    // MARK: - Search & Filter Bar

    private var searchFilterBar: some View {
        HStack(spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.textSecondary)

                TextField("Search for centers or nurseries...", text: $viewModel.searchText)
                    .font(.bodySmall)
                    .foregroundColor(.textPrimary)

                if !viewModel.searchText.isEmpty {
                    Button {
                        viewModel.searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.textSecondary)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(.ultraThinMaterial)
            .cornerRadius(16)

            Button {
                // Filter action
            } label: {
                Image(systemName: "line.3.horizontal.decrease")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primaryGreen)
                    .frame(width: 52, height: 52)
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
            }
        }
        .padding(.horizontal, 20)
        .shadow(color: .black.opacity(0.08), radius: 16, x: 0, y: 8)
    }

    // MARK: - Results Section

    private var resultsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section header
            VStack(alignment: .leading, spacing: 8) {
                Text("AGRICULTURAL SUPPORT")
                    .font(.label)
                    .tracking(2)
                    .foregroundColor(.accentBrown)
                    .textCase(.uppercase)

                Text("Nearby Support")
                    .font(.heading2)
                    .foregroundColor(.textPrimary)
            }
            .padding(.horizontal, 20)

            // Distance filter pill
            HStack(spacing: 6) {
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primaryGreen)

                Text("Within 5 km")
                    .font(.caption2)
                    .foregroundColor(.textPrimary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Color.lightGreenTint.opacity(0.5))
            .cornerRadius(20)
            .padding(.horizontal, 20)

            // Center cards
            if viewModel.isLoading {
                VStack(spacing: 16) {
                    ProgressView()
                        .tint(.primaryGreen)
                    Text("Finding nearby centers...")
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else if viewModel.filteredCenters.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 32))
                        .foregroundColor(.textSecondary.opacity(0.5))

                    Text("No centers found")
                        .font(.heading4)
                        .foregroundColor(.textPrimary)

                    Text("Try adjusting your search terms.")
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.filteredCenters) { center in
                        SupportCenterCard(
                            center: center,
                            distance: viewModel.distanceFromUser(to: center),
                            onSelect: {
                                viewModel.selectedCenter = center
                                showDetail = true
                            },
                            onDirections: {
                                openDirections(to: center)
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
            }

            Spacer(minLength: 40)
        }
    }

    // MARK: - Helpers

    private func openDirections(to center: SupportCenter) {
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: center.coordinate))
        destination.name = center.name
        destination.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
}

// MARK: - Support Center Card

private struct SupportCenterCard: View {
    let center: SupportCenter
    let distance: String
    let onSelect: () -> Void
    let onDirections: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Top row: icon + distance badge
            HStack(alignment: .top) {
                ZStack {
                    Circle()
                        .fill(Color.lightGreenTint)
                        .frame(width: 52, height: 52)

                    Image(systemName: center.icon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.primaryGreen)
                }

                Spacer()

                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 10, weight: .semibold))
                    Text(distance)
                        .font(.caption2)
                }
                .foregroundColor(.secondaryGreen)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.lightGreenTint.opacity(0.5))
                .cornerRadius(20)
            }

            // Center name
            Text(center.name)
                .font(.heading3)
                .foregroundColor(.textPrimary)

            // Description
            Text(center.description)
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
                .lineSpacing(3)
                .lineLimit(3)

            // Category pills
            HStack(spacing: 8) {
                ForEach(center.categories, id: \.self) { category in
                    Text(category)
                        .font(.caption2)
                        .foregroundColor(.accentBrown)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.accentBrown.opacity(0.1))
                        .cornerRadius(16)
                }
            }

            // Divider
            Rectangle()
                .fill(Color.surfaceDark)
                .frame(height: 1)

            // Actions row
            HStack {
                Button(action: onDirections) {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Directions")
                            .font(.bodySmall.weight(.semibold))
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 11, weight: .bold))
                    }
                    .foregroundColor(.primaryGreen)
                }

                Spacer()

                GradientButton(title: "Get Details", icon: "info.circle") {
                    onSelect()
                }
                .frame(width: 160)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 32)
                .fill(.white)
                .shadow(color: .black.opacity(0.04), radius: 12, x: 0, y: 4)
        )
    }
}

// MARK: - Preview

#Preview {
    NearbySupportView()
}
