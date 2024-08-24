//
//  MainReducer.swift
//  WBSenior
//
//  Created by Вадим on 24.08.2024.
//

import ComposableArchitecture

@Reducer
struct MainReducer {

    @ObservableState
    struct State: Equatable {
        var activeIndex: Int = 0
        
        let tabImages = [
            "graphTab",
            "chat",
            "hot",
            "calendar",
            "settings"
        ]
        
        var marketingSpecialists: [MarketingSpecialistData] = []
            
        static func == (lhs: MainReducer.State, rhs: MainReducer.State) -> Bool { true }
    }

    enum Action {
        case graph
        case chat
        case hot
        case calendar
        case settings
        
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
        case .graph:
            state.activeIndex = 0
            return .none
        case .chat:
            state.activeIndex = 1
            return .none
        case .hot:
            state.activeIndex = 2
            return .none
        case .calendar:
            state.activeIndex = 3
            return .none
        case .settings:
            state.activeIndex = 4
            return .none
        }
    }
}
