//
//  Requests.swift
//  SwiftSaltTiger
//
//  Created by p1vtoMiilo on 27/11/2021.
//

import Foundation
import Kanna


struct ClientRequest {
    static func fetchPostList(page: Int) async -> Result<[Post], AppError> {
        guard let url = URL(string: "\(Config.URLConfig.host)/page/\(page)") else {
            return .failure(.unvalidURL)
        }
        let urlRequest = URLRequest(url: url)
        
        guard let result = try? await URLSession.shared.data(for: urlRequest),
              let doc = try? HTML(html: result.0, encoding: .utf8)
        else {
            return .failure(.requestFail)
        }
        
        do {
            let posts = try Parser.parseIntoPostList(doc: doc)
            return .success(posts)
        } catch {
            return .failure(.parseFail)
        }
    }
    
    static func fetchPostDetail(post: Post) async -> Result<(String, [Comment]), AppError> {
        guard let url = URL(string: "\(post.detailUrl)") else {
            return .failure(.unvalidURL)
        }
        let urlRequest = URLRequest(url: url)
        
        guard let result = try? await URLSession.shared.data(for: urlRequest),
              let doc = try? HTML(html: result.0, encoding: .utf8)
        else {
            return .failure(.requestFail)
        }
        
        do {
            let detail = try Parser.parseIntoPostDetail(doc: doc)
            return .success(detail)
        } catch {
            return .failure(.parseFail)
        }
    }

}




