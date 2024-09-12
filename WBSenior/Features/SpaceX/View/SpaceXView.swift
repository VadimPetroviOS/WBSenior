//
//  SpaceXView.swift
//  WBSenior
//
//  Created by Вадим on 12.09.2024.
//

import ComposableArchitecture
import Perception
import SwiftUI
import Utils
import Charts
import RickAndMortyAPI
import SpaceXAPI

struct SpaceXView: View {
    
    @State
    var rockets: [RocketsQuery.Data.Rocket] = []
    
    var body: some View {
        contentView
            .onAppear {
                let query = RocketsQuery()
                NetworkService.shared.apollo.fetch(query: query) { result in
                    switch result {
                    case .success(let value):
                        self.rockets = value.data?.rockets?.compactMap { $0 } ?? []
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
    }
    
    var contentView: some View {
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
    }
    
    private var salesCountView: some View {
        CustomRectangle(28)
            .overlay {
                VStack(alignment: .leading, spacing: 16) {
                    Chart(rockets, id: \.id) { rocket in
                        PointMark(
                            x: .value("height", rocket.height?.meters ?? 0),
                            y: .value("mass", rocket.mass?.kg ?? 0)
                        )
                        .foregroundStyle(.blue)
                    }
                    .chartXAxis {
                        AxisMarks { _ in
                            AxisValueLabel()
                                .foregroundStyle(.gray.opacity(0.9))
                                .offset(y: 10)
                            AxisTick()
                            AxisGridLine()
                                .foregroundStyle(.gray.opacity(0.9))
                        }
                    }
                    .chartYAxis {
                        AxisMarks(position: .leading, values: Array(stride(from: 0, through: 1500000, by: 150000))) { _ in
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
                )
            }
    }
    
    private var marketingSpecialistsView: some View {
        CustomRectangle(28)
            .overlay(
                VStack(alignment: .leading, spacing: 0) {
                    Text("Характеристики ракет")
                        .font(.callout)
                        .foregroundColor(.white)
                    Spacer()
                    VStack(alignment: .leading, spacing: 12) {
                            ForEach(0..<rockets.count, id: \.self) { index in
                                marketingSpecialistsOverlay(index)
                            }
                    }
                }
                    .padding(20),
                alignment: .leading
            )
            
    }
    
    private func marketingSpecialistsOverlay(_ index: Int) -> some View {
            VStack(alignment: .leading, spacing: 4) {
                Text(rockets[index].name ?? "")
                    .font(.title)
                HStack {
                    Text("\(String(format: "%.0f", (Double(rockets[index].height?.meters ?? 0)))) м")
                        .font(.footnote)
                    Text("\(rockets[index].mass?.kg ?? 0) кг")
                        .font(.footnote)
                }
            }
            .foregroundStyle(.white)
    }
    
}
