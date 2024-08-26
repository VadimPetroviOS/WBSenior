//
//  Data.swift
//  WBSenior
//
//  Created by Вадим on 25.08.2024.
//

import Foundation
import SwiftData

@Model
final class Data: Identifiable {
    @Attribute(.unique)
    var id: UUID
    var name: String
    
    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}
