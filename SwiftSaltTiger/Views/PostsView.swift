//
//  ContentView.swift
//  SwiftSaltTiger
//
//  Created by p1vtoMiilo on 27/11/2021.
//

import SwiftUI
import SPAlert

struct PostsView: View, StoreAccessor {
    @EnvironmentObject var store: Store
    @State private var isPresentDetail = false
    @State private var isPresentError = false

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
            .navigationBarItems(leading: Button(action: {
                homeState.sliderClose ? AppNotification.post(.shouldShowSlideMenu) : AppNotification.post(.shouldHideSlideMenu)
            }, label: {
                Image(systemName: "list.dash")
                    .resizable()
                    .frame(width: 18, height: 14)
                    .tint(.black)
                    
            }))
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
            .spAlert(isPresent: $isPresentError,
                     title: "Oops",
                     message: homeState.postListError?.description,
                     duration: 1,
                     dismissOnTap: true,
                     preset: .custom(UIImage(systemName: "exclamationmark.icloud")!),
                     haptic: .error) {
                store.dispatch(.fetchPostsErrorPresented)
            }
        }
        .navigationViewStyle(.stack)
        
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
