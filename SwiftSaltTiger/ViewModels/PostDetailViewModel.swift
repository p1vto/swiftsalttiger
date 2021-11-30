//
//  PostDetailViewModel.swift
//  SwiftSaltTiger
//
//  Created by p1vtoMiilo on 29/11/2021.
//


import SwiftUI


class PostDetailViewModel: ObservableObject {
    var post: Post?
    @Published var detail = ""
    @Published var isRequesting = false
    
    func fetchDetail() async {
        guard let post = post else { return }
        if isRequesting { return }
        isRequesting = true
        let result = await fetchPostDetail(post: post)
        switch result {
            case .success(let detail):
                self.detail = detail
            case .failure:
                break
        }
        isRequesting = false
    }
    
    
}
