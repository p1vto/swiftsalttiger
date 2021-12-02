//
//  AppAction.swift
//  SwiftSaltTiger
//
//  Created by p1vtoMiilo on 30/11/2021.
//

import Foundation

enum AppAction {
    case fetchPosts
    case fetchPostDetail
    case fetchPostsDone(result: Result<[Post], AppError>)
    case fetchPostDetailDone(result: Result<String, AppError>)
}
