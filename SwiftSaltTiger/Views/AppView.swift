//
//  HomeView.swift
//  SwiftSaltTiger
//
//  Created by p1vtoMiilo on 4/12/2021.
//

import SwiftUI
import ComposableArchitecture

// MARK: Reducer
struct AppFeature: Reducer {
    struct State: Equatable {
      var path = StackState<Path.State>()
      var postList = PostList.State()
    }

    enum Action {
      case path(StackAction<Path.State, Path.Action>)
      case postList(PostList.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.postList, action: /Action.postList) {
          PostList()
        }
        
        Reduce { state, action in
            switch action {
            case .path:
                return .none
            case .postList:
                return .none
            }
        }
        .forEach(\.path, action: /Action.path) {
          Path()
        }
    }
    
    struct Path: Reducer {
      enum State: Equatable {
        case detail(PostDetail.State)
      }

      enum Action {
        case detail(PostDetail.Action)
      }

      var body: some Reducer<State, Action> {
        Scope(state: /State.detail, action: /Action.detail) {
          PostDetail()
        }
       
      }
    }

}

// MARK: View
struct AppView: View {
    let store: StoreOf<AppFeature>
    
    var body: some View {
      NavigationStackStore(self.store.scope(state: \.path, action: { .path($0) })) {
          PostsView(
          store: self.store.scope(state: \.postList, action: { .postList($0) })
        )
      } destination: {
        switch $0 {
        case .detail:
          CaseLet(
            /AppFeature.Path.State.detail,
            action: AppFeature.Path.Action.detail,
            then: PostDetailView.init(store:)
          )
    
        }
      }
    }
    
}



