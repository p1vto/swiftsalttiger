//
//  AppAction.swift
//  SwiftSaltTiger
//
//  Created by p1vtoMiilo on 30/11/2021.
//

import Foundation

enum AppAction {
    case setSlideMenuClosed(closed: Bool)
    case sheetSettings

    case refreshPosts
    case refreshPostsDone(result: Result<[Post], AppError>)
    
    case fetchUser

    case fetchPosts
    case fetchPostsDone(result: Result<[Post], AppError>)
    case fetchPostsErrorPresented
    
    case fetchPostDetail(post: Post)
    case fetchPostDetailDone(result: Result<(String, [Comment]), AppError>)
    case fetchPostDetailErrorPresented
}
