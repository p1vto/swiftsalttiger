//
//  PostCell.swift
//  SwiftSaltTiger
//
//  Created by p1vtoMiilo on 28/11/2021.
//

import SwiftUI

struct PostCell: View {
    let post: Post
    @State var isScale = false


    var body: some View {
        
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(post.title)
                    .foregroundColor(.black)
                    .font(.title2)
                Spacer()
                
                Text("出版时间: \(post.pubDate)")
                    .foregroundColor(.black)
                    .font(.system(size: 14))
                
                Text("出版社: \(post.publisher)")
                    .foregroundColor(.black)
                    .font(.system(size: 14))
                
                Text("提取码: \(post.downloadCode)")
                    .foregroundColor(.black)
                    .font(.system(size: 14))
            }
            
            Spacer()
            
            

            CacheAsyncImage(url: URL(string: post.cover)!)
                .frame(width: 100, height: 130)
                .cornerRadius(10)
            
        }
        .padding(.leading, 15)
        .padding(.trailing, 15)
        .padding(.vertical)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color(.black.withAlphaComponent(0.1)), radius: 3, x: 3, y: 3)
        .scaleEffect(isScale ? 1 : 0.8)
        .onAppear {
            withAnimation {
                self.isScale = true
            }
        }
        .onDisappear {
            withAnimation {
                self.isScale = false
            }
        }
        

    }
    
}
