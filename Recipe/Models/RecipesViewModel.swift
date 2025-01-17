//
//  RecipesViewModel.swift
//  Recipe
//
//  Created by Sam on 1/17/25.
//

import Foundation

class RecipesViewModel: ViewModel {
    var recipes: [RecipeViewModel] = []

    convenience init(json: [String: Any]) {
        self.init()
        if let recipes = json["recipes"] as? [[String: Any]] {
            self.recipes = recipes.map { RecipeViewModel(json: $0) }
        }
    }

    enum State {
        case empty
        case loading
        case loaded
    }


    @Published private(set) var state = State.empty

    func load() async {
        DispatchQueue.main.async { self.state = .loading}

        do {
            let json = try await APIManager.request(url: recipeJSONURL, requestType: "GET")
            DispatchQueue.main.async {
                if let recipeJSONs = json["recipes"] as? [[String: Any]] {
                    self.recipes = recipeJSONs.compactMap { RecipeViewModel(json: $0) }
                    self.state = .loaded
                } else {
                    self.state = .empty
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.state = .empty
            }
        }
    }
}
