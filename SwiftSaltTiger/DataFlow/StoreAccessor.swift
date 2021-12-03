//
//  StoreAccessor.swift
//  SwiftSaltTiger
//
//  Created by iMac on 2021/12/3.
//

import Foundation

protocol StoreAccessor {
    var store: Store { get }
}

extension StoreAccessor {
    var appState: AppState {
        store.appState
    }
    
    var homeState: AppState.HomeState {
        appState.homeState
    }
}
