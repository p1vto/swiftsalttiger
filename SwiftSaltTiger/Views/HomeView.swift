//
//  HomeView.swift
//  SwiftSaltTiger
//
//  Created by p1vtoMiilo on 4/12/2021.
//

import SwiftUI

struct HomeView: View, StoreAccessor {
    @EnvironmentObject var store: Store
    @State private var blurRadius: CGFloat = 0
    @State private var direction: Direction = .none
    @State private var offset: CGFloat = -Defaults.FrameSize.slideMenuWidth
    @State private var postsViewEnable = true
    
    var body: some View {
        ZStack {
            PostsView()
                .blur(radius: blurRadius)
                .allowsHitTesting(postsViewEnable)
                .scaleEffect(1 - (blurRadius / 16))
                .edgesIgnoringSafeArea(.all)
                           
            SlideMenu()
                .offset(x: offset)
                
        }
        .gesture(dragGesture)
        .onReceive(AppNotification.shouldHideSlideMenu.publisher) { _ in
            performTransition(offset: -Defaults.FrameSize.slideMenuWidth)
        }
        .onReceive(AppNotification.shouldShowSlideMenu.publisher) { _ in
            performTransition(offset: 0)
        }
    }
    
}


extension HomeView {
    enum Direction {
        case none
        case toLeft
        case toRight
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                withAnimation(Animation.linear(duration: 0.2)) {
                    switch direction {
                        case .none:
                            let isToLeft = value.translation.width < 0
                            direction = isToLeft ? .toLeft : .toRight
                        case .toLeft:
                            if offset >= -Defaults.FrameSize.slideMenuWidth
                                && offset <= 0
                                && value.startLocation.x < Defaults.FrameSize.slideMenuWidth {
                                offset = max(value.translation.width, -Defaults.FrameSize.slideMenuWidth)
                            }
                        case .toRight:
                            if offset < 0, value.startLocation.x < 10 {
                                offset = min(-Defaults.FrameSize.slideMenuWidth + value.translation.width, 0)
                            }
                    }
                    blurRadius = 2 * (1 - (offset / -Defaults.FrameSize.slideMenuWidth))
                    
                }
            }
            .onEnded { value in
                let perdictedWidth = value.predictedEndTranslation.width
                if (perdictedWidth > Defaults.FrameSize.slideMenuWidth / 2
                    || -offset < Defaults.FrameSize.slideMenuWidth / 2)
                    && value.startLocation.x < 30 {
                    performTransition(offset: 0)
                }
                if (perdictedWidth < -Defaults.FrameSize.slideMenuWidth / 2
                    || -offset > Defaults.FrameSize.slideMenuWidth / 2)
                    && value.startLocation.x < Defaults.FrameSize.slideMenuWidth {
                    performTransition(offset: -Defaults.FrameSize.slideMenuWidth)
                }
                direction = .none
            }
    }
    
    
    func performTransition(offset: CGFloat) {
        withAnimation {
            self.offset = offset
            self.blurRadius = offset == 0 ? 2 : 0
            self.postsViewEnable = offset != 0
        }
        tryUpdateSlideMenuState(value: offset == -Defaults.FrameSize.slideMenuWidth)
    }
    
    func tryUpdateSlideMenuState(value: Bool) {
        guard homeState.sliderClose != value else { return }
        store.dispatch(.setSlideMenuClosed(closed: value))
    }
    
    
}
