////
////  SpaceXReducer.swift
////  WBSenior
////
////  Created by Вадим on 12.09.2024.
////
//
//import ComposableArchitecture
//import SpaceXAPI
//import Foundation
//
//@Reducer
//struct SpaceXReducer {
//    
//    @ObservableState
//    struct State: Equatable {
//        var rockets: [RocketsQuery.Data.Rocket] = []
//    }
//    
//    enum Action {
//        case startLoad
//        case failed(Error)
//        case success([RocketsQuery.Data.Rocket])
//    }
//    
//    func reduce(into state: inout State, action: Action) -> Effect<Action> {
//        switch action {
//        case .startLoad:
//            return .run { send in
//                let query = RocketsQuery()
//                do {
//                    let result = try await NetworkService.shared.apollo.fetch(query: query)
//                    if let rockets = result {
//                        await send(.success(rockets.compactMap { $0?.fragments.rocketFragment }))
//                    } else {
//                        await send(.failed(NSError(domain: "NoData", code: -1, userInfo: nil)))
//                    }
//                } catch {
//                    await send(.failed(error))
//                }
//                
//            case .failed(let error):
//                // Обработка ошибки
//                print("Failed with error: \(error)")
//                return .none
//                
//            case .success(let rockets):
//                // Обработка успешного результата
//                state.rockets = rockets
//                return .none
//            }
//        }
//    }
//}
//    
