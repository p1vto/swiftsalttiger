//
//  Comment.swift
//  SwiftSaltTiger
//
//  Created by p1vtoMiilo on 5/12/2021.
//

import Foundation

struct Comment: Codable, Identifiable {
    let id: String
    let author: String
    let date: String
    let content: String
}
