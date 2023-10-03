//
//  AppError.swift
//  SwiftSaltTiger
//
//  Created by p1vtoMiilo on 30/11/2021.
//

import Foundation

enum AppError: String, Error {
    case requestFail
    case parseFail
    case unknown
    case unvalidURL

    var description: String {
        "\(self.rawValue) error"
    }
}


