import SwiftUI

struct RadarChartDataPlot: Shape {
    var data: [Double] // Data values (normalized between 0 and 1)
    var numberOfCategories: Int

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let radius = min(rect.width, rect.height) / 2
        let angleIncrement = .pi * 2 / CGFloat(numberOfCategories)

        guard !data.isEmpty && data.count == numberOfCategories else { return path }

        // Move to the first data point
        let firstPoint = point(for: 0, value: data[0], radius: radius, center: center, angleIncrement: angleIncrement)
        path.move(to: firstPoint)

        // Draw lines to subsequent data points
        for i in 1..<numberOfCategories {
            let nextPoint = point(for: i, value: data[i], radius: radius, center: center, angleIncrement: angleIncrement)
            path.addLine(to: nextPoint)
        }
        path.closeSubpath()

        return path
    }

    // Helper function to calculate point based on data value
    private func point(for index: Int, value: Double, radius: CGFloat, center: CGPoint, angleIncrement: CGFloat) -> CGPoint {
        let angle = angleIncrement * CGFloat(index) - .pi / 2 // -pi/2 to start at the top
        let currentRadius = radius * CGFloat(value) // Scale radius by data value
        return CGPoint(
            x: center.x + currentRadius * cos(angle),
            y: center.y + currentRadius * sin(angle)
        )
    }
}
