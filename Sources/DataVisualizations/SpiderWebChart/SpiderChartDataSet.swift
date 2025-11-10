import SwiftUI

public struct SpiderChartDataSet {
    public let dataPoints: [SpiderChartDataPoint]
    public let fillColor: Color
    public let strokeColor: Color

    public init(dataPoints: [SpiderChartDataPoint], fillColor: Color, strokeColor: Color) {
        self.dataPoints = dataPoints
        self.fillColor = fillColor
        self.strokeColor = strokeColor
    }
}
