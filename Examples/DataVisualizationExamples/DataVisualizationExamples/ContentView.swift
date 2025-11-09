//
//  ContentView.swift
//  DataVisualizationExamples
//
//  Created by Erick Vazquez Santillan on 11/9/25.
//

import SwiftUI

struct ContentView: View {
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
    ContentView()
}
