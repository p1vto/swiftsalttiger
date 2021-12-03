//
//  SlideMenu.swift
//  SwiftSaltTiger
//
//  Created by iMac on 2021/12/3.
//

import SwiftUI


struct SlideMenu: View {
    @EnvironmentObject var store: Store

    var body: some View {
        VStack {
            
            Spacer()
            
        }
    }
}



struct SlideMenuRow: View {
    

    var body: some View {
        HStack {
            Image(systemName: "gear")
                
            Text("Settings")
                .fontWeight(.medium)
                .font(.headline)
            
            Spacer()
        }
    }

}
