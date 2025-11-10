import SwiftUI
import DataVisualizations

struct SpiderWebChartDemoView: View {
    private struct ChartData: Identifiable {
        let id = UUID()
        var category: String
        var rawValue: Double
    }

    private struct DemoDataSet: Identifiable {
        let id = UUID()
        var data: [ChartData]
        var fillColor: Color
        var strokeColor: Color
    }

    private let maxScore: Double = 150
    private let defaultScore: Double = 100
    private let initialCategories = ["Strength", "Speed", "Agility", "Stamina", "Flexibility"]

    @State private var datasets: [DemoDataSet] = []

    // State for colors and UI
    @State private var gridColor: Color = .gray
    @State private var gridLineWidth: CGFloat = 1.0
    @State private var isDarkMode = false
    @State private var labelStyle: LabelStyle = .default
    @State private var fontWeight: Font.Weight = .regular

    enum LabelStyle: String, CaseIterable, Identifiable {
        case `default`
        case custom
        var id: String { self.rawValue }
    }

    enum FontWeightOption: String, CaseIterable, Identifiable {
        case thin, light, regular, medium, semibold, bold, heavy, black
        var id: String { self.rawValue }
        var weight: Font.Weight {
            switch self {
            case .thin: return .thin
            case .light: return .light
            case .regular: return .regular
            case .medium: return .medium
            case .semibold: return .semibold
            case .bold: return .bold
            case .heavy: return .heavy
            case .black: return .black
            }
        }
    }

    private var spiderChartDataSets: [SpiderChartDataSet] {
        datasets.map { demoSet in
            let dataPoints = demoSet.data.map { chartData in
                SpiderChartDataPoint(category: chartData.category, value: chartData.rawValue / maxScore)
            }
            return SpiderChartDataSet(dataPoints: dataPoints, fillColor: demoSet.fillColor, strokeColor: demoSet.strokeColor)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                chartView
                Spacer()
            }
            .padding()
            .frame(height: 350)

            Form {
                Section(header: Text("Global Settings")) {
                    Toggle("Enable Dark Mode", isOn: $isDarkMode)
                    Picker("Label Style", selection: $labelStyle) {
                        ForEach(LabelStyle.allCases) { Text($0.rawValue.capitalized).tag($0) }
                    }
                    if labelStyle == .default {
                        Picker("Font Weight", selection: $fontWeight) {
                            ForEach(FontWeightOption.allCases) { Text($0.rawValue.capitalized).tag($0.weight) }
                        }
                    }
                    ColorPicker("Grid Color", selection: $gridColor)
                    VStack(alignment: .leading) {
                        Text("Grid Line Width: \(gridLineWidth, specifier: "%.1f")")
                        Slider(value: $gridLineWidth, in: 0.5...5.0, step: 0.1)
                    }
                }

                Section(header: Text("Axes")) {
                    Stepper("Number of Axes: \(datasets.first?.data.count ?? 0)", onIncrement: addAxis, onDecrement: removeAxis)
                }

                ForEach($datasets) { $dataset in
                    Section(header: Text("Dataset \(datasets.firstIndex(where: { $0.id == dataset.id })! + 1)")) {
                        ColorPicker("Fill Color", selection: $dataset.fillColor)
                        ColorPicker("Stroke Color", selection: $dataset.strokeColor)
                        ForEach($dataset.data) { $point in
                            VStack(alignment: .leading) {
                                Text("\(point.category): \(Int(point.rawValue))")
                                Slider(value: $point.rawValue, in: 0...maxScore, step: 1)
                            }
                        }
                    }
                }

                Button(action: addDataSet) {
                    Label("Add Dataset", systemImage: "plus")
                }
                Button(action: removeLastDataSet) {
                    Label("Remove Last Dataset", systemImage: "minus")
                }
                .disabled(datasets.count <= 1)
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
        .environment(\.colorScheme, isDarkMode ? .dark : .light)
        .onAppear(perform: setupInitialData)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Spider Web Chart")
                    .foregroundColor(.primary)
            }
        }
    }

    @ViewBuilder
    private var chartView: some View {
        switch labelStyle {
        case .default:
            SpiderWebChartView(datasets: spiderChartDataSets)
                .gridColor(gridColor)
                .gridLineWidth(gridLineWidth)
                .font(.system(size: 12, weight: fontWeight))
        case .custom:
            SpiderWebChartView(datasets: spiderChartDataSets) { category, _ in
                Text(category)
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundColor(.purple)
            }
            .gridColor(gridColor)
            .gridLineWidth(gridLineWidth)
        }
    }

    private func setupInitialData() {
        if datasets.isEmpty {
            addDataSet()
        }
    }

    private func addDataSet() {
        let newColor = Color(hue: Double.random(in: 0...1), saturation: 0.8, brightness: 0.9)
        let categories = datasets.first?.data.map { $0.category } ?? initialCategories
        let newData = categories.map { ChartData(category: $0, rawValue: defaultScore) }
        datasets.append(DemoDataSet(data: newData, fillColor: newColor, strokeColor: newColor))
    }

    private func removeLastDataSet() {
        if !datasets.isEmpty {
            datasets.removeLast()
        }
    }

    private func addAxis() {
        guard let firstDataSet = datasets.first, firstDataSet.data.count < 10 else { return }
        let newCategory = "Axis \(firstDataSet.data.count + 1)"
        for i in 0..<datasets.count {
            datasets[i].data.append(ChartData(category: newCategory, rawValue: defaultScore))
        }
    }

    private func removeAxis() {
        guard let firstDataSet = datasets.first, firstDataSet.data.count > 3 else { return }
        for i in 0..<datasets.count {
            datasets[i].data.removeLast()
        }
    }
}

#Preview {
    NavigationView {
        SpiderWebChartDemoView()
    }
}
