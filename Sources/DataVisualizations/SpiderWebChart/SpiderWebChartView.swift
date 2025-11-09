import SwiftUI

public struct SpiderWebChartView: View {
    let data: [SpiderChartDataPoint]
    let divisions: Int
    let gridColor: Color
    let plotFillColor: Color
    let plotStrokeColor: Color

    // Computed properties
    private var categories: [String] {
        data.map { $0.category }
    }
    private var values: [Double] {
        data.map { $0.value }
    }

    public init(
        data: [SpiderChartDataPoint],
        divisions: Int = 4,
        gridColor: Color = .gray,
        plotFillColor: Color = .blue,
        plotStrokeColor: Color = .blue
    ) {
        self.data = data
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
            let plot = RadarChartDataPlot(data: values, numberOfCategories: categories.count)
            plot.fill(plotFillColor.opacity(0.6))
                .overlay(plot.stroke(plotStrokeColor, lineWidth: 2))

            // Add category labels (optional, but good for clarity)
            ForEach(categories.indices, id: \.self) { index in
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
    let sampleData: [SpiderChartDataPoint] = [
        .init(category: "Strength", value: 0.8),
        .init(category: "Speed", value: 0.6),
        .init(category: "Agility", value: 0.9),
        .init(category: "Stamina", value: 0.4),
        .init(category: "Flexibility", value: 0.7)
    ]

    return SpiderWebChartView(data: sampleData)
}
