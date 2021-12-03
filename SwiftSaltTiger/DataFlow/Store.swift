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
        case .refreshPosts:
            appState.homeState.loadingPosts = true
            appCommand = RefreshPostsCommand()
            
        case .refreshPostsDone(let result):
            appState.homeState.loadingPosts = false
            switch result {
            case .success(let posts):
                appState.homeState.posts = posts
                appState.homeState.page = 2
            case .failure(let err):
                appState.homeState.postListError = err
            }

        case .fetchPosts:
            appState.homeState.loadingPosts = true
            appCommand = FetchPostsCommand(page: appState.homeState.page)
            
        case .fetchPostDetail(let post):
            appState.homeState.presentingPost = post
            appState.homeState.loadingPostDetail = true
            appCommand = FetchPostDetailCommand(post: post)
            
            
        case .fetchPostsDone(let result):
            appState.homeState.loadingPosts = false
            switch result {
            case .success(let posts):
                appState.homeState.posts += posts
                appState.homeState.page += 1
            case .failure(let err):
                appState.homeState.postListError = err
            }
            
        case .fetchPostDetailDone(let result):
            appState.homeState.loadingPostDetail = false
            switch result {
            case .success(let detail):
                appState.homeState.postDetail = detail
            case .failure(let err):
                appState.homeState.postDetailError = err
            }
        }
        
        return (appState, appCommand)
    }
}
