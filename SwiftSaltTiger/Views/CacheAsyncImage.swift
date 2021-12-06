//
//  CacheAsyncImage.swift
//  SwiftSaltTiger
//
//  Created by p1vtoMiilo on 29/11/2021.
//

import SwiftUI
import Kingfisher

struct CacheAsyncImage: View {
    private let url: URL

    init(url: URL) {
        self.url = url
    }

    var body: some View {
        KFImage(url)
            .placeholder { _ in
                ProgressView()
            }
            .retry(maxCount: 3, interval: .seconds(5))
            .resizable()
            
    }
    

}

