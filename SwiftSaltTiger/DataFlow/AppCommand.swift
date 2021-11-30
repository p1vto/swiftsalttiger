//
//  AppCommand.swift
//  SwiftSaltTiger
//
//  Created by p1vtoMiilo on 30/11/2021.
//

import Foundation

protocol AppCommand {
    func execute(in store: Store)
}
