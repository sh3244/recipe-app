//
//  ViewModel.swift
//  Recipe
//
//  Created by Sam on 1/17/25.
//


//import Foundation
import SwiftUI

protocol ViewModel: ObservableObject {
    func url(_ json: [String: Any], _ key: String) -> URL?
    func camelCaseToSnakeCase(_ string: String) -> String

}

extension ViewModel {
    func url(_ json: [String: Any], _ key: String) -> URL? {
        guard let urlString = json[key] as? String else {
            return nil
        }
        return URL(string: urlString)
    }

    func camelCaseToSnakeCase(_ string: String) -> String {
        var result = ""
        for character in string {
            if character.isUppercase {
                result.append("_")
                result.append(character.lowercased())
            } else {
                result.append(character)
            }
        }
        return result
    }
}
