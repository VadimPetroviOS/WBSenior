//
//  RAMReducer.swift
//  WBSenior
//
//  Created by Вадим on 12.09.2024.
//

import ComposableArchitecture
import RickAndMortyAPI

@Reducer
struct RAMReducer {

    @ObservableState
    struct State: Equatable {
        var characters: [CharacterGet200ResponseResultsInner] = []
        var isPortrait: Bool = false
    }
    
    enum Action {
        case startLoad
        case loadCharactersResponse(Result<[CharacterGet200ResponseResultsInner], Error>)
        case updateOrientation(Bool)
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .startLoad:
            return .run { send in
                Task {
                    do {
                        let data = try await DefaultAPI.characterGet()
                        if let results = data.results {
                            await send(.loadCharactersResponse(.success(
                                results
                                    .prefix(9)
                                    .filter { $0.name != "Abadango Cluster Princess" }
                                    .map { $0 }
                            )))
                        } else {
                            await send(.loadCharactersResponse(.success([])))
                        }
                    } catch {
                        await send(.loadCharactersResponse(.failure(error)))
                    }
                }
            }
            
        case .loadCharactersResponse(.success(let characters)):
            state.characters = characters
            return .none
            
        case .loadCharactersResponse(.failure(_)):
            state.characters = []
            return .none
            
        case .updateOrientation(let isPortrait):
                state.isPortrait = isPortrait
                return .none
            }
        }
}
