import SwiftUI
import UserNotifications

struct ReminderSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel

    @AppStorage("alertsEnabled") private var alertsEnabled = false
    @AppStorage("reminderFrequency") private var frequency = "daily"
    @AppStorage("preferredHour") private var preferredHour = 8
    @AppStorage("preferredMinute") private var preferredMinute = 0

    @State private var showTimePicker = false

    private var preferredTime: Binding<Date> {
        Binding<Date>(
            get: {
                var components = DateComponents()
                components.hour = preferredHour
                components.minute = preferredMinute
                return Calendar.current.date(from: components) ?? Date()
            },
            set: { newValue in
                let components = Calendar.current.dateComponents([.hour, .minute], from: newValue)
                preferredHour = components.hour ?? 8
                preferredMinute = components.minute ?? 0
                scheduleNotification()
            }
        )
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 28) {
                    header
                    masterToggleCard
                    frequencySection
                    proTipCard
                    preferredTimeSection
                    Spacer(minLength: 32)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showTimePicker) {
            timePickerSheet
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primaryGreen)
                        .frame(width: 40, height: 40)
                        .background(Color.surfaceLight)
                        .cornerRadius(12)
                }

                Spacer()

                ZStack {
                    Circle()
                        .fill(Color.lightGreenTint)
                        .frame(width: 40, height: 40)
                    Image(systemName: "person.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.primaryGreen)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)

            Text("SETTINGS")
                .font(.label)
                .tracking(2)
                .foregroundColor(.accentBrown)
                .padding(.horizontal, 20)

            Text("Reminder\nSettings")
                .font(.heading1)
                .foregroundColor(.textPrimary)
                .padding(.horizontal, 20)

            Text("Configure how and when AgroMaster sends you notifications about plant care, watering schedules, and seasonal tasks.")
                .font(.bodyRegular)
                .foregroundColor(.textSecondary)
                .lineSpacing(4)
                .padding(.horizontal, 20)
        }
    }

    // MARK: - Master Toggle Card

    private var masterToggleCard: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.lightGreenTint)
                    .frame(width: 56, height: 56)
                Image(systemName: "bell.fill")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.primaryGreen)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Enable reminders")
                    .font(.heading3)
                    .foregroundColor(.textPrimary)

                Text("Get real-time alerts for plant care")
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()

            Toggle("", isOn: $alertsEnabled)
                .tint(.primaryGreen)
                .labelsHidden()
                .onChange(of: alertsEnabled) { _, newValue in
                    if newValue {
                        requestNotificationPermission()
                    } else {
                        removeScheduledNotifications()
                    }
                }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
        )
        .padding(.horizontal, 20)
    }

    // MARK: - Frequency Section

    private var frequencySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Frequency options")
                .font(.heading4)
                .foregroundColor(.textPrimary)
                .padding(.horizontal, 20)

            VStack(spacing: 12) {
                frequencyOptionCard(
                    title: "Daily",
                    description: "Get a reminder every day at your preferred time.",
                    iconColor: .primaryGreen,
                    value: "daily"
                )

                frequencyOptionCard(
                    title: "Weekly",
                    description: "Receive a weekly summary each Monday morning.",
                    iconColor: .accentBrown,
                    value: "weekly"
                )
            }
            .padding(.horizontal, 20)
        }
    }

    private func frequencyOptionCard(title: String, description: String, iconColor: Color, value: String) -> some View {
        Button {
            frequency = value
            scheduleNotification()
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 44, height: 44)
                    Image(systemName: "calendar")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(iconColor)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.heading4)
                        .foregroundColor(.textPrimary)

                    Text(description)
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                        .lineSpacing(2)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                ZStack {
                    Circle()
                        .stroke(frequency == value ? Color.primaryGreen : Color.surfaceDark, lineWidth: 2)
                        .frame(width: 24, height: 24)

                    if frequency == value {
                        Circle()
                            .fill(Color.primaryGreen)
                            .frame(width: 14, height: 14)
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(frequency == value ? Color.primaryGreen.opacity(0.05) : .white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(frequency == value ? Color.primaryGreen.opacity(0.3) : Color.clear, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Pro Tip Card

    private var proTipCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.accentBrown)

            Text("Pro Tip")
                .font(.heading3)
                .foregroundColor(.accentBrown)

            Text("Early morning alerts allow you to plan irrigation before peak heat hours.")
                .font(.bodySmall)
                .foregroundColor(.accentBrown.opacity(0.85))
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)

            Button {
                // TODO: Learn more action
            } label: {
                HStack(spacing: 6) {
                    Text("LEARN MORE")
                        .font(.label)
                        .tracking(2)
                        .foregroundColor(.accentBrown)
                    Image(systemName: "arrow.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.accentBrown)
                }
            }
            .buttonStyle(.plain)
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.coral)
        )
        .padding(.horizontal, 20)
    }

    // MARK: - Preferred Time Section

    private var preferredTimeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Preferred Time")
                .font(.heading4)
                .foregroundColor(.textPrimary)

            Text("Select when you'd like to receive your morning summary.")
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
                .lineSpacing(2)

            Button {
                showTimePicker = true
            } label: {
                HStack {
                    Text(preferredTimeDisplayString)
                        .font(.bodyRegular)
                        .foregroundColor(.textPrimary)

                    Spacer()

                    Image(systemName: "chevron.down")
                        .font(.system(size: 14))
                        .foregroundColor(.textSecondary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                )
            }
            .buttonStyle(.plain)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.surfaceLight)
        )
        .padding(.horizontal, 20)
    }

    private var preferredTimeDisplayString: String {
        var components = DateComponents()
        components.hour = preferredHour
        components.minute = preferredMinute
        let date = Calendar.current.date(from: components) ?? Date()

        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let timeString = formatter.string(from: date)

        let label: String
        switch preferredHour {
        case 5...11: label = "Sunrise"
        case 12...16: label = "Midday"
        case 17...20: label = "Evening"
        default: label = "Night"
        }

        return "\(timeString) (\(label))"
    }

    // MARK: - Time Picker Sheet

    private var timePickerSheet: some View {
        VStack(spacing: 24) {
            Text("Preferred Time")
                .font(.heading3)
                .foregroundColor(.textPrimary)
                .padding(.top, 24)

            DatePicker(
                "Reminder Time",
                selection: preferredTime,
                displayedComponents: .hourAndMinute
            )
            .datePickerStyle(.wheel)
            .labelsHidden()

            Button {
                showTimePicker = false
            } label: {
                Text("Done")
                    .font(.heading4)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.primaryGreen)
                    )
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 24)

            Spacer()
        }
        .presentationDetents([.medium])
    }

    // MARK: - Notification Logic

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            DispatchQueue.main.async {
                if granted {
                    scheduleNotification()
                } else {
                    alertsEnabled = false
                }
            }
        }
    }

    private func removeScheduledNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    private func scheduleNotification() {
        guard alertsEnabled else { return }

        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        let content = UNMutableNotificationContent()
        content.title = "AgroMaster Reminder"
        content.body = frequency == "daily"
            ? "Time to check on your plants! Review watering schedules and care tasks."
            : "Here's your weekly plant care summary. Review your tasks for the week ahead."
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = preferredHour
        dateComponents.minute = preferredMinute

        if frequency == "weekly" {
            dateComponents.weekday = 2 // Monday
        }

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(
            identifier: "agromaster_reminder",
            content: content,
            trigger: trigger
        )

        center.add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ReminderSettingsView()
            .environmentObject(AuthViewModel())
    }
}
