//
//  PostDetailView.swift
//  SwiftSaltTiger
//
//  Created by p1vtoMiilo on 29/11/2021.
//

import SwiftUI
import ComposableArchitecture

// MARK: Reducer
struct PostDetail: Reducer {
    struct State: Equatable {
        var post: Post
        var loading = false
        var postDetailError: AppError?
    }
    
    enum Action {
        case fetchPostDetail(post: Post)
        case fetchPostDetailDone(result: Result<(String, [Comment]), AppError>)
        case fetchPostDetailErrorPresented
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetchPostDetail(let post):
                state.loading = true
                return .run { send in
                    let result = await ClientRequest.fetchPostDetail(post: post)
                    await send(.fetchPostDetailDone(result: result))
                }
            case .fetchPostDetailDone(let result):
                state.loading = false
                switch result {
                case .success(let data):
                    state.post.detail = data.0
                    state.post.comments = data.1
                case .failure(let err):
                    state.postDetailError = err
                }
                return .none
            case.fetchPostDetailErrorPresented:
                return .none
            }
           
        }
    }
}


// MARK: View
struct PostDetailView: View {
    let store: StoreOf<PostDetail>
    
    @State private var isPresentingWebView = false
    @State private var isPresentError = false
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { store in
            ScrollView {
                VStack(alignment: .leading) {
                    Text(store.post.title)
                        .foregroundColor(.black)
                        .font(.system(size: 22).bold())
                        .padding()
                    
                    HStack {
                        if let url = URL(string: store.post.cover) {
                            CacheAsyncImage(url: url)
                                .frame(width: 150, height: 180)
                                .cornerRadius(10)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Date: \(store.post.pubDate)")
                                .foregroundColor(.black)
                                .font(.system(size: 16))
                            
                            Text("Publisher: \(store.post.publisher)")
                                .foregroundColor(.black)
                                .font(.system(size: 16))
                            
                            if !store.post.downloadCode.isEmpty {
                                Text("Code: \(store.post.downloadCode)")
                                    .foregroundColor(.black)
                                    .font(.system(size: 16))
                            }
                            
                            
                            Spacer()
                        }
                        .padding()
                    }
                    
                    
                    if store.loading {
                        VStack {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                            .padding()
                        }
                        
                    } else {
                        Text(store.post.detail ?? "")
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
                        
                        if let comments = store.post.comments,
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
            .navigationBarTitleDisplayMode(.inline)
            .task {
                store.send(.fetchPostDetail(post: store.post))
            }
            .onChange(of: store.postDetailError) { newValue in
                isPresentError = !(newValue == nil)
            }
            .popover(isPresented: $isPresentingWebView) {
                WebContentView(url: URL(string: store.post.downloadLink)!)
            }
        }
    }
}
