import SwiftUI

struct RecipeView: View {
    @ObservedObject var viewModel: RecipeViewModel

    @State private var localImageURL: URL?

    // body of recipe view should be like itunes card
    var body: some View {
        ZStack {
            if let localURL = localImageURL, let imageData = try? Data(contentsOf: localURL), let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                ProgressView()
                    .onAppear {
                        Task {
                            guard let url = viewModel.photoURLLarge else { return }
                            localImageURL = await ImageCacheManager.shared.cachedImageURL(for: url)
                        }
                    }
            }
            VStack() {
                Text(viewModel.name)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(0)
                    .frame(maxWidth: .infinity, maxHeight: nil, alignment: .bottom)
                    .background(Color.black.opacity(0.5))
                Spacer()
                Text(viewModel.cuisine)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(0)
                    .frame(maxWidth: .infinity, maxHeight: nil, alignment: .bottom)
                    .background(Color.black.opacity(0.5))
            }.padding(0).cornerRadius(10).shadow(radius: 5).font(.headline).foregroundColor(.white)
        }
    }
}