//
//  AppAction.swift
//  SwiftSaltTiger
//
//  Created by p1vtoMiilo on 30/11/2021.
//

import Foundation

enum AppAction {
    case refreshPosts
    case refreshPostsDone(result: Result<[Post], AppError>)
    case fetchPosts
    case fetchPostDetail(post: Post)
    case fetchPostsDone(result: Result<[Post], AppError>)
    case fetchPostDetailDone(result: Result<String, AppError>)
}
