//
//  StatisticReducer.swift
//  WBSenior
//
//  Created by Вадим on 11.09.2024.
//

import ComposableArchitecture

@Reducer
struct StatisticReducer {

    @ObservableState
    struct State: Equatable {
        var marketingSpecialists: [MarketingSpecialistData] = []
            
        static func == (lhs: StatisticReducer.State, rhs: StatisticReducer.State) -> Bool { true }
    }
    
    enum Action {
        case startLoad
        case failed(Error)
        case success([MarketingSpecialistData])
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .startLoad:
            return .run { send in
                do {
                    let res = try await MockMainApi().getMarketingSpecialists()
                    await send(.success(res))
                } catch {
                    await send(.failed(error))
                }
            }
        case .failed(let error):
            print(error)
            return .none
        case .success(let result):
            state.marketingSpecialists = result
            return .none
        }
    }
}
