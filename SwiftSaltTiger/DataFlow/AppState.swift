//
//  AppState.swift
//  SwiftSaltTiger
//
//  Created by p1vtoMiilo on 30/11/2021.
//

import Foundation

struct AppState {
    var homeState = HomeState()
}


extension AppState {
    struct HomeState {
        var posts = [Post]()
        var loadingPosts = false
        var page = 1
        var postListError: AppError?
        
        var presentingPost: Post?
        var loadingPostDetail = false
        var postDetail = ""
        var postDetailError: AppError?
    }
}


extension AppState {
    struct EnvironmentState {
        let baseURL = "https://www.salttiger.com"
    }
}
