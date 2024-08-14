//
//  WBSeniorApp.swift
//  WBSenior
//
//  Created by Вадим on 15.07.2024.
//

import SwiftUI
import ComposableArchitecture

@main
struct WBSeniorApp: App {
    var body: some Scene {
        WindowGroup {
            StatisticView(
                store: Store(
                    initialState: StatisticReducer.State(),
                    reducer: { StatisticReducer() }
                )
            )
        }
    }
}
