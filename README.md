# DataVisualizations

A Swift Package for creating beautiful, reusable, and customizable data visualizations in SwiftUI.

## Features

- **SpiderWebChartView**: A highly customizable spider web (or radar) chart.

## Requirements

- iOS 17.0+
- macOS 14.0+
- visionOS 1.0+

## Installation

You can add DataVisualizations to your Xcode project by adding it as a package dependency.

1. In Xcode, open your project and navigate to **File** > **Add Packages...**
2. In the search bar, enter the repository URL:
   ```
   https://github.com/erickvs/DataVisualizations.git
   ```
3. Choose the version rule you'd like (e.g., "Up to Next Major Version").
4. Click "Add Package" and select the `DataVisualizations` product to be added to your target.

## Usage

Here is how to import and use the `SpiderWebChartView`.

### Basic Example

```swift
import SwiftUI
import DataVisualizations

struct MyView: View {
    let data: [Double] = [0.8, 0.6, 0.9, 0.4, 0.7]
    let categories = ["Strength", "Speed", "Agility", "Stamina", "Flexibility"]

    var body: some View {
        SpiderWebChartView(data: data, categories: categories)
    }
}
```

### Customization

You can customize the number of divisions and the colors of the chart.

```swift
SpiderWebChartView(
    data: data,
    categories: categories,
    divisions: 5,
    gridColor: .green,
    plotFillColor: .purple,
    plotStrokeColor: .orange
)
```

### Full Example with Dynamic Controls

You can hook the chart up to `@State` variables to create interactive demos.

```swift
import SwiftUI
import DataVisualizations

struct SpiderWebChartDemoView: View {
    @State private var numberOfAxes: Int = 5
    @State private var rawData: [Double] = [120, 80, 135, 90, 100]
    @State private var gridColor: Color = .gray
    @State private var plotFillColor: Color = .blue
    @State private var plotStrokeColor: Color = .blue

    private let allCategories = [
        "Strength", "Speed", "Agility", "Stamina", "Flexibility",
        "Power", "Endurance", "Balance", "Coordination", "Accuracy"
    ]
    private let maxScore: Double = 150

    private var currentCategories: [String] {
        Array(allCategories.prefix(numberOfAxes))
    }
    private var normalizedData: [Double] {
        rawData.map { $0 / maxScore }
    }

    var body: some View {
        Form {
            Section(header: Text("Chart")) {
                SpiderWebChartView(
                    data: normalizedData,
                    categories: currentCategories,
                    gridColor: gridColor,
                    plotFillColor: plotFillColor,
                    plotStrokeColor: plotStrokeColor
                )
                .frame(height: 300)
            }

            Section(header: Text("Controls")) {
                Stepper("Number of Axes: \(numberOfAxes)", value: $numberOfAxes, in: 3...10)
                ColorPicker("Grid Color", selection: $gridColor)
                // ... other controls
            }
        }
    }
}
```

## License

This package is released under the MIT License. See `LICENSE` for details.
