import SwiftUI

public struct SpiderWebChartView: View {
    let data: [Double]
    let categories: [String]
    let divisions: Int
    let gridColor: Color
    let plotFillColor: Color
    let plotStrokeColor: Color

    public init(
        data: [Double],
        categories: [String],
        divisions: Int = 4,
        gridColor: Color = .gray,
        plotFillColor: Color = .blue,
        plotStrokeColor: Color = .blue
    ) {
        self.data = data
        self.categories = categories
        self.divisions = divisions
        self.gridColor = gridColor
        self.plotFillColor = plotFillColor
        self.plotStrokeColor = plotStrokeColor
    }

    public var body: some View {
        ZStack {
            // Draw the grid
            RadarChartGrid(numberOfCategories: categories.count, divisions: divisions)
                .stroke(gridColor.opacity(0.5), lineWidth: 1)

            // Draw the data plot
            let plot = RadarChartDataPlot(data: data, numberOfCategories: categories.count)
            plot.fill(plotFillColor.opacity(0.6))
                .overlay(plot.stroke(plotStrokeColor, lineWidth: 2))

            // Add category labels (optional, but good for clarity)
            ForEach(0..<categories.count, id: \.self) { index in
                Text(categories[index])
                    .font(.caption)
                    .offset(labelOffset(for: index))
            }
        }
        .frame(width: 200, height: 200) // Set a fixed size for the chart
    }

    // Helper to position labels
    private func labelOffset(for index: Int) -> CGSize {
        let radius: CGFloat = 110 // Slightly larger than chart radius
        let angleIncrement = .pi * 2 / CGFloat(categories.count)
        let angle = angleIncrement * CGFloat(index) - .pi / 2
        return CGSize(
            width: radius * cos(angle),
            height: radius * sin(angle)
        )
    }
}

// Example Usage in a ContentView
#Preview {
    let sampleData: [Double] = [0.8, 0.6, 0.9, 0.4, 0.7] // Example data
    let sampleCategories: [String] = ["Strength", "Speed", "Agility", "Stamina", "Flexibility"]

    return SpiderWebChartView(data: sampleData, categories: sampleCategories)
}
