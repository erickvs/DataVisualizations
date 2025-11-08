import SwiftUI

public struct SpiderWebChartView: View {
    let data: [Double] // Normalized data (0.0 to 1.0)
    let categories: [String] // Labels for each axis
    let divisions: Int = 4 // Number of concentric circles

    public init(data: [Double], categories: [String], divisions: Int = 4) {
        self.data = data
        self.categories = categories
        self.divisions = divisions
    }

    public var body: some View {
        ZStack {
            // Draw the grid
            RadarChartGrid(numberOfCategories: categories.count, divisions: divisions)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)

            // Draw the data plot
            RadarChartDataPlot(data: data, numberOfCategories: categories.count)
                .fill(Color.blue.opacity(0.6))
                .stroke(Color.blue, lineWidth: 2)

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
