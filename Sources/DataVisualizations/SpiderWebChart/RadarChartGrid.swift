import SwiftUI

struct RadarChartGrid: Shape {
    var numberOfCategories: Int // Number of axes
    var divisions: Int // Number of concentric divisions

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let radius = min(rect.width, rect.height) / 2
        let angleIncrement = .pi * 2 / CGFloat(numberOfCategories)

        // Draw concentric polygons (the "web")
        for i in 1...divisions {
            let currentRadius = radius * CGFloat(i) / CGFloat(divisions)
            path.move(to: point(for: 0, radius: currentRadius, center: center, angleIncrement: angleIncrement))
            for j in 1..<numberOfCategories {
                path.addLine(to: point(for: j, radius: currentRadius, center: center, angleIncrement: angleIncrement))
            }
            path.closeSubpath()
        }

        // Draw radial lines (axes)
        for i in 0..<numberOfCategories {
            path.move(to: center)
            path.addLine(to: point(for: i, radius: radius, center: center, angleIncrement: angleIncrement))
        }

        return path
    }

    // Helper function to calculate point on a circle
    private func point(for index: Int, radius: CGFloat, center: CGPoint, angleIncrement: CGFloat) -> CGPoint {
        let angle = angleIncrement * CGFloat(index) - .pi / 2 // -pi/2 to start at the top
        return CGPoint(
            x: center.x + radius * cos(angle),
            y: center.y + radius * sin(angle)
        )
    }
}
