//
//  Dota2TeamsView.swift
//  WBSenior
//
//  Created by Вадим on 06.09.2024.
//

import ComposableArchitecture
import Perception
import SwiftUI
import Utils
import Charts
import Dota2TeamsAPI

struct Dota2TeamsView: View {
    
    @Perception.Bindable
    var store: StoreOf<Dota2TeamsReducer>
    
    var body: some View {
        WithPerceptionTracking {
            chartsContainerView
                .onRotate { newOrientation in
                    store.send(.updateOrientation(newOrientation.isPortrait))
                }
                .onAppear {
                    store.send(.startLoad)
                }
        }
    }
    
    private var chartsContainerView: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let spacing: CGFloat = 24
            let portraitHeight = min(size.width, size.height)
            
            VStack(spacing: spacing) {
                winRateChartView
                    .frame(maxWidth: size.width, maxHeight: portraitHeight / 2)
                HStack(alignment: .top, spacing: spacing) {
                    teamsListView
                        .frame(maxWidth: size.width / 2, maxHeight: portraitHeight / 2)
                    Spacer()
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
    }
    
    private func winRate(for team: TeamsGet200ResponseInner) -> Double {
        let wins = Double(team.wins ?? 0)
        let losses = Double(team.losses ?? 0)
        let totalGames = wins + losses
        return totalGames > 0 ? (wins / totalGames) * 100 : 0.0
    }

    private var winRateChartView: some View {
        CustomRectangle(28)
            .overlay(
                VStack(alignment: .leading, spacing: 16) {
                    Text("Винрейт команд")
                        .font(.headline)
                        .foregroundStyle(.white)
                    
                    Chart {
                        ForEach(store.teamsData.indices, id: \.self) { index in
                            let team = store.teamsData[index]
                            let winRateValue = winRate(for: team)
                            
                            BarMark(
                                x: .value("Название команд", team.name ?? ""),
                                y: .value("Винрейт", winRateValue)
                            )
                            .foregroundStyle(.linearGradient(colors: [.blue.opacity(0.5), .red], startPoint: .top, endPoint: .bottom))
                            .annotation(position: .overlay) {
                                teamLogo(index)
                            }
                        }
                    }
                    .chartXAxis {
                        AxisMarks { _ in
                            AxisValueLabel()
                                .foregroundStyle(.gray.opacity(0.9))
                                .offset(y: 10)
                        }
                    }
                    .chartYAxis {
                        AxisMarks(position: .leading, values: Array(stride(from: 0, through: 80, by: 10))) { _ in
                            AxisValueLabel()
                                .foregroundStyle(.gray.opacity(0.9))
                            AxisTick()
                            AxisGridLine()
                                .foregroundStyle(.gray.opacity(0.9))
                        }
                    }
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



    private func calculateWinRate(for team: TeamsGet200ResponseInner) -> Double {
        guard let wins = team.wins, let losses = team.losses else {
            return 0
        }
        
        let totalGames = Double(wins + losses)
        return totalGames > 0 ? (Double(wins) / totalGames) * 100 : 0
    }


    @ViewBuilder
    private func teamLogo(_ index: Int) -> some View {
        if let logoURL = store.teamsData[index].logoUrl, let url = URL(string: logoURL) {
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
            } placeholder: {
                ProgressView()
            }
        }
    }

    
    private var teamsListView: some View {
        CustomRectangle(28)
            .overlay(
                VStack(alignment: .leading, spacing: 12) {
                    Text("Команды")
                        .font(store.isPortrait ? .caption2 : .callout)
                        .foregroundColor(.white)
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(0..<store.teamsData.count, id: \.self) { index in
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.white).opacity(0.04)
                                    .frame(height: store.isPortrait ? 90 : 120)
                                    .overlay(
                                        teamOverlayView(index)
                                    )
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                }
                    .padding(20)
            )
    }
    
    @ViewBuilder
    private func teamOverlayView(_ index: Int) -> some View {
        let tag = store.teamsData[index].tag ?? "No Tag"
        if let name = store.teamsData[index].name {
            ZStack(alignment: .topLeading) {
                    VStack(spacing: .zero) {
                        HStack(alignment: .top) {
                            teamLogoView(index)
                            Spacer()
                        }
                        if !store.isPortrait {
                            winPercentageBarView(index)
                            teamStatsView(index)
                        }
                        Spacer()
                    }
                    .padding(12)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(name)
                            .font(store.isPortrait ? .caption2 : .callout)
                            .foregroundStyle(.white)
                        if !store.isPortrait {
                            Text(tag)
                                .font(.footnote)
                                .foregroundStyle(.gray)
                        }
                    }
                    .padding(
                        EdgeInsets(
                            top: store.isPortrait ? 60 : 12,
                            leading: store.isPortrait ? 12 : 60,
                            bottom: .zero,
                            trailing: .zero
                        )
                    )
                }
        }
    }
    
    private func teamLogoView(_ index: Int) -> some View {
        HStack {
            if let logoUrl = store.teamsData[index].logoUrl {
                AsyncImage(url: URL(string: logoUrl)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                    case .failure:
                        Image(systemName: "photo")
                    @unknown default:
                        EmptyView()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func winPercentageBarView(_ index: Int) -> some View {
        if let wins = store.teamsData[index].wins, let losses = store.teamsData[index].losses {
            let wins = Double(wins)
            let losses = Double(losses)
            let totalGames = wins + losses
            let winPercentage = totalGames > 0 ? wins / totalGames : 0.0
            
            let startColor = Color.purple
            let middleColor = Color.purple
            let endColor = Color.white.opacity(0.08)
            
            let gradientStops: [Gradient.Stop] = [
                .init(color: startColor, location: 0.0),
                .init(color: middleColor, location: winPercentage),
                .init(color: endColor, location: winPercentage),
                .init(color: endColor, location: 1.0)
            ]
            
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(stops: gradientStops),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 6)
                .padding(.top, 20)
        }
    }

    @ViewBuilder
    private func teamStatsView(_ index: Int) -> some View {
        let wins = store.teamsData[index].wins ?? 0
        let losses = store.teamsData[index].losses ?? 0
        let totalGames = wins + losses
        let winRate = totalGames > 0 ? Double(wins) / Double(totalGames) * 100 : 0.0

        HStack {
            Text("Побед: \(wins) / \(totalGames)")
            Spacer()
            Text("Винрейт \(String(format: "%.0f", winRate))%")
        }
        .font(.caption2)
        .foregroundStyle(.white)
        .padding(.top, 10)
    }

}
