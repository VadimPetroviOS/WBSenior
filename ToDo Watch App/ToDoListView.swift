//
//  ContentView.swift
//  ToDo Watch App
//
//  Created by Вадим on 26.08.2024.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Data {
    @Attribute(.unique)
    var id: UUID
    var name: String

    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}

struct ToDoListView: View {
    @Environment(\.modelContext)
    private var context

    @Query
    var items: [Data] = []


    @State
    private var newItemName: String = ""

    var body: some View {
            VStack {
                List {
                    ForEach(items) { item in
                        HStack {
                            Text(item.name)
                            Spacer()
                        }
                    }
                    .onDelete(perform: { indexSet in
                        indexSet.forEach { offset in
                            context.delete(items[offset])
                        }
                        saveContext()
                    })
                }
                HStack {
                    TextField("New Item", text: $newItemName)
                        .padding(.horizontal)

                    Button("Add") {
                        let newItem = Data(name: newItemName)
                        context.insert(newItem)
                        saveContext()
                        newItemName = ""
                    }
                    .padding()
                }
            }
            .padding()
        }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed")
        }
    }
}

#Preview {
    ToDoListView()
}
