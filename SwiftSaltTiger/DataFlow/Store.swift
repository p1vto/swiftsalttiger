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
        let (state, command) = reduce(state: appState, action: action)
        appState = state

        guard let command = command else { return }
        command.execute(in: self)
    }
    
    func reduce(state: AppState, action: AppAction) -> (AppState, AppCommand?) {
        var appState = state
        var appCommand: AppCommand?
        
        // reduce action
        switch action {
            case .fetchPosts:
                appCommand = FetchPostsCommand(page: appState.homeInfo.page)
                
            case .fetchPostDetail:
                if let post = appState.homeInfo.presentingPost {
                    appCommand = FetchPostDetailCommand(post: post)
                }

            case .fetchPostsDone(let result):
                switch result {
                    case .success(let posts):
                        appState.homeInfo.posts += posts
                    case .failure(let err):
                        appState.homeInfo.postListError = err
                }
                
            case .fetchPostDetailDone(let result):
                switch result {
                    case .success(let detail):
                        appState.homeInfo.postDetail = detail
                    case .failure(let err):
                        appState.homeInfo.postDetailError = err
                }
        }
        
        return (appState, appCommand)
    }
}
