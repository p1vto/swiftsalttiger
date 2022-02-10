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
                .onAppear {
                    configureUser()
                }
                
        }
    }
}



extension SwiftSaltTigerApp {
    private func configureUser() {
        PersistenceController.createIfNotExist(entityType: UserMO.self) { mo in
            mo?.name = "User"
            mo?.email = "email"
        }
        
        store.dispatch(.fetchUser)
    }
}
