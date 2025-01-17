//
//  ContentView.swift
//  Recipe
//
//  Created by Sam on 1/16/25.
//

import SwiftUI

struct ContentView: View {
    @State var isLoading: Bool = true
    @ObservedObject var viewModel: RecipesViewModel = RecipesViewModel()

    var body: some View {
        ScrollView {
            switch viewModel.state {
            case .empty:
                Text("No recipes found")
            case .loading:
                ProgressView()
            case .loaded:
                RecipesView(viewModel: viewModel)
            }
        }.onAppear {
            Task {
                isLoading = true
                await viewModel.load()
                withAnimation {
                    isLoading = false
                }
            }
        }.refreshable {
            Task {
                isLoading = true
                await viewModel.load()
                // animate opacity 1
                withAnimation {
                    isLoading = false
                }
            }
        }.opacity(isLoading ? 0 : 1)
    }
}

#Preview {
    VStack {
        ContentView().onAppear()
    }
}

//Swift Concurrency: Use async/await for all asynchronous operations, including API calls and image loading.
//
//No External Dependencies: Your implementation should rely only on Apple's frameworks. Do not include third-party libraries for networking, image caching, or testing.
//
//Efficient Network Usage: Load images only when needed in the UI to avoid unnecessary bandwidth consumption. Cache images to disk to minimize repeated network requests, but implement this yourself without relying on any third-party solutions or URLSession's HTTP caching.
//
//Testing: Include unit tests to demonstrate your approach to testing. Use your judgement to determine what should be tested and the appropriate level of coverage. Focus on testing the core logic of your app (e.g., data fetching and caching). UI and integration tests are not required for this exercise.
//
//SwiftUI: The app's user interface must be built using SwiftUI. We expect engineers to stay up-to-date on the modern UI tooling available from Apple.
