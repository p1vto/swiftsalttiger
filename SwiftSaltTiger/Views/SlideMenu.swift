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
        HStack {
            VStack() {
                
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .cornerRadius(25)
                    .padding(.top)
                
                Text("User")
                    .font(.title)
                    .foregroundColor(.black)
                    
                Text("p1vto1110@gmail.com")
                    .tint(.black)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    
                
                Spacer()
                
                SlideMenuRow(title: "Settings", image: "gear")
                    .padding()
                
                
            }
            .background(Color.white)
            .frame(width: Defaults.FrameSize.slideMenuWidth)
            .cornerRadius(10)
            .shadow(color: Color(.black.withAlphaComponent(0.1)), radius: 3, x: 3, y: 3)
            .shadow(color: Color(.black.withAlphaComponent(0.1)), radius: 3, x: 0, y: -3)
            
            Spacer()
        }
        
        
    }
}



struct SlideMenuRow: View {
    let title: String
    let image: String
    
    var body: some View {
        HStack {
            Image(systemName: image)
                .resizable()
                .frame(width: 30, height: 30)
                .padding(.horizontal)
            
            Text(title)
                .fontWeight(.medium)
                .font(.headline)
            
            Spacer()
        }
    }
    
}
