//
//  MainReducer.swift
//  WBSenior
//
//  Created by Вадим on 24.08.2024.
//

import ComposableArchitecture

enum Tab: String, CaseIterable, Identifiable {
    case graph
    case chat
    case hot
    case calendar
    case settings
}

extension Tab {
    var id: String {
        self.rawValue
    }
}

@Reducer
struct MainReducer {

    @ObservableState
    struct State: Equatable {
        var activeIndex: Tab = .graph
        
        var marketingSpecialists: [MarketingSpecialistData] = []
            
        static func == (lhs: MainReducer.State, rhs: MainReducer.State) -> Bool { true }
    }

    //MARK: /*tapOn*/
    
    enum Action {
        case graph
        case chat
        case hot
        case calendar
        case settings
        
//        case startLoad
//        case failed(Error)
//        case success([MarketingSpecialistData])
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
//        case .startLoad:
//            return .run { send in
//                do {
//                    let res = try await MockMainApi().getMarketingSpecialists()
//                    await send(.success(res))
//                } catch {
//                    await send(.failed(error))
//                }
//            }
//        case .failed(let error):
//            print(error)
//            return .none
//        case .success(let result):
//            state.marketingSpecialists = result
//            return .none
        case .graph:
            state.activeIndex = .graph
            return .none
        case .chat:
            state.activeIndex = .chat
            return .none
        case .hot:
            state.activeIndex = .hot
            return .none
        case .calendar:
            state.activeIndex = .calendar
            return .none
        case .settings:
            state.activeIndex = .settings
            return .none
        }
    }
}
