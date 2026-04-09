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

            CareTipsView()
                .tabItem {
                    Label("Tips", systemImage: "leaf")
                }
                .tag(1)

            ScanView()
                .tabItem {
                    Label("Scan", systemImage: "camera.fill")
                }
                .tag(2)

            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock")
                }
                .tag(3)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(4)
        }
        .tint(.primaryGreen)
        .accessibilityIdentifier("MainTabView")
    }
}

