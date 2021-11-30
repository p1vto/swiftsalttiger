//
//  WebView.swift
//  SwiftSaltTiger
//
//  Created by iMac on 2021/11/30.
//

import SwiftUI
import WebKit
import UIKit

struct WebView: UIViewRepresentable {
    typealias UIViewType = WKWebView
    
    let webView: WKWebView

    func makeUIView(context: Context) -> WKWebView {
        return webView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }

}

