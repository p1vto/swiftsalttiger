//
//  Store.swift
//  SwiftSaltTiger
//
//  Created by p1vtoMiilo on 30/11/2021.
//

import Foundation

final class Store: ObservableObject {
    @Published var appState = AppState()
    
    func dispatch(_ action: AppAction) {
        if Thread.isMainThread {
            _dispatch(action)
        } else {
            DispatchQueue.main.async { [weak self] in
                self?._dispatch(action)
            }
        }
    }
    
    private func _dispatch(_ action: AppAction) {
        
    }
    
    func reduce(state: AppState, action: AppAction) -> (AppState, AppCommand?) {
        var appState = state
        var appCommand: AppCommand?
        
        // reduce action
        switch action {
            case .fetchPosts(let page):
                break
            case .fetchPostDetail(let post):
                break
        }
        
        return (appState, appCommand)
    }
}
