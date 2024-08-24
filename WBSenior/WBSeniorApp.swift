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
            MainView(
                store: Store(
                    initialState: MainReducer.State(),
                    reducer: { MainReducer() }
                )
            )
        }
    }
}
