//
//  ContentView.swift
//  LoremPicsumWidgets
//
//  Created by Joseph Wardell on 2/18/25.
//

import SwiftUI
import WidgetKit
import CacheCow

struct ContentView: View {
    
    @State private var image: UIImage?
    
    @AppStorage("imageURL", store: UserDefaults.usingAppGroup) var imageURL: String?
    
    @Environment(SharedData.self) var sharedData
    
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

                    Text("Images from [picsum.photos](http://picsum.photos)")
                        .font(.largeTitle)
                        .padding(.top)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    Text(imageURL ?? "")
                        .font(.subheadline)

                    Image(uiImage: image)
                        .frame(maxWidth: pictureSize.width, maxHeight: pictureSize.height)
                        .onTapGesture(perform: loadRandomImage)
                    
                    Text("Tap the image to load another one")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                }
            }
            else {
                VStack {
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
                        .controlSize(.extraLarge)
                    
                    Text("picsum.photos will throttle if you hit it many times in succession")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.top)
                }
            }
        }
        .padding()
    }
    
    private func loadRandomImage() {
        
        // as a shortcut, just grab imageIDs here
        Task.detached {
            
            // choose a random image id and request it from the server
            let imageID = Int.random(in: 1 ... 999)
            let pictureURL = LoremPicsum.picture(
                id: imageID,
                width: Int(pictureSize.width),
                height: Int(pictureSize.height)
            ).url
            
            guard await load(imageURL: pictureURL) else { return }

            await MainActor.run {
                self.imageURL = pictureURL.absoluteString
            }

            WidgetCenter.shared.getCurrentConfigurations { result in
                guard case .success(let widgets) = result else { return }

                for widget in widgets {
                    WidgetCenter.shared.reloadTimelines(ofKind: widget.kind)
                }
            }
        }
    }
    
    @discardableResult
    private func load(imageURL: URL) async -> Bool {
        do {
            let (data, _) = try await URLSession.shared.data(from: imageURL)
            await MainActor.run {
                image = UIImage(data: data)
                sharedData.cache.insert(data, for: imageURL)
            }
            return true
        }
        catch {
            print("Error loading image from \(imageURL): \((error as? LocalizedError)?.localizedDescription ?? "unknkown error")")
            return false
        }
    }
}

//#Preview {
//    ContentView()
//}
