//
//  StatisticView.swift
//  WBSenior
//
//  Created by Вадим on 14.08.2024.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct StatisticView: View {
    
    var store: StoreOf<StatisticReducer>
    
    @State
    private var activeIndex: Int? = nil
    
    var body: some View {
            ZStack {
                backgroundView
                HStack {
                    tabbarView
                    VStack {
                        Text(store.nameTitle)
                            .font(.title)
                            .bold()
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    .padding(32)
                    
                    Spacer()
                    sidebarView
                }
                .ignoresSafeArea()
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
        Rectangle()
            .fill(
                LinearGradient(
                    gradient:
                        Gradient(colors: Constants.barBackground),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .opacity(0.8)
            .frame(maxWidth: 80, maxHeight: .infinity)
            .overlay(
                tabbarOverlay
            )
    }
    
    private var tabbarOverlay: some View {
        VStack {
            Image("Аватарка профиля")
                .foregroundStyle(.yellow)
                .frame(width: 44, height: 44)
                .padding(.top, 32)
            Spacer()
            ForEach(0..<store.images.count, id: \.self) { index in
                VStack(spacing: 64) {
                    Image(store.images[index])
                        .resizable()
                    .renderingMode(.original)
                        .foregroundStyle(.white)
                        .frame(width: 24, height: 24)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(activeIndex == index ?
                                      AnyShapeStyle(LinearGradient(
                                        gradient: Gradient(colors: Constants.imagesBackgroundColor),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                      )) :
                                        AnyShapeStyle(Color.clear)
                                     )
                                .frame(width: 48, height: 48)
                        )
                        .onTapGesture {
                            if activeIndex == index {
                                activeIndex = nil
                            } else {
                                activeIndex = index
                            }
                        }
                        .padding()
                }
            }
            Spacer()
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
    }
    
    private var sidebarView: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    gradient:
                        Gradient(colors: Constants.barBackground),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .opacity(0.8)
            .frame(maxWidth: 320, maxHeight: .infinity)
    }
    
    
}

private enum Constants {
    static let backgroundColor = [Color(#colorLiteral(red: 0.1496119499, green: 0.06467439979, blue: 0.2613010705, alpha: 1)), Color(#colorLiteral(red: 0.3601459265, green: 0.1982631087, blue: 0.4574922919, alpha: 1)), Color(#colorLiteral(red: 0.1496119499, green: 0.06467439979, blue: 0.2613010705, alpha: 1)), Color(#colorLiteral(red: 0.3601459265, green: 0.1982631087, blue: 0.4574922919, alpha: 1)), Color(#colorLiteral(red: 0.1496119499, green: 0.06467439979, blue: 0.2613010705, alpha: 1))]
    static let barBackground = [Color(#colorLiteral(red: 0.1342031956, green: 0.03351112828, blue: 0.1756711602, alpha: 1)), Color(#colorLiteral(red: 0.2551369667, green: 0.1475356817, blue: 0.3486914635, alpha: 1))]
    static let imagesBackgroundColor = [Color(#colorLiteral(red: 0.8832342625, green: 0.1839636862, blue: 0.998164475, alpha: 1)), Color(#colorLiteral(red: 0.5623293519, green: 0, blue: 0.9990099072, alpha: 1))]
}
