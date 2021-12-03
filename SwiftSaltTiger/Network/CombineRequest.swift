//
//  CombineRequest.swift
//  SwiftSaltTiger
//
//  Created by iMac on 2021/11/30.
//

import Combine
import Foundation
import Kanna


private func mapAppError(error: Error) -> AppError {
    switch error {
    case is URLError:
        return .requestFail
    case is ParseError:
        return .parseFail
    default:
        return .unknown
    }
}

private extension Publisher {
    func genericRetry() -> Publishers.Retry<Self> {
        retry(3)
    }
}

struct PostListRequest {
    let page: Int
    
    var publisher: AnyPublisher<[Post], AppError> {
        let url = URL(string: "\(Defaults.URLConfig.host)/page/\(page)")!
        let urlRequest = URLRequest(url: url)
        let publisher = URLSession.shared.dataTaskPublisher(for: urlRequest)
            .genericRetry()
            .tryMap { try Kanna.HTML(html: $0.data, encoding: .utf8) }
            .tryMap(Parser.parseIntoPostList)
            .mapError(mapAppError)
            .eraseToAnyPublisher()
        
        return publisher
    }
}

struct PostDetailRequest {
    let post: Post
    
    var publisher: AnyPublisher<String, AppError> {
        let url = URL(string: post.detailUrl)!
        let urlRequest = URLRequest(url: url)
        let publisher = URLSession.shared.dataTaskPublisher(for: urlRequest)
            .genericRetry()
            .tryMap { try Kanna.HTML(html: $0.data, encoding: .utf8) }
            .tryMap(Parser.parseIntoPostDetail)
            .mapError(mapAppError)
            .eraseToAnyPublisher()
        
        return publisher
    }
}
