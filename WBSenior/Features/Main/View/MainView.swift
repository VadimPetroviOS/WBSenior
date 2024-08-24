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
                .onAppear {
                    store.send(.startLoad)
                }
        }
    }
    
    private var contentView: some View {
        ZStack {
            backgroundView
            HStack(alignment: .top) {
                tabbarView
                middleView
                Spacer()
                sidebarView
            }
            .ignoresSafeArea()
        }
    }
    
    private var middleView: some View {
        Group {
            switch store.activeIndex {
            case 0 :
                StatisticView(store.marketingSpecialists)
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
    
    private var sidebarView: some View {
        CustomRectangle(44)
            .opacity(0.8)
            .frame(maxWidth: 320, maxHeight: .infinity)
            .overlay(
                Group {
                    switch store.activeIndex {
                    case 0 :
                        sidebarOverlay
                    default:
                        noneView
                    }
                }
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
        ForEach(0..<store.tabImages.count, id: \.self) { index in
            menuButtons(index)
        }
    }
    
    private func menuButtons(_ index: Int) -> some View {
        VStack(spacing: 64) {
            Button {
                handleMenuAction(for: index)
            } label: {
                Image(store.tabImages[index])
                    .resizable()
                    .renderingMode(.original)
                    .foregroundStyle(.white)
                    .frame(width: 24, height: 24)
                    .background(
                        menuButtonsBackgrond(index)
                    )
                    .padding()
            }
        }
    }
    
    private func handleMenuAction(for index: Int) {
            switch index {
            case 0: store.send(.graph)
            case 1: store.send(.chat)
            case 2: store.send(.hot)
            case 3: store.send(.calendar)
            default: store.send(.settings)
            }
        }
    
    private func menuButtonsBackgrond(_ index: Int) -> some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(store.activeIndex == index ?
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
    
    private var sidebarOverlay: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Движение тренда в 2024")
                .font(.title3)
                .foregroundStyle(.white)
                .padding(
                    EdgeInsets(
                        top: 36,
                        leading: 20,
                        bottom: 20,
                        trailing: .zero
                    )
                )
            
            Image("trendChart")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 164)
            
            Text("Статистика за 09 месяц")
                .font(.callout)
                .foregroundStyle(.white)
                .padding(
                    EdgeInsets(
                        top: .zero,
                        leading: 20,
                        bottom: -16,
                        trailing: .zero
                    )
                )
            
            HStack {
                VStack(alignment: .leading, spacing: 32) {
                    gridElement(
                        imageName: "wallet",
                        text: "Цена",
                        value: "869$",
                        startFraction: 0.1,
                        finishFraction: 0.75
                        
                    )
                    gridElement(
                        imageName: "cart",
                        text: "Покупки",
                        value: "22300",
                        startFraction: 0.1,
                        finishFraction: 0.95
                    )
                    
                }
                Spacer()
                VStack(alignment: .leading, spacing: 32) {
                    gridElement(
                        imageName: "rocket",
                        text: "Клики",
                        value: "24%",
                        startFraction: 0.1,
                        finishFraction: 0.3
                    )
                    gridElement(
                        imageName: "build",
                        text: "Помощь",
                        value: "1,2%",
                        startFraction: 0.1,
                        finishFraction: 0.13
                    )
                }
            }
            .padding(20)
            
            Text("Данные для связи")
                .font(.callout)
                .foregroundStyle(.white)
                .padding(.leading, 20)
            
            ScrollView {
                VStack(spacing: 4) {
                    ForEach(0..<store.marketingSpecialists.count, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.white).opacity(0.04)
                            .frame(minWidth: 280, minHeight: 60)
                            .overlay(
                                HStack {
                                    Image(store.marketingSpecialists[index].name)
                                        .resizable()
                                        .frame(width: 32, height: 32)
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(store.marketingSpecialists[index].name)
                                            .font(.callout)
                                            .foregroundStyle(.white)
                                        Text(store.marketingSpecialists[index].nameCompany)
                                            .font(.footnote)
                                            .foregroundStyle(.gray)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.white)
                                }
                                .padding(12)
                                
                            )
                        
                    }
                    .padding(.horizontal, 20)
                    Spacer()
                }
            }
        }
    }
    
    private func gridElement(imageName: String, text: String, value: String, startFraction: CGFloat, finishFraction: CGFloat) -> some View {
        HStack(spacing: 25) {
            ZStack {
                Circle()
                    .stroke(.white.opacity(0.08), lineWidth: 5)
                    .frame(width: 48, height: 48)
                
                Circle()
                    .trim(from: startFraction, to: finishFraction)
                    .stroke(.purple, lineWidth: 5)
                    .frame(width: 48, height: 48)
                
                Image(imageName)
                    .resizable()
                    .frame(width: 20, height: 20)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(text)
                    .font(.footnote)
                    .foregroundStyle(.gray)
                Text(value)
                    .font(.callout)
                    .foregroundStyle(.white)
            }
        }
    }
    
    private var noneView: some View {
        Rectangle()
            .frame(width: 0, height: 0)
    }
}
