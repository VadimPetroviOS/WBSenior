//
//  RAMView.swift
//  WBSenior
//
//  Created by Вадим on 10.09.2024.
//

import ComposableArchitecture
import Perception
import SwiftUI
import Utils
import Charts
import RickAndMortyAPI

struct RAMView: View {
    
    @Perception.Bindable
    var store: StoreOf<RAMReducer>
    
    var body: some View {
        WithPerceptionTracking {
            contentView
                .onRotate { newOrientation in
                    store.send(.updateOrientation(newOrientation.isPortrait))
                }
                .onAppear {
                    store.send(.startLoad)
                }
        }
    }
    
    private var contentView: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let spacing: CGFloat = 24
            let portraitHeight = min(size.width, size.height)
            
            VStack(spacing: spacing) {
                charactersCountChart
                    .frame(maxWidth: size.width, maxHeight: portraitHeight / 2)
                HStack(alignment: .top, spacing: spacing) {
                    charactersListView
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
    
    private var charactersCountChart: some View {
        CustomRectangle(28)
            .overlay (
                VStack(alignment: .leading, spacing: 16) {
                    Text("Количество появлений персонажей в эпизодах")
                        .font(.headline)
                        .foregroundStyle(.white)
                    Chart {
                        ForEach(store.characters, id: \.id) { character in
                            BarMark(
                                x: .value("Имена", character.name ?? ""),
                                y: .value("Количество", character.episode?.count ?? 0)
                            )
                            .foregroundStyle(.linearGradient(colors: [.green.opacity(0.5), .blue], startPoint: .top, endPoint: .bottom))
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
                        AxisMarks(position: .leading, values: Array(stride(from: 0, through: 60, by: 10))) { _ in
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
    
    private var charactersListView: some View {
        CustomRectangle(28)
            .overlay(
                VStack(alignment: .leading, spacing: 12) {
                    Text("Персонажи мультфильма")
                        .font(store.isPortrait ? .caption2 : .callout)
                        .foregroundColor(.white)
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(0..<store.characters.count, id: \.self) { index in
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.white).opacity(0.04)
                                    .frame(height: store.isPortrait ? 90 : 120)
                                    .overlay(
                                        characterOverlay(index)
                                    )
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                }
                    .padding(20)
            )
    }
    
    private func characterOverlay(_ index: Int) -> some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: .zero) {
                HStack(alignment: .top) {
                    characterImageView(index)
                    Spacer()
                    statusView(index)
                }
                if !store.isPortrait {
                    episodeCoverageView(index)
                    episodeCounterView(index)
                }
                Spacer()
            }
            .padding(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(store.characters[index].name ?? "")
                    .font(store.isPortrait ? .caption2 : .callout)
                    .foregroundStyle(.white)
                if !store.isPortrait {
                    Text(store.characters[index].location?.name ?? "")
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
    
    private func characterImageView(_ index: Int) -> some View {
        HStack {
            AsyncImage(url: URL(string: store.characters[index].image ?? "")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: 40, height: 40)
                case .failure:
                    Image(systemName: "photo")
                @unknown default:
                    EmptyView()
                }
            }
        }
    }
    
    private func statusView(_ index: Int) -> some View {
        let status = store.characters[index].status ?? "Unknown"
        let color: Color = {
            switch status {
            case "Alive":
                return .green
            case "Dead":
                return .red
            default:
                return .gray
            }
        }()
        
        return HStack(spacing: 2) {
            Text(status)
                .foregroundColor(color)
                .font(.caption2)
        }
    }
    
    private func episodeCoverageView(_ index: Int) -> some View {
        Rectangle()
            .fill(
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .purple, location: 0.0),
                        .init(color: .purple, location: min(Double(store.characters[index].episode?.count ?? 0) / 51.0, 1.0)),
                        .init(color: .white.opacity(0.08), location: min(Double(store.characters[index].episode?.count ?? 0) / 51.0, 1.0)),
                        .init(color: .white.opacity(0.08), location: 1.0)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(height: 6)
            .padding(.top, 20)
    }
    
    private func episodeCounterView(_ index: Int) -> some View {
        HStack {
            Text("Появление в эпизодах: \(store.characters[index].episode?.count ?? 0) / 51")
            Spacer()
            Text("\(String(format: "%.0f", (Double(store.characters[index].episode?.count ?? 0) / 51.0) * 100)) %")
        }
        .font(.caption2)
        .foregroundStyle(.white)
        .padding(.top, 10)
    }
}
