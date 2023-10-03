//
//  ContentView.swift
//  SwiftSaltTiger
//
//  Created by p1vtoMiilo on 27/11/2021.
//

import SwiftUI
import ComposableArchitecture

// MARK: Reducer
struct PostList: Reducer {
    struct State: Equatable {
        var slideClose = true
        var posts = [Post]()
        var loadingPosts = false
        var page = 1
        var postListError: AppError?
        
    }
    
    enum Action {
        case refreshPosts
        case refreshPostsDone(result: Result<[Post], AppError>)
        
        case fetchPosts
        case fetchPostsDone(result: Result<[Post], AppError>)
        case fetchPostsErrorPresented
        
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .refreshPosts:
                state.loadingPosts = true
                return .run { send in
                    let result = await ClientRequest.fetchPostList(page: 1)
                    await send(.refreshPostsDone(result: result))
                }
            case .refreshPostsDone(let result):
                state.loadingPosts = false
                switch result {
                case .success(let posts):
                    state.posts = posts
                    state.page = 2
                case .failure(let err):
                    state.postListError = err
                }
                return .none
            case .fetchPosts:
                state.loadingPosts = true
                return .run { [page = state.page] send in
                    let result = await ClientRequest.fetchPostList(page: page)
                    await send(.fetchPostsDone(result: result))
                }
            case .fetchPostsDone(let result):
                state.loadingPosts = false
                switch result {
                case .success(let posts):
                    state.posts += posts
                    state.page += 1
                case .failure(let err):
                    state.postListError = err
                }
                return .none
            case .fetchPostsErrorPresented:
                state.postListError = nil
                return .none
            }
        }
        
    }
    
    
}

// MARK: View
struct PostsView: View {
    let store: StoreOf<PostList>
    @State private var isPresentDetail = false
    @State private var isPresentError = false
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { store in
            List {
                ForEach(store.posts) { post in
                    PostCell(post: post)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color(.lightGray.withAlphaComponent(0.1)))
                        .task {
                            if isNeedLoadMore(post: post) {
                                store.send(.fetchPosts)
                            }
                        }
                        .background(
                            NavigationLink(
                                state: AppFeature.Path.State.detail(PostDetail.State(post: post))
                            ) {}
                                .opacity(0)
                        )
                }
                
                if store.loadingPosts {
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
                
                
            }, label: {
                Image(systemName: "list.dash")
                    .resizable()
                    .frame(width: 18, height: 14)
                    .tint(.black)
                
            }))
            .listStyle(.plain)
            .refreshable {
                store.send(.refreshPosts)
            }
            .onAppear {
                self.store.withState { state in
                    if state.posts.isEmpty {
                        store.send(.refreshPosts)
                    }
                }
            }
            
        }
    }
    
    private func isNeedLoadMore(post: Post) -> Bool {
        store.withState { state in
            post.id == state.posts.last?.id && !state.loadingPosts
        }
    }
    
}

