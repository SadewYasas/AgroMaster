import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    // MARK: - Design System Colors

    static let primaryGreen = Color(hex: "0D631B")
    static let secondaryGreen = Color(hex: "2E7D32")
    static let appBackground = Color(hex: "FBF9F8")
    static let surfaceLight = Color(hex: "F5F3F3")
    static let surfaceMedium = Color(hex: "EAE8E7")
    static let surfaceDark = Color(hex: "E4E2E1")
    static let textPrimary = Color(hex: "1B1C1C")
    static let textSecondary = Color(hex: "40493D")
    static let accentBrown = Color(hex: "79564B")
    static let alertRed = Color(hex: "BA1A1A")
    static let coral = Color(hex: "FED0C1")
    static let lightGreenTint = Color(hex: "CBFFC2")
}
