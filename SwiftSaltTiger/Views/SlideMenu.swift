//
//  SlideMenu.swift
//  SwiftSaltTiger
//
//  Created by iMac on 2021/12/3.
//

import SwiftUI


struct SlideMenu: View, StoreAccessor {
    @EnvironmentObject var store: Store
    
    var body: some View {
        HStack {
            VStack() {
                
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .cornerRadius(25)
                    .padding(.top)
                
                Text(envState.user?.name ?? "")
                    .font(.title)
                    .foregroundColor(.black)
                    
                Text(envState.user?.email ?? "")
                    .tint(.black)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    
                
                Spacer()
                
                SlideMenuRow(title: "Settings", image: "gear") {
                    store.dispatch(.sheetSettings)
                }
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
    private let title: String
    private let image: String
    private var action: (() -> ())?
    
    
    @State private var isPressing = false
    
    private var backgroundColor: Color {
        isPressing ? Color(.systemGray6).opacity(0.6) : .clear
    }
    
    init(title: String, image: String, action: (() -> ())? = nil) {
        self.title = title
        self.image = image
        self.action = action
    }

    
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
        .padding(.vertical, 5)
        .contentShape(Rectangle())
        .background(backgroundColor)
        .cornerRadius(10)
        .onTapGesture(perform: action ?? {})
        .onLongPressGesture(
            minimumDuration: .infinity,
            maximumDistance: 50,
            pressing: { isPressing = $0 },
            perform: {}
        )
        
    }
    
}
