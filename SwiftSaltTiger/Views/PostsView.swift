//
//  ContentView.swift
//  SwiftSaltTiger
//
//  Created by p1vtoMiilo on 27/11/2021.
//

import SwiftUI

struct PostsView: View, StoreAccessor {
    @EnvironmentObject var store: Store
    @State private var isPresentDetail = false

    var body: some View {
        NavigationView {
            List {
                ForEach(homeState.posts) { post in
                    PostCell(post: post)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color(.lightGray.withAlphaComponent(0.1)))
                        .onTapGesture {
                            store.dispatch(.fetchPostDetail(post: post))
                            isPresentDetail = true
                        }
                        .task {
                            if isNeedLoadMore(post: post) {
                                store.dispatch(.fetchPosts)
                            }
                        }
                }
                
                if homeState.loadingPosts {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    .listRowSeparator(.hidden)
                }
                
            }
            .navigationTitle("Posts")
            .listStyle(.plain)
            .refreshable {
                store.dispatch(.refreshPosts)
            }
            .popover(isPresented: $isPresentDetail) {
                if let post = homeState.presentingPost {
                    PostDetailView(post: post)
                } else {
                    Text("Empty Post :(")
                }
            }
            .onAppear {
                store.dispatch(.refreshPosts)
            }
        }
        
    }
    
    private func isNeedLoadMore(post: Post) -> Bool {
        post.id == homeState.posts.last?.id && !homeState.loadingPosts
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView()
    }
}
