//
//  Dota2TeamsReducer.swift
//  WBSenior
//
//  Created by Вадим on 12.09.2024.
//

import ComposableArchitecture
import Dota2TeamsAPI

@Reducer
struct Dota2TeamsReducer {

    @ObservableState
    struct State: Equatable {
        var teamsData: [TeamsGet200ResponseInner] = []
        var isPortrait: Bool = false
    }
    
    enum Action {
        case startLoad
        case loadTeamsResponse(Result<[TeamsGet200ResponseInner], Error>)
        case updateOrientation(Bool)
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .startLoad:
            return .run { send in
                Task {
                    do {
                        let results = try await DefaultAPI.teamsGet()
                            await send(.loadTeamsResponse(.success(
                                results
                                    .prefix(9)
                                    .filter { $0.name != "CyberBonch-1" }
                            )))
                    } catch {
                        await send(.loadTeamsResponse(.failure(error)))
                    }
                }
            }
            
        case .loadTeamsResponse(.success(let teams)):
            state.teamsData = teams
            return .none
            
        case .loadTeamsResponse(.failure(_)):
            state.teamsData = []
            return .none
            
        case .updateOrientation(let isPortrait):
                state.isPortrait = isPortrait
                return .none
            }
        }
}
