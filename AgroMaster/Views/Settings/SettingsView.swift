import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showSignOutConfirmation = false
    @State private var showAbout = false
    @State private var showPrivacy = false
    @State private var showTerms = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 28) {
                        header
                        profileCard
                        preferencesSection
                        appSection
                        accountSection
                        Spacer(minLength: 32)
                    }
                }
            }
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
            .sheet(isPresented: $showAbout) {
                aboutSheet
            }
            .sheet(isPresented: $showPrivacy) {
                infoSheet(title: "Privacy Policy", icon: "lock.shield.fill", text: "AgroMaster respects your privacy. We collect only the data necessary to provide plant care recommendations and reminders. Your scan history and personal information are stored securely and never shared with third parties without your explicit consent. You can request deletion of your data at any time through the app settings or by contacting our support team.")
            }
            .sheet(isPresented: $showTerms) {
                infoSheet(title: "Terms of Service", icon: "doc.text.fill", text: "By using AgroMaster, you agree to our terms of service. The app provides plant disease identification and care recommendations for informational purposes only. While we strive for accuracy, AgroMaster is not a substitute for professional agricultural advice. We reserve the right to update these terms at any time. Continued use of the app constitutes acceptance of any changes.")
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("ACCOUNT")
                .font(.label)
                .tracking(2)
                .foregroundColor(.accentBrown)
                .padding(.horizontal, 20)
                .padding(.top, 16)

            Text("Settings")
                .font(.heading1)
                .foregroundColor(.textPrimary)
                .padding(.horizontal, 20)
        }
    }

    // MARK: - Profile Card

    private var profileCard: some View {
        HStack(spacing: 16) {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.primaryGreen, .secondaryGreen],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(authViewModel.getUserName())
                    .font(.heading3)
                    .foregroundColor(.textPrimary)

                Text(authViewModel.user?.email ?? "No email")
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
            }

            Spacer()
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.surfaceLight)
        )
        .padding(.horizontal, 20)
    }

    // MARK: - Preferences Section

    private var preferencesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Preferences")
                .font(.heading4)
                .foregroundColor(.textSecondary)
                .padding(.horizontal, 20)

            VStack(spacing: 0) {
                NavigationLink {
                    ReminderSettingsView()
                } label: {
                    settingsRow(
                        icon: "bell.fill",
                        iconBackground: Color.primaryGreen,
                        title: "Reminder Settings",
                        showChevron: true
                    )
                }
                .buttonStyle(.plain)

                Divider()
                    .padding(.leading, 64)
                    .padding(.horizontal, 20)

                Button {
                    openNotificationSettings()
                } label: {
                    settingsRow(
                        icon: "bell.badge.fill",
                        iconBackground: Color.alertRed,
                        title: "Notifications",
                        showChevron: true
                    )
                }
                .buttonStyle(.plain)
            }
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.surfaceLight)
            )
            .padding(.horizontal, 20)
        }
    }

    // MARK: - App Section

    private var appSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("App")
                .font(.heading4)
                .foregroundColor(.textSecondary)
                .padding(.horizontal, 20)

            VStack(spacing: 0) {
                Button {
                    showAbout = true
                } label: {
                    settingsRow(
                        icon: "info.circle.fill",
                        iconBackground: Color.secondaryGreen,
                        title: "About AgroMaster",
                        showChevron: true
                    )
                }
                .buttonStyle(.plain)

                Divider()
                    .padding(.leading, 64)
                    .padding(.horizontal, 20)

                Button {
                    showPrivacy = true
                } label: {
                    settingsRow(
                        icon: "lock.fill",
                        iconBackground: Color.accentBrown,
                        title: "Privacy Policy",
                        showChevron: true
                    )
                }
                .buttonStyle(.plain)

                Divider()
                    .padding(.leading, 64)
                    .padding(.horizontal, 20)

                Button {
                    showTerms = true
                } label: {
                    settingsRow(
                        icon: "doc.text.fill",
                        iconBackground: Color.textSecondary,
                        title: "Terms of Service",
                        showChevron: true
                    )
                }
                .buttonStyle(.plain)

                Divider()
                    .padding(.leading, 64)
                    .padding(.horizontal, 20)

                HStack {
                    settingsRow(
                        icon: "app.badge.fill",
                        iconBackground: Color.surfaceDark,
                        title: "Version 1.0",
                        showChevron: false
                    )
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.surfaceLight)
            )
            .padding(.horizontal, 20)
        }
    }

    // MARK: - Account Section

    private var accountSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Account")
                .font(.heading4)
                .foregroundColor(.textSecondary)
                .padding(.horizontal, 20)

            Button {
                showSignOutConfirmation = true
            } label: {
                HStack(spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.alertRed.opacity(0.15))
                            .frame(width: 40, height: 40)
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.alertRed)
                    }

                    Text("Sign Out")
                        .font(.heading4)
                        .foregroundColor(.alertRed)

                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
            }
            .buttonStyle(.plain)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.alertRed.opacity(0.05))
            )
            .padding(.horizontal, 20)
        }
    }

    // MARK: - Settings Row

    private func settingsRow(icon: String, iconBackground: Color, title: String, showChevron: Bool) -> some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(iconBackground.opacity(0.15))
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(iconBackground)
            }

            Text(title)
                .font(.heading4)
                .foregroundColor(.textPrimary)

            Spacer()

            if showChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.textSecondary.opacity(0.5))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }

    // MARK: - Notification Settings

    private func openNotificationSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }

    // MARK: - About Sheet

    private var aboutSheet: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        Spacer(minLength: 20)

                        ZStack {
                            Circle()
                                .fill(Color.primaryGreen.opacity(0.15))
                                .frame(width: 100, height: 100)
                            Image(systemName: "leaf.fill")
                                .font(.system(size: 40, weight: .semibold))
                                .foregroundColor(.primaryGreen)
                        }

                        VStack(spacing: 8) {
                            Text("AgroMaster")
                                .font(.heading2)
                                .foregroundColor(.textPrimary)

                            Text("Version 1.0")
                                .font(.bodySmall)
                                .foregroundColor(.textSecondary)
                        }

                        Text("AgroMaster is your intelligent farming companion. Scan plants to identify diseases, receive personalized care recommendations, and stay on top of your agricultural tasks with smart reminders.")
                            .font(.bodyRegular)
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                            .padding(.horizontal, 32)

                        VStack(spacing: 4) {
                            Text("Built with care for farmers everywhere.")
                                .font(.bodySmall)
                                .foregroundColor(.accentBrown)

                            Text("\u{00A9} 2026 AgroMaster Team")
                                .font(.caption2)
                                .foregroundColor(.textSecondary)
                        }
                        .padding(.top, 8)

                        Spacer(minLength: 40)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        showAbout = false
                    }
                    .font(.button)
                    .foregroundColor(.primaryGreen)
                }
            }
        }
    }

    // MARK: - Info Sheet

    private func infoSheet(title: String, icon: String, text: String) -> some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Spacer(minLength: 12)

                        ZStack {
                            Circle()
                                .fill(Color.accentBrown.opacity(0.15))
                                .frame(width: 64, height: 64)
                            Image(systemName: icon)
                                .font(.system(size: 26, weight: .semibold))
                                .foregroundColor(.accentBrown)
                        }
                        .frame(maxWidth: .infinity)

                        Text(title)
                            .font(.heading2)
                            .foregroundColor(.textPrimary)
                            .frame(maxWidth: .infinity, alignment: .center)

                        Text(text)
                            .font(.bodyRegular)
                            .foregroundColor(.textSecondary)
                            .lineSpacing(6)
                            .padding(.horizontal, 8)

                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 24)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        if title.contains("Privacy") {
                            showPrivacy = false
                        } else {
                            showTerms = false
                        }
                    }
                    .font(.button)
                    .foregroundColor(.primaryGreen)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    SettingsView()
        .environmentObject(AuthViewModel())
}
