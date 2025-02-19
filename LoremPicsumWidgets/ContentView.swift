//
//  ContentView.swift
//  LoremPicsumWidgets
//
//  Created by Joseph Wardell on 2/18/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var image: UIImage?
    
    // the largest possible size of a large widget is 379 x 379 (on 12.9 inch iPad)
    // according to
    // https://github.com/simonbs/ios-widget-sizeshttps://github.com/simonbs/ios-widget-sizes,
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
                    .onAppear(perform: loadRandomImage)
            }
        }
        .padding()
    }
    
    private func loadRandomImage() {
        let pictureURL = LoremPicsum.randomPicture(width: Int(pictureSize.width), height: Int(pictureSize.height)).jpg().url
        
        Task.detached {
            do {
                let (data, _) = try await URLSession.shared.data(from: pictureURL)
                await MainActor.run {
                    image = UIImage(data: data)
                }
            }
            catch {
                print("Error loading image from \(pictureURL): \((error as? LocalizedError)?.localizedDescription ?? "unknkown error")")
            }
        }
    }
}

#Preview {
    ContentView()
}
