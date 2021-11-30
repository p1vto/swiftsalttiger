//
//  RequestCommon.swift
//  SwiftSaltTiger
//
//  Created by iMac on 2021/11/30.
//

import Foundation

let baseURL = "https://www.salttiger.com"

enum AppError: Error {
    case requestFail
    case parseFail
    case unknown
}
