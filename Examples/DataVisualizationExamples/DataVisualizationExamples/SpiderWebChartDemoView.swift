import SwiftUI
import DataVisualizations

struct SpiderWebChartDemoView: View {
    // Master list of all possible categories
    private let allCategories = [
        "Strength", "Speed", "Agility", "Stamina", "Flexibility",
        "Power", "Endurance", "Balance", "Coordination", "Accuracy"
    ]
    private let maxScore: Double = 150
    private let defaultScore: Double = 100

    // State for the data and number of axes
    @State private var numberOfAxes: Int = 5
    @State private var rawData: [Double] = [120, 80, 135, 90, 100]

    // State for colors
    @State private var gridColor: Color = .gray
    @State private var plotFillColor: Color = .blue
    @State private var plotStrokeColor: Color = .blue
    
    // State for UI
    @State private var isDarkMode = false

    // Computed properties based on the number of axes
    private var currentCategories: [String] {
        Array(allCategories.prefix(numberOfAxes))
    }
    private var normalizedData: [Double] {
        rawData.map { $0 / maxScore }
    }

    var body: some View {
        VStack(spacing: 0) {
            // --- Static Chart View ---
            HStack {
                Spacer()
                SpiderWebChartView(
                    data: normalizedData,
                    categories: currentCategories,
                    gridColor: gridColor,
                    plotFillColor: plotFillColor,
                    plotStrokeColor: plotStrokeColor
                )
                Spacer()
            }
            .padding()
            .frame(height: 350) // Give it a fixed height

            // --- Scrollable Controls ---
            Form {
                Section(header: Text("Appearance")) {
                    Toggle("Enable Dark Mode", isOn: $isDarkMode)
                    ColorPicker("Grid Color", selection: $gridColor)
                    ColorPicker("Fill Color", selection: $plotFillColor)
                    ColorPicker("Stroke Color", selection: $plotStrokeColor)
                }
                
                Section(header: Text("Data")) {
                    Stepper("Number of Axes: \(numberOfAxes)", value: $numberOfAxes, in: 3...10)
                    
                    ForEach(currentCategories.indices, id: \.self) { index in
                        VStack(alignment: .leading) {
                            Text("\(currentCategories[index]): \(Int(rawData[index]))")
                            Slider(
                                value: $rawData[index],
                                in: 0...maxScore,
                                step: 1
                            )
                        }
                    }
                }
            }
        }
        .onChange(of: numberOfAxes) { oldValue, newValue in
            let difference = newValue - oldValue
            if difference > 0 {
                // Add new data points
                for _ in 0..<difference {
                    rawData.append(defaultScore)
                }
            } else if difference < 0 {
                // Remove data points
                rawData.removeLast(abs(difference))
            }
        }
        .navigationTitle("Spider Web Chart")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(UIColor.systemGroupedBackground)) // Match Form background
        .environment(\.colorScheme, isDarkMode ? .dark : .light)
    }
}

#Preview {
    NavigationView {
        SpiderWebChartDemoView()
    }
}
