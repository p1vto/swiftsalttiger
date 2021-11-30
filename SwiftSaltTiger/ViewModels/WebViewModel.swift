//
//  WebViewModel.swift
//  SwiftSaltTiger
//
//  Created by iMac on 2021/11/30.
//

import SwiftUI
import WebKit

class WebViewModel: ObservableObject {
    let webView: WKWebView
    
    init() {
        webView = WKWebView(frame: .zero)
    }

    func loadUrl(url: URL) {
        webView.load(URLRequest(url: url))
    }
}
