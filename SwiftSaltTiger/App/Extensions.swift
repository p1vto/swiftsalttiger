//
//  Extensions.swift
//  SwiftSaltTiger
//
//  Created by p1vtoMiilo on 5/12/2021.
//

import Foundation


extension NSNotification.Name {
    var publisher: NotificationCenter.Publisher {
        NotificationCenter.default.publisher(for: self)
    }
}
