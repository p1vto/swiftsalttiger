//
//  PostsViewModel.swift.swift
//  SwiftSaltTiger
//
//  Created by iMac on 2021/11/29.
//

import SwiftUI


class PostsViewModel: ObservableObject {
    @Published var posts = [Post]()
    @Published var isRequesting = false
    var page = 1
    var presentingPost: Post?

    init() {
        Task {
            await fetchPosts()
        }
    }
    
    func fetchPosts() async {
        if isRequesting && page != 1 { return }
        isRequesting = true
        let result = await fetchPostList(page: page)
        switch result {
            case .success(let posts):
                if page == 1 {
                    self.posts = posts
                } else {
                    self.posts = self.posts + posts
                }
                page += 1
            case .failure:
                break
        }
        isRequesting = false
    }
    
    func refresh() async {
        page = 1
        await fetchPosts()
    }
    
    func isNeedLoadMore(post: Post) -> Bool {
        post.id == posts.last?.id && !isRequesting
    }
    
}
