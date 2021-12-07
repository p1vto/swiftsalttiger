//
//  PostDetailView.swift
//  SwiftSaltTiger
//
//  Created by p1vtoMiilo on 29/11/2021.
//

import SwiftUI

struct PostDetailView: View, StoreAccessor {
    let post: Post
    @EnvironmentObject var store: Store
    @State private var isPresentingWebView = false
    @State private var isPresentError = false
    
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
                        Text("Date: \(post.pubDate)")
                            .foregroundColor(.black)
                            .font(.system(size: 16))
                        
                        Text("Publisher: \(post.publisher)")
                            .foregroundColor(.black)
                            .font(.system(size: 16))
                        
                        Text("Code: \(post.downloadCode)")
                            .foregroundColor(.black)
                            .font(.system(size: 16))
                        
                        Spacer()
                    }
                    .padding()
                }
                
                
                if homeState.loadingPostDetail {
                    VStack {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        .padding()
                    }
                    
                } else {
                    Text(homeState.presentingPost?.detail ?? "")
                        .tint(.black)
                        .font(.system(size: 14))
                        .lineSpacing(5)
                    
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
                    
                    if let comments = homeState.presentingPost?.comments,
                       comments.count > 0 {
                        Divider()
                        Text("Comments(\(comments.count))")
                            .tint(.black)
                            .font(.system(size: 18, weight: .bold))
                            .padding(.vertical)
                        
                        
                        ForEach(comments) { comment in
                            CommentCell(comment: comment)
                        }
                        
                    }
                    
                }
                
                
            }
            .padding()
        }
        .task {
            store.dispatch(.fetchPostDetail(post: post))
        }
        .onChange(of: homeState.postDetailError) { newValue in
            isPresentError = !(newValue == nil)
        }
        .popover(isPresented: $isPresentingWebView) {
            WebContentView(url: URL(string: post.downloadLink)!)
        }
        .spAlert(isPresent: $isPresentError,
                 title: "Oops",
                 message: homeState.postDetailError?.description,
                 duration: 1,
                 dismissOnTap: true,
                 preset: .custom(UIImage(systemName: "exclamationmark.icloud")!),
                 haptic: .error) {
            store.dispatch(.fetchPostDetailErrorPresented)
        }
                 
        
    }
    
    
}
