//
//  WBSeniorApp.swift
//  WBSenior
//
//  Created by Вадим on 15.07.2024.
//

import SwiftData
import SwiftUI

@main
struct WBSeniorApp: App {
    
    var body: some Scene {
        WindowGroup {
            DataView()
                .modelContainer(for: [Data.self])
        }
    }
}
