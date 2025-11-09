import SwiftUI

public struct SpiderWebChartView<Label: View>: View {
    let data: [SpiderChartDataPoint]
    let divisions: Int
    let gridColor: Color
    let plotFillColor: Color
    let plotStrokeColor: Color
    let labelContent: (String, Int) -> Label

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
        plotStrokeColor: Color = .blue,
        @ViewBuilder labelContent: @escaping (String, Int) -> Label
    ) {
        self.data = data
        self.divisions = divisions
        self.gridColor = gridColor
        self.plotFillColor = plotFillColor
        self.plotStrokeColor = plotStrokeColor
        self.labelContent = labelContent
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

            // Add custom labels
            ForEach(categories.indices, id: \.self) { index in
                labelContent(categories[index], index)
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

// Extension for default Text label
public extension SpiderWebChartView where Label == Text {
    init(
        data: [SpiderChartDataPoint],
        divisions: Int = 4,
        gridColor: Color = .gray,
        plotFillColor: Color = .blue,
        plotStrokeColor: Color = .blue
    ) {
        self.init(
            data: data,
            divisions: divisions,
            gridColor: gridColor,
            plotFillColor: plotFillColor,
            plotStrokeColor: plotStrokeColor
        ) { category, _ in
            Text(category)
                .font(.caption)
        }
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

    // Example with default labels
    return SpiderWebChartView(data: sampleData)
    
    // Example with custom labels
//    SpiderWebChartView(data: sampleData) { category, index in
//        Text(category)
//            .font(.headline)
//            .foregroundColor(.red)
//    }
}
