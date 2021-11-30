//
//  CacheAsyncImage.swift
//  SwiftSaltTiger
//
//  Created by p1vtoMiilo on 29/11/2021.
//

import SwiftUI

struct CacheAsyncImage: View {
    private let url: URL

    init(url: URL) {
        self.url = url
    }

    var body: some View {
        if let image = ImageCache[url] {
            image
                .resizable()
        } else {
            AsyncImage(url: url) { image in
                self.cacheAndRender(image: image)
            } placeholder: {
                ProgressView()
            }
        }
    }
    
    private func cacheAndRender(image: Image) -> some View {
        if ImageCache[url] == nil {
            ImageCache[url] = image
        }
        
        return image.resizable()
    }
}

fileprivate struct ImageCache {
    static private var cache = [URL: Image]()

    static subscript(url: URL) -> Image? {
        get {
            ImageCache.cache[url]
        }
        
        set {
            ImageCache.cache[url] = newValue
        }
    }
}
