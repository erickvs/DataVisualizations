import SwiftUI

// This struct is the actual modifier.
// It holds the new color and applies it to the view's environment.
struct GridColorModifier: ViewModifier {
    let color: Color

    func body(content: Content) -> some View {
        content
            .environment(\.gridColor, color)
    }
}

public extension View {
    /// Sets the color of the grid for the spider web chart.
    /// - Parameter color: The color to use for the grid.
    /// - Returns: A view that has the grid color set.
    func gridColor(_ color: Color) -> some View {
        self.modifier(GridColorModifier(color: color))
    }
}
