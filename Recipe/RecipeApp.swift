//
//  RecipeApp.swift
//  Recipe
//
//  Created by Sam on 1/16/25.


import SwiftUI

let appCache = DiskCache(directory: cacheDirectoryURL, capacity: 100 * 1024 * 1024)

@main
struct RecipeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().task {
                FileManager.createCacheDirectories()
            }
        }
    }
}

