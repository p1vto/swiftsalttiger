//
//  PostDetailView.swift
//  SwiftSaltTiger
//
//  Created by p1vtoMiilo on 29/11/2021.
//

import SwiftUI

struct PostDetailView: View {
    let post: Post
    @StateObject var vm = PostDetailViewModel()
    @State private var isPresentingWebView = false

    init(post: Post) {
        self.post = post
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(post.title)
                    .foregroundColor(.black)
                    .font(.system(size: 22).bold())
                    .padding()
                
                HStack {
                    CacheAsyncImage(url: URL(string: post.cover)!)
                        .frame(width: 150, height: 180)
                        .cornerRadius(10)

                    VStack(alignment: .leading) {
                        Text("出版时间: \(post.pubDate)")
                            .foregroundColor(.black)
                            .font(.system(size: 16))
                        
                        Text("出版社: \(post.publisher)")
                            .foregroundColor(.black)
                            .font(.system(size: 16))
                        
                        Text("提取码: \(post.downloadCode)")
                            .foregroundColor(.black)
                            .font(.system(size: 16))
                        
                        Spacer()
                    }
                    .padding()
                }
                
                
                if vm.isRequesting {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    .padding()
                } else {
                    Text(vm.detail)
                        .foregroundColor(.black)
                        .font(.system(size: 14))
                    
                    HStack {
                        Spacer()
                        Button {
                            isPresentingWebView.toggle()
                        } label: {
                            RoundedRectangle(cornerRadius: 10)
                                .background(Color.blue)
                                .frame(width: 100, height: 50)
                                .cornerRadius(10)
                                .overlay {
                                    Text("Downlaod")
                                        .foregroundColor(.white)
                                }
                        }

                        Spacer()
                    }
                    .padding()
                }
                
                
            }
            .padding()
        }
        .task {
            vm.post = self.post
            await vm.fetchDetail()
        }
        .popover(isPresented: $isPresentingWebView) {
            WebContentView(url: URL(string: post.downloadLink)!)
        }
        
    }
    
    
}
