//
//  CombineRequest.swift
//  SwiftSaltTiger
//
//  Created by iMac on 2021/11/30.
//

import Combine
import Foundation
import Kanna


private func mapError(error: Error) -> AppError {
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
    
//    var publisher: AnyPublisher<[Post], AppError> {
//        let url = URL(string: "\(baseURL)/page/\(page)")!
//        let urlRequest = URLRequest(url: url)
//        let publisher = URLSession.shared.dataTaskPublisher(for: urlRequest)
//            .genericRetry()
//            .tryMap { try Kanna.HTML(html: $0.data, encoding: .utf8) }
//        
//        
//    }
}
