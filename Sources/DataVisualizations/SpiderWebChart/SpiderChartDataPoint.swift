import Foundation

/// A struct representing a single data point for the SpiderWebChartView.
public struct SpiderChartDataPoint {
    /// The name of the category for this data point.
    public let category: String
    
    /// The value of the data point. This should be normalized between 0.0 and 1.0 before being passed to the chart.
    public let value: Double
    
    public init(category: String, value: Double) {
        self.category = category
        self.value = value
    }
}
