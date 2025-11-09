import SwiftUI
import DataVisualizations

struct SpiderWebChartDemoView: View {
    // A private struct to manage the state of each data point within the demo
    private struct ChartData: Identifiable {
        let id = UUID()
        var category: String
        var rawValue: Double
    }

    private let maxScore: Double = 150
    private let defaultScore: Double = 100

    // Single source of truth for chart data
    @State private var chartData: [ChartData] = [
        .init(category: "Strength", rawValue: 120),
        .init(category: "Speed", rawValue: 80),
        .init(category: "Agility", rawValue: 135),
        .init(category: "Stamina", rawValue: 90),
        .init(category: "Flexibility", rawValue: 100)
    ]

    // State for colors and UI
    @State private var gridColor: Color = .gray
    @State private var plotFillColor: Color = .blue
    @State private var plotStrokeColor: Color = .blue
    @State private var isDarkMode = false

    // Computed property to convert demo data to package data structure
    private var spiderChartDataPoints: [SpiderChartDataPoint] {
        chartData.map { SpiderChartDataPoint(category: $0.category, value: $0.rawValue / maxScore) }
    }

    var body: some View {
        VStack(spacing: 0) {
            // --- Static Chart View ---
            HStack {
                Spacer()
                SpiderWebChartView(
                    data: spiderChartDataPoints,
                    gridColor: gridColor,
                    plotFillColor: plotFillColor,
                    plotStrokeColor: plotStrokeColor
                )
                Spacer()
            }
            .padding()
            .frame(height: 350)

            // --- Scrollable Controls ---
            Form {
                Section(header: Text("Appearance")) {
                    Toggle("Enable Dark Mode", isOn: $isDarkMode)
                    ColorPicker("Grid Color", selection: $gridColor)
                    ColorPicker("Fill Color", selection: $plotFillColor)
                    ColorPicker("Stroke Color", selection: $plotStrokeColor)
                }
                
                Section(header: Text("Data")) {
                    Stepper("Number of Axes: \(chartData.count)", onIncrement: addAxis, onDecrement: removeAxis)
                    
                    ForEach($chartData) { $point in
                        VStack(alignment: .leading) {
                            Text("\(point.category): \(Int(point.rawValue))")
                            Slider(
                                value: $point.rawValue,
                                in: 0...maxScore,
                                step: 1
                            )
                        }
                    }
                }
            }
        }
        .navigationTitle("Spider Web Chart")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(UIColor.systemGroupedBackground))
        .environment(\.colorScheme, isDarkMode ? .dark : .light)
    }
    
    private func addAxis() {
        guard chartData.count < 10 else { return } // Use a max limit
        let newCategory = "Axis \(chartData.count + 1)"
        chartData.append(.init(category: newCategory, rawValue: defaultScore))
    }
    
    private func removeAxis() {
        guard chartData.count > 3 else { return } // Use a min limit
        chartData.removeLast()
    }
}

#Preview {
    NavigationView {
        SpiderWebChartDemoView()
    }
}
