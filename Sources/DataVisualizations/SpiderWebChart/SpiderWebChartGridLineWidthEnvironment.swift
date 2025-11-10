import SwiftUI

private struct GridLineWidthKey: EnvironmentKey {
    static let defaultValue: CGFloat = 1.0
}

extension EnvironmentValues {
    var gridLineWidth: CGFloat {
        get { self[GridLineWidthKey.self] }
        set { self[GridLineWidthKey.self] = newValue }
    }
}
