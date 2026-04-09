import SwiftUI

extension AnyTransition {
    static var slideFromRight: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading)
        )
    }

    static var slideFromLeft: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .leading),
            removal: .move(edge: .trailing)
        )
    }

    static var fadeAndScale: AnyTransition {
        AnyTransition.opacity.combined(with: .scale(scale: 0.95))
    }
}
