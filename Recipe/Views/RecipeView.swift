import SwiftUI

struct RecipesView: View {
    @ObservedObject var viewModel: RecipesViewModel

    let gridSize: CGFloat = UIScreen.main.bounds.width/2 - 16

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: gridSize, maximum: gridSize), spacing: 10)], spacing: 10) {
            ForEach(viewModel.recipes, id: \.uuid) { recipe in
                RecipeView(viewModel: recipe).padding(0).cornerRadius(10).shadow(radius: 5)
            }
        }.padding(0).lineSpacing(0)
    }
}