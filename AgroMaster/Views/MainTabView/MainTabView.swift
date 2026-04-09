import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)

            ScanView()
                .tabItem {
                    Label("Scan", systemImage: "camera.viewfinder")
                }
                .tag(1)

            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }
                .tag(2)

            CareTipsView()
                .tabItem {
                    Label("Tips", systemImage: "leaf.fill")
                }
                .tag(3)

            NearbySupportView()
                .tabItem {
                    Label("Support", systemImage: "map.fill")
                }
                .tag(4)
        }
        .tint(.primaryGreen)
        .accessibilityIdentifier("MainTabView")
    }
}

