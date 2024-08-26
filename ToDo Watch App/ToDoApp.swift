//
//  ToDoApp.swift
//  ToDo Watch App
//
//  Created by Вадим on 26.08.2024.
//

import SwiftUI

@main
struct ToDo_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            ToDoListView()
                .modelContainer(for: [Data.self])
        }
    }
}
