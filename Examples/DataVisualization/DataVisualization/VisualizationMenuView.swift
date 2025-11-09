import SwiftUI

struct VisualizationMenuView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("Spider Web Chart", destination: SpiderWebChartDemoView())
                
                // Placeholder for the next visualization
                Text("More visualizations coming soon...")
                    .foregroundColor(.gray)
            }
            .navigationTitle("Visualizations")
        }
    }
}

#Preview {
    VisualizationMenuView()
}
