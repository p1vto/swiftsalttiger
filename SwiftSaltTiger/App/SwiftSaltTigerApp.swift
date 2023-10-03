//
//  SwiftSaltTigerApp.swift
//  SwiftSaltTiger
//
//  Created by p1vtoMiilo on 27/11/2021.
//

import SwiftUI
import ComposableArchitecture

@main
struct SwiftSaltTigerApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(store: Store(initialState: AppFeature.State(), reducer: {
                AppFeature()
                    ._printChanges()
            }))
        }
    }
}
