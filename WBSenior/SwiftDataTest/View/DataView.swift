//
//  DataView.swift
//  WBSenior
//
//  Created by Вадим on 25.08.2024.
//


import SwiftData
import SwiftUI

struct DataView: View {
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
                        .textFieldStyle(RoundedBorderTextFieldStyle())
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

