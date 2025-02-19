//
//  ContentView.swift
//  LoremPicsumWidgets
//
//  Created by Joseph Wardell on 2/18/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var image: UIImage?
    @State private var imageIDs: [Int] = []
    
    @AppStorage("imageURL") var imageURL: String?
    
    // the largest possible size of a large widget is 379 x 379 (on 12.9 inch iPad)
    // according to https://github.com/simonbs/ios-widget-sizes
    // TODO: if on iPhone, only fetch the largest possible value for an iPhone's large widget size to save network traffic
    // TODO: if on iPad, fetch the largest possible value for an iPad's extra large widget size
    // TODO: (harder) fetch the largest possible widget size for the current model device using
    // but for now, we're just going to fetch the largest size for a large widget
    // and leave it at that
    let pictureSize = CGSize(width: 379, height: 379)
    
    var body: some View {
        VStack {
            if let image {
                VStack {

                    Text(imageURL ?? "")
                        .font(.subheadline)

                    Image(uiImage: image)
                        .frame(maxWidth: pictureSize.width, maxHeight: pictureSize.height)
                        .onTapGesture(perform: loadRandomImage)
                    
                    Text("Tap the image to load another one")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            else {
                ProgressView()
                    .task {
                        if let imageURL,
                           let urlFromPreviousLoad = URL(string: imageURL) {
                            await load(imageURL: urlFromPreviousLoad)
                        }
                        else {
                            loadRandomImage()
                        }
                    }
            }
        }
        .padding()
    }
    
    private func loadRandomImage() {
        
        // as a shortcut, just grab imageIDs here
        Task.detached {
            
            // load a list of possible image ids from the server
            if await self.imageIDs.isEmpty {
                // choose one set of 100 images from the first 500 provided by the server
                let page = Int.random(in: 1 ... 5)
                let imageIDsURL = LoremPicsum.list(page: page, picturesPerPage: 100)
                do {
                    let (data, _) = try await URLSession.shared.data(from: imageIDsURL)
                    struct ResponseObject: Decodable { let id: String }
                    let ids = try JSONDecoder().decode([ResponseObject].self, from: data)
                    await MainActor.run {
                        self.imageIDs = ids.map(\.id).compactMap(Int.init)
                    }
                }
                catch {
                    print("Error retrieving list of image ids from \(imageIDsURL): \(error.localizedDescription)")
                    return
                }
            }
            
            
            // choose a random image id and request it from the server
            guard let imageID = await self.imageIDs.randomElement() else { return }
            let pictureURL = LoremPicsum.picture(
                id: imageID,
                width: Int(pictureSize.width),
                height: Int(pictureSize.height)
            ).url
            
            await MainActor.run {
                self.imageURL = pictureURL.absoluteString
            }
  
            await load(imageURL: pictureURL)
        }
    }
    
    private func load(imageURL: URL) async {
        do {
            let (data, _) = try await URLSession.shared.data(from: imageURL)
            await MainActor.run {
                image = UIImage(data: data)
            }
        }
        catch {
            print("Error loading image from \(imageURL): \((error as? LocalizedError)?.localizedDescription ?? "unknkown error")")
        }
    }
}

#Preview {
    ContentView()
}
