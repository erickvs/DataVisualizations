import SwiftUI

// 1. Define the key itself.
// This struct provides a default value for our custom environment key.
private struct GridColorKey: EnvironmentKey {
    static let defaultValue: Color = .gray
}

// 2. Extend EnvironmentValues to add a computed property for our key.
// This is the boilerplate that allows us to access our value via `\.gridColor`.
extension EnvironmentValues {
    var gridColor: Color {
        get { self[GridColorKey.self] }
        set { self[GridColorKey.self] = newValue }
    }
}
