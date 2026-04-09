import SwiftUI

enum GradientButtonStyle {
    case filled
    case outlined
}

struct GradientButton: View {
    let title: String
    var isLoading: Bool = false
    var style: GradientButtonStyle = .filled
    var icon: String? = nil
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .tint(style == .filled ? .white : .primaryGreen)
                } else {
                    if let icon = icon {
                        Image(systemName: icon)
                    }
                    Text(title)
                        .font(.button)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 56)
            .foregroundColor(style == .filled ? .white : .primaryGreen)
            .background(
                Group {
                    if style == .filled {
                        LinearGradient(
                            colors: [.primaryGreen, .secondaryGreen],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    } else {
                        Color.clear
                    }
                }
            )
            .cornerRadius(12)
            .overlay(
                Group {
                    if style == .outlined {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.primaryGreen, lineWidth: 1.5)
                    }
                }
            )
        }
        .disabled(isLoading)
    }
}
