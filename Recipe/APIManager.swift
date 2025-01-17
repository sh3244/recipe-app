//
//  APIManager.swift
//  Recipe
//
//  Created by Sam on 1/17/25.
//

import Foundation
import SwiftUI

let exerciseURL = "https://d3jbb8n5wk0qxi.cloudfront.net/take-home-project.html"
let recipeJSONURL = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
let recipeJSONURLBad = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
let recipeJSONURLEmpty = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"

class APIManager {
    class func request(url: String, requestType: String) async throws -> [String: Any] {
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONSerialization.jsonObject(with: data) as? [String: Any] ?? [:]
    }
}
