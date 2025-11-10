import SwiftUI

public struct SpiderWebChartView<Label: View>: View {
    @Environment(\.gridColor) var gridColor
    @Environment(\.gridLineWidth) var gridLineWidth
    
    let datasets: [SpiderChartDataSet]
    let divisions: Int
    let labelContent: (String, Int) -> Label

    // Computed properties
    private var categories: [String] {
        datasets.first?.dataPoints.map { $0.category } ?? []
    }

    public init(
        datasets: [SpiderChartDataSet],
        divisions: Int = 4,
        @ViewBuilder labelContent: @escaping (String, Int) -> Label
    ) {
        self.datasets = datasets
        self.divisions = divisions
        self.labelContent = labelContent
    }

    public var body: some View {
        ZStack {
            // Draw the grid
            RadarChartGrid(numberOfCategories: categories.count, divisions: divisions)
                .stroke(gridColor.opacity(0.5), lineWidth: gridLineWidth)

            // Draw the data plots
            ForEach(datasets.indices, id: \.self) { index in
                let dataset = datasets[index]
                let values = dataset.dataPoints.map { $0.value }
                let plot = RadarChartDataPlot(data: values, numberOfCategories: categories.count)
                plot.fill(dataset.fillColor.opacity(0.6))
                    .overlay(plot.stroke(dataset.strokeColor, lineWidth: 2))
            }

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
        datasets: [SpiderChartDataSet],
        divisions: Int = 4
    ) {
        self.init(
            datasets: datasets,
            divisions: divisions
        ) { category, _ in
            Text(category)
        }
    }
}

// Example Usage in a ContentView
#Preview {
    let sampleData1: [SpiderChartDataPoint] = [
        .init(category: "Strength", value: 0.8),
        .init(category: "Speed", value: 0.6),
        .init(category: "Agility", value: 0.9),
        .init(category: "Stamina", value: 0.4),
        .init(category: "Flexibility", value: 0.7)
    ]
    
    let sampleData2: [SpiderChartDataPoint] = [
        .init(category: "Strength", value: 0.5),
        .init(category: "Speed", value: 0.9),
        .init(category: "Agility", value: 0.3),
        .init(category: "Stamina", value: 0.8),
        .init(category: "Flexibility", value: 0.5)
    ]
    
    let datasets: [SpiderChartDataSet] = [
        .init(dataPoints: sampleData1, fillColor: .blue, strokeColor: .blue),
        .init(dataPoints: sampleData2, fillColor: .red, strokeColor: .red)
    ]

    // Example with default labels
    return SpiderWebChartView(datasets: datasets)
        .gridColor(.green)
        .gridLineWidth(2.0)
        .font(.headline)
}
