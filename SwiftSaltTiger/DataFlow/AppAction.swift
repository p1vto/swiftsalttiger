//
//  AppAction.swift
//  SwiftSaltTiger
//
//  Created by p1vtoMiilo on 30/11/2021.
//

import Foundation

enum AppAction {
    case fetchPosts(page: Int)
    case fetchPostDetail(post: Post)
}
