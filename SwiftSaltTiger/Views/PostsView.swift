//
//  ContentView.swift
//  SwiftSaltTiger
//
//  Created by p1vtoMiilo on 27/11/2021.
//

import SwiftUI

struct PostsView: View {
    @StateObject var vm = PostsViewModel()
    @State private var isPresentDetail = false

    var body: some View {
        NavigationView {
            List {
                ForEach(vm.posts) { post in
                    PostCell(post: post)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color(.lightGray.withAlphaComponent(0.1)))
                        .onTapGesture {
                            vm.presentingPost = post
                            isPresentDetail = true
                        }
                        .task {
                            if vm.isNeedLoadMore(post: post) {
                                await vm.fetchPosts()
                            }
                        }
                }
                
                if vm.isRequesting {
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
                await vm.refresh()
            }
            .popover(isPresented: $isPresentDetail) {
                if let post = vm.presentingPost {
                    PostDetailView(post: post)
                } else {
                    Text("Empty Post :(")
                }
            }
            
        }
       

            
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView()
    }
}
