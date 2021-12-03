//
//  AppCommand.swift
//  SwiftSaltTiger
//
//  Created by p1vtoMiilo on 30/11/2021.
//

import Foundation
import Combine
import SwiftUI

protocol AppCommand {
    func execute(in store: Store)
}

final class SubscriptionToken {
    var cancellable: AnyCancellable?
    func unseal() { cancellable = nil }
}

extension AnyCancellable {
    func seal(in token: SubscriptionToken) {
        token.cancellable = self
    }
}

/// refresh Posts
struct RefreshPostsCommand: AppCommand {
    
    func execute(in store: Store) {
        let token = SubscriptionToken()
        PostListRequest(page: 1)
            .publisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    store.dispatch(.refreshPostsDone(result: .failure(error)))
                }
                token.unseal()
            } receiveValue: { posts in
                store.dispatch(.refreshPostsDone(result: .success(posts)))
            }
            .seal(in: token)

    }
}

/// Fetch Posts
struct FetchPostsCommand: AppCommand {
    let page: Int
    
    func execute(in store: Store) {
        let token = SubscriptionToken()
        PostListRequest(page: page)
            .publisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    store.dispatch(.fetchPostsDone(result: .failure(error)))
                }
                token.unseal()
            } receiveValue: { posts in
                store.dispatch(.fetchPostsDone(result: .success(posts)))
            }
            .seal(in: token)

    }
}

/// Fetch Post Detail
struct FetchPostDetailCommand: AppCommand {
    let post: Post
    
    func execute(in store: Store) {
        let token = SubscriptionToken()
        PostDetailRequest(post: post)
            .publisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    store.dispatch(.fetchPostDetailDone(result: .failure(error)))
                }
                token.unseal()
            } receiveValue: { detail in
                store.dispatch(.fetchPostDetailDone(result: .success(detail)))
            }
            .seal(in: token)

    }
}
