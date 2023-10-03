//
//  Post.swift
//  SwiftSaltTiger
//
//  Created by p1vtoMiilo on 28/11/2021.
//

import Foundation

struct Post: Codable, Identifiable {
    let id: String
    let cover: String
    let title: String
    let pubDate: String
    let publisher: String
    let downloadLink: String
    let downloadCode: String
    let detailUrl: String
    
    var detail: String?
    var comments: [Comment]?
}

extension Post: Equatable {
    static func == (lhs: Post, rhs: Post) -> Bool {
        lhs.id == rhs.id
    }
}
