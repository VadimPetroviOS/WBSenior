//
//  StatisticReducer.swift
//  WBSenior
//
//  Created by Вадим on 14.08.2024.
//

import ComposableArchitecture
import Foundation

@Reducer
struct StatisticReducer {
    
    @ObservableState
    struct State: Equatable {
        let nameTitle = "Статистика"
        let images = [
            "graph",
            "chat",
            "hot",
            "calendar",
            "settings"
        ]
    }
    
    enum Action {
       // нет действий
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        // нет событий для обработки
    }
}
