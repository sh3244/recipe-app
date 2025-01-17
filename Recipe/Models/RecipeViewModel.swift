//
//  Recipe.swift
//  Recipe
//
//  Created by Sam on 1/17/25.
//

//import Foundation
import SwiftUI

//JSON Structure
//Key    Type    Required    Notes
//cuisine    string    yes    The cuisine of the recipe.
//name    string    yes    The name of the recipe.
//photo_url_large    string    no    The URL of the recipes’s full-size photo.
//photo_url_small    string    no    The URL of the recipes’s small photo. Useful for list view.
//uuid    string    yes    The unique identifier for the receipe. Represented as a UUID.
//source_url    string    no    The URL of the recipe's original website.
//youtube_url    string    no    The URL of the recipe's YouTube video.

class RecipeViewModel: ViewModel {
    var cuisine: String = ""
    var name: String = ""
    var photoURLLarge: URL? = nil
    var photoURLSmall: URL? = nil
    var uuid: UUID? = nil
    var sourceURL: URL? = nil
    var youtubeURL: URL? = nil

    convenience init(json: [String: Any]) {
        self.init()
        self.cuisine = json["cuisine"] as? String ?? ""
        self.name = json["name"] as? String ?? ""
        self.uuid = UUID(uuidString: json["uuid"] as? String ?? "") ?? UUID()

        self.photoURLLarge = url(json, "photo_url_large")
        self.photoURLSmall = url(json, "photo_url_small")
        self.sourceURL = url(json, "source_url")
        self.youtubeURL = url(json, "youtube_url")
    }
}
