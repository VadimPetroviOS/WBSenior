//
//  MainView.swift
//  WBSenior
//
//  Created by Вадим on 23.08.2024.
//

import ComposableArchitecture
import Perception
import SwiftUI
import Utils

struct MainView: View {
    
    @Perception.Bindable
    var store: StoreOf<MainReducer>
    
    var body: some View {
        WithPerceptionTracking {
            contentView
        }
    }
    
    private var contentView: some View {
        ZStack {
            backgroundView
            HStack(alignment: .top) {
                tabbarView
                middleView
                Spacer()
            }
            .ignoresSafeArea()
        }
    }
    
    private var middleView: some View {
        Group {
            switch store.activeIndex {
            case .graph :
                StatisticView(
                    store: Store(
                        initialState: StatisticReducer.State(),
                        reducer: { StatisticReducer() }
                    )
                )
            case .chat :
                Dota2TeamsView(
                    store: Store(
                        initialState: Dota2TeamsReducer.State(),
                        reducer: { Dota2TeamsReducer() }
                    )
                )
            case .hot:
                RAMView(
                    store: Store(
                        initialState: RAMReducer.State(),
                        reducer: { RAMReducer() }
                    )
                )
            case .calendar:
                SpaceXView()
            default:
                noneView
            }
        }
    }
    
    private var backgroundView: some View {
        LinearGradient(
            gradient:
                Gradient(colors: Constants.backgroundColor),
            startPoint: .topTrailing,
            endPoint: .bottomLeading
        )
        .ignoresSafeArea()
    }
    
    private var tabbarView: some View {
        CustomRectangle(0)
            .opacity(0.8)
            .frame(maxWidth: 80, maxHeight: .infinity)
            .overlay(
                tabbarOverlay
            )
    }
    
    private var tabbarOverlay: some View {
        VStack {
            avatarView
            Spacer()
            menuView
            Spacer()
            createClaimView
        }
    }
    
    private var avatarView: some View {
        Image("Аватарка профиля")
            .foregroundStyle(.yellow)
            .frame(width: 44, height: 44)
            .padding(.top, 32)
    }
    
    private var menuView: some View {
        ForEach(Tab.allCases) { index in
            menuButtons(index)
        }
    }
    
    private func menuButtons(_ tab: Tab) -> some View {
        VStack(spacing: 64) {
            Button {
                handleMenuAction(for: tab)
            } label: {
                Image(tab.rawValue)
                    .resizable()
                    .renderingMode(.original)
                    .foregroundStyle(.white)
                    .frame(width: 24, height: 24)
                    .background(
                        menuButtonsBackgrond(tab)
                    )
                    .padding()
            }
        }
    }
    
    private func handleMenuAction(for tab: Tab) {
        switch tab {
        case .graph: store.send(.graph)
        case .chat: store.send(.chat)
        case .hot: store.send(.hot)
        case .calendar: store.send(.calendar)
        case .settings: store.send(.settings)
        }
    }
    
    private func menuButtonsBackgrond(_ tab: Tab) -> some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(store.activeIndex == tab ?
                  AnyShapeStyle(LinearGradient(
                    gradient: Gradient(colors: Constants.imagesBackgroundColor),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                  )) :
                    AnyShapeStyle(Color.clear)
            )
            .frame(width: 48, height: 48)
    }
    
    private var createClaimView: some View {
        Image(systemName: "plus.circle")
            .foregroundStyle(.white)
            .frame(width: 44, height: 44)
            .background(
                Circle()
                    .fill(.white).opacity(0.08)
                    .frame(width: 48, height: 48)
            )
            .padding(.bottom, 32)
    }
    
    private var noneView: some View {
        Rectangle()
            .frame(width: 0, height: 0)
    }
}
