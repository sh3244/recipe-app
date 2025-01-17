//
//  RecipeTests.swift
//  RecipeTests
//
//  Created by Sam on 1/16/25.
//

import XCTest
@testable import Recipe

final class RecipeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testAPIManager() async throws {
        guard let url = URL(string: recipeJSONURL) else { return }
        var recipes: [RecipeViewModel] = []

        let expectation = XCTestExpectation(description: "Download recipe JSON")
        do {
            let json = try await APIManager.request(url: recipeJSONURL, requestType: "GET")

            if let recipeJSONs = json["recipes"] as? [[String: Any]] {
                recipes = recipeJSONs.compactMap { RecipeViewModel(json: $0) }
                // expectation pass
                expectation.fulfill()
                print(recipes)
            } else {
                XCTFail("Failed to parse recipe JSON")
            }
        } catch {
            XCTFail("Failed to download or parse recipe JSON: \(error)")
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
