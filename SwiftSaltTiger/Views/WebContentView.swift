//
//  WebContentView.swift
//  SwiftSaltTiger
//
//  Created by iMac on 2021/11/30.
//

import SwiftUI

struct WebContentView: View {
    @StateObject var vm = WebViewModel()
    let url: URL
    
    init(url: URL) {
        self.url = url
    }

    var body: some View {
        WebView(webView: vm.webView)
            .onAppear {
                vm.loadUrl(url: url)
            }
    }

}
