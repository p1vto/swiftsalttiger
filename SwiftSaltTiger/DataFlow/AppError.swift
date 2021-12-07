//
//  AppError.swift
//  SwiftSaltTiger
//
//  Created by p1vtoMiilo on 30/11/2021.
//

import Foundation

enum AppError: Error {
    case requestFail
    case parseFail
    case unknown
    
    var description: String {
        switch self {
            case .requestFail:
                return "request error"
            case .parseFail:
                return "parse error"
            case .unknown:
                return "unknown error"
        }
    }
}


