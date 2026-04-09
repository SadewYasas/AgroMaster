import SwiftUI

struct CustomSecureField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    @State private var isVisible = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.label)
                .textCase(.uppercase)
                .tracking(1.2)
                .foregroundColor(.textSecondary)

            HStack {
                if isVisible {
                    TextField(placeholder, text: $text)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                } else {
                    SecureField(placeholder, text: $text)
                }

                Button {
                    isVisible.toggle()
                } label: {
                    Image(systemName: isVisible ? "eye.slash" : "eye")
                        .foregroundColor(.textSecondary)
                }
            }
            .font(.bodyRegular)
            .foregroundColor(.textPrimary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}
