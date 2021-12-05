//
//  AppNotification.swift
//  SwiftSaltTiger
//
//  Created by p1vtoMiilo on 5/12/2021.
//

import SwiftUI
import Combine


enum AppNotification: String {
    case shouldShowSlideMenu
    case shouldHideSlideMenu
}

extension AppNotification {
    var name: NSNotification.Name {
        .init(rawValue: rawValue)
    }
    var publisher: NotificationCenter.Publisher {
        name.publisher
    }
    
    static func post(_ notification: AppNotification) {
        NotificationCenter.default.post(name: notification.name, object: nil)
    }
}



