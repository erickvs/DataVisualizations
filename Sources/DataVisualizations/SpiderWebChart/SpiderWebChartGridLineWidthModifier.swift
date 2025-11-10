import SwiftUI

struct GridLineWidthModifier: ViewModifier {
    let lineWidth: CGFloat

    func body(content: Content) -> some View {
        content
            .environment(\.gridLineWidth, lineWidth)
    }
}

public extension View {
    /// Sets the line width of the grid for the spider web chart.
    /// - Parameter lineWidth: The line width to use for the grid.
    /// - Returns: A view that has the grid line width set.
    func gridLineWidth(_ lineWidth: CGFloat) -> some View {
        self.modifier(GridLineWidthModifier(lineWidth: lineWidth))
    }
}
