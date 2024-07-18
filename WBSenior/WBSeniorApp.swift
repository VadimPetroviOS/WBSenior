//
//  WBSeniorApp.swift
//  WBSenior
//
//  Created by Вадим on 15.07.2024.
//

import SwiftUI

@main
struct WBSeniorApp: App {
    @StateObject private var viewModel = CustomNavigationStackViewModel()
    
    var body: some Scene {
        WindowGroup {
            ExperimentView()
                .environmentObject(viewModel)
        }
    }
}
