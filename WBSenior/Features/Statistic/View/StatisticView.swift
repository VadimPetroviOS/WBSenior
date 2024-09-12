//
//  StatisticView.swift
//  WBSenior
//
//  Created by Вадим on 15.08.2024.
//

import ComposableArchitecture
import Perception
import SwiftUI
import Utils

struct StatisticView: View {
    
    @Perception.Bindable
    var store: StoreOf<StatisticReducer>
    
    @State
    private var isPortrait: Bool = false
    
    var body: some View {
            WithPerceptionTracking {
                chartsView
//                    .toolbar { toolbarContent }
                    .onRotate { newOrientation in
                        isPortrait = newOrientation.isPortrait
                    }
                    .onAppear {
                        store.send(.startLoad)
                    }
            }
    }
    
    private var chartsView: some View {
        HStack(alignment: .top) {
            GeometryReader { proxy in
                    let size = proxy.size
                    let spacing: CGFloat = 24
                    let portraitHeight = min(size.width, size.height)
                    
                    VStack(spacing: spacing) {
                        salesCountView
                            .frame(maxWidth: size.width, maxHeight: portraitHeight / 2)
                        HStack(alignment: .top, spacing: spacing) {
                            marketingSpecialistsView
                                .frame(maxWidth: size.width / 2, maxHeight: portraitHeight / 2)
                            VStack(spacing: spacing) {
                                externalTraffic
                                    .frame(maxWidth: size.width / 2, maxHeight: max(0, (portraitHeight / 8 * 3 - spacing)))
                                helpDeskView
                                    .frame(maxWidth: size.width / 2, maxHeight: portraitHeight / 8)
                            }
                        }
                    }
                    .padding(
                        EdgeInsets(
                            top: 85,
                            leading: 30,
                            bottom: 32,
                            trailing: 24
                        )
                    )
                }
            sidebarView
        }
    }
    
//    private var toolbarContent: some ToolbarContent {
//        Group {
//            ToolbarItem(placement: .topBarLeading) {
//                Text("Статистика")
//                    .font(.title)
//                    .bold()
//                    .foregroundStyle(.white)
//                    .padding(
//                        EdgeInsets(
//                            top: 32,
//                            leading: 110,
//                            bottom: 24,
//                            trailing: .zero
//                        )
//                    )
//            }
//            ToolbarItem(placement: .topBarTrailing) {
//                HStack(spacing: 24) {
//                    Button {
//                        
//                    } label: {
//                        HStack(spacing: 6) {
//                            Image("slider")
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: 20, height: 20)
//                            if !isPortrait {
//                                Text("Отображение виджетов")
//                                    .font(.callout)
//                                    .foregroundStyle(.white)
//                            }
//                        }
//                    }
//                    Button {
//                        
//                    } label: {
//                        HStack(spacing: 6) {
//                            Image("share")
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: 20, height: 20)
//                            if !isPortrait {
//                                Text("Поделиться")
//                                    .font(.callout)
//                                    .foregroundStyle(.white)
//                            }
//                        }
//                    }
//                }
//                .padding(
//                    EdgeInsets(
//                        top: 41,
//                        leading: .zero,
//                        bottom: 24,
//                        trailing: 344
//                    )
//                )
//            }
//        }
//        
//    }
    
    private var salesCountView: some View {
        CustomRectangle(28)
            .overlay (
                VStack(alignment: .leading, spacing: 6) {
                    Text("Количество продаж")
                        .font(.body)
                        .foregroundColor(.white)
                    Text("+53% продаж")
                        .font(.footnote)
                        .foregroundColor(.green)
                    +
                    Text(" сравнительно с прошлым годом")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Image("chart")
                        .resizable()
                        .padding(.top, 18)
                }
                    .padding(
                        EdgeInsets(
                            top: 24,
                            leading: 24,
                            bottom: 26,
                            trailing: 24
                        )
                    ),
                alignment: .topLeading
            )
    }
    
    private var marketingSpecialistsView: some View {
        CustomRectangle(28)
            .overlay(
                VStack(alignment: .leading, spacing: 12) {
                    Text("Маркетинговые специалисты")
                        .font(isPortrait ? .caption2 : .callout)
                        .foregroundColor(.white)
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(0..<store.marketingSpecialists.count, id: \.self) { index in
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.white).opacity(0.04)
                                    .frame(height: isPortrait ? 90 : 120)
                                    .overlay(
                                        marketingSpecialistsOverlay(index)
                                    )
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                }
                    .padding(20)
            )
    }
    
    private func marketingSpecialistsOverlay(_ index: Int) -> some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: .zero) {
                HStack(alignment: .top) {
                    specialistInfoView(index)
                    Spacer()
                    ratingView(index)
                }
                if !isPortrait {
                    fillLevelView(index)
                    completedSalesView(index)
                }
                Spacer()
            }
            .padding(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(store.marketingSpecialists[index].name)
                    .font(isPortrait ? .caption2 : .callout)
                    .foregroundStyle(.white)
                if !isPortrait {
                    Text(store.marketingSpecialists[index].grade)
                        .font(.footnote)
                        .foregroundStyle(.gray)
                }
            }
            .padding(
                EdgeInsets(
                    top: isPortrait ? 60 : 12,
                    leading: isPortrait ? 12 : 60,
                    bottom: .zero,
                    trailing: .zero
                )
            )
        }
    }
    
    private func specialistInfoView(_ index: Int) -> some View {
        HStack {
            Image(store.marketingSpecialists[index].name)
                .resizable()
                .frame(width: 40, height: 40)
        }
    }
    
    private func ratingView(_ index: Int) -> some View {
        HStack(spacing: 2) {
            Image(systemName: "star.fill")
                .foregroundStyle(.purple)
                .font(.callout)
            Text(store.marketingSpecialists[index].rating)
                .foregroundStyle(.white)
                .font(.caption2)
        }
    }
    
    private func fillLevelView(_ index: Int) -> some View {
        Rectangle()
            .fill(
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .purple, location: 0.0),
                        .init(color: .purple, location: Double(store.marketingSpecialists[index].persentage) / 100),
                        .init(color: .white.opacity(0.08), location: Double(store.marketingSpecialists[index].persentage) / 100),
                        .init(color: .white.opacity(0.08), location: 1.0)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(height: 6)
            .padding(.top, 20)
    }
    
    private func completedSalesView(_ index: Int) -> some View {
        HStack {
            Text("Выполнено продаж: \(store.marketingSpecialists[index].totalSales) / 1 700")
            Spacer()
            Text("Выполнено \(store.marketingSpecialists[index].persentage)%")
        }
        .font(.caption2)
        .foregroundStyle(.white)
        .padding(.top, 10)
    }
    
    private var helpDeskView: some View {
        ZStack {
            Image("AIbackground")
                .resizable()
                .clipShape(
                    RoundedRectangle(cornerRadius: 28)
                )
            VStack(spacing: 12) {
                if !isPortrait {
                    Text("ИИ в техподдержке")
                        .font(.body)
                        .foregroundStyle(.white)
                }
                Button {
                    //
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.black).opacity(0.88)
                        .overlay(
                            Text("Нужна помощь")
                                .font(.caption)
                                .foregroundStyle(.white)
                                .padding(12)
                        )
                        .frame(width: 120, height: 36)
                }
            }
        }
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
    
    private var externalTraffic: some View {
        CustomRectangle(28)
            .overlay(
                VStack(spacing: 12) {
                    HStack {
                        Text("Внешний трафик")
                            .font(isPortrait ? .caption2 : .body)
                            .foregroundStyle(.white)
                        Spacer()
                        if !isPortrait {
                            HStack(spacing: 2) {
                                Text("Май 2024")
                                Image(systemName: "chevron.down")
                            }
                            .font(.footnote)
                            .foregroundStyle(.gray)
                        }
                    }
                    Spacer()
                    circlePercentageView
                }
                    .padding(20)
            )
    }
    
    private var circlePercentageView: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .trim(from: 120 / 360, to: 330 / 360)
                    .stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round, lineJoin: .round))
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: Constants.circleColor),
                            startPoint: .bottomLeading,
                            endPoint: .topTrailing
                        )
                    )
                VStack {
                    Text("78%")
                        .font(isPortrait ? .caption2 : .system(size: 36))
                        .foregroundStyle(.white)
                    if !isPortrait {
                        Text("От всех покупок")
                            .font(.caption2)
                            .foregroundStyle(.gray)
                    }
                }
            }
            if !isPortrait {
                Spacer()
                VStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundStyle(.white).opacity(0.04)
                        .overlay(
                            VStack(alignment: .leading, spacing: 4) {
                                Text("445 чел.")
                                    .font(.footnote)
                                    .foregroundStyle(.white)
                                Text("Новые клиенты")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                                .padding(12)
                            ,
                            alignment: .leading
                        )
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundStyle(.white).opacity(0.04)
                        .overlay(
                            VStack(alignment: .leading, spacing: 4) {
                                Text("4511 чел.")
                                    .font(.footnote)
                                    .foregroundStyle(.white)
                                Text("Всего с внешнего трафика")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                                .padding(12)
                            ,
                            alignment: .leading
                        )
                }
            }
        }
    }
    
    private var sidebarView: some View {
        CustomRectangle(44)
            .opacity(0.8)
            .frame(maxWidth: 320, maxHeight: .infinity)
            .overlay(
                sidebarOverlay
            )
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
}
