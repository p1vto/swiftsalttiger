//
//  AppState.swift
//  SwiftSaltTiger
//
//  Created by p1vtoMiilo on 30/11/2021.
//

import Foundation

struct AppState {
    var homeInfo = HomeInfo()
}


extension AppState {
    struct HomeInfo {
        var posts = [Post]()
        var loadingPosts = false
        var page = 1
        var postListError: AppError?
        
        var presentingPost: Post?
        var postDetail = ""
        var postDetailError: AppError?
    }
}
