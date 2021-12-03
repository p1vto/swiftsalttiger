//
//  SwiftSaltTigerApp.swift
//  SwiftSaltTiger
//
//  Created by p1vtoMiilo on 27/11/2021.
//

import SwiftUI

@main
struct SwiftSaltTigerApp: App {
    @StateObject private var store = Store()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(store)
                
        }
    }
}
