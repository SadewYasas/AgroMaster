import SwiftUI

extension Font {
    // MARK: - Headings (Manrope)
    // Variable font: use "Manrope" family name with weight modifiers

    static let heading1 = Font.custom("Manrope", size: 36, relativeTo: .largeTitle).weight(.heavy)
    static let heading1Large = Font.custom("Manrope", size: 48, relativeTo: .largeTitle).weight(.heavy)
    static let heading2 = Font.custom("Manrope", size: 24, relativeTo: .title).weight(.bold)
    static let heading2Large = Font.custom("Manrope", size: 30, relativeTo: .title).weight(.bold)
    static let heading3 = Font.custom("Manrope", size: 20, relativeTo: .title2).weight(.bold)
    static let heading4 = Font.custom("Manrope", size: 18, relativeTo: .title3).weight(.bold)

    // MARK: - Body (Inter)
    // Variable font: use "Inter" family name with weight modifiers

    static let bodyRegular = Font.custom("Inter", size: 16, relativeTo: .body)
    static let bodySmall = Font.custom("Inter", size: 14, relativeTo: .subheadline)
    static let label = Font.custom("Inter", size: 12, relativeTo: .caption).weight(.semibold)
    static let caption2 = Font.custom("Inter", size: 12, relativeTo: .caption).weight(.medium)
    static let button = Font.custom("Inter", size: 16, relativeTo: .body).weight(.semibold)
}
