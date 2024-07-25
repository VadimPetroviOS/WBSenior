//
//  CargoView.swift
//  WBSenior
//
//  Created by Вадим on 25.07.2024.
//

import SwiftUI

struct CargoView: View {
    var body: some View {
        Text("Hello World!")
            .onAppear {
                start()
            }
    }
    
    private func start() {
        let array = [1, 2, 3, 4, 5]
        print(array[safe: 2] ?? "nil")
        print(array[safe: 10] ?? "nil")

        let dictionary = ["a": 1, "b": 2, "c": 3]
        print(dictionary.index(forKey: "b").flatMap { dictionary[safe: $0] } ?? ("nil", -1))
        print(dictionary.index(forKey: "z").flatMap { dictionary[safe: $0] } ?? ("nil", -1))

        
        let cargoOne = Cargo(width: 2.0, height: 3.0, depth: 4.0)
        let cargoTwo = Cargo(width: 1.5, height: 2.5, depth: 3.5)
        let totalVolume = cargoOne +++ cargoTwo
        print("Total Volume: \(totalVolume) m³")
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

infix operator +++

struct Cargo {
    var width: Double
    var height: Double
    var depth: Double

    var volume: Double {
        return width * height * depth
    }
    
    static func +++(lhs: Cargo, rhs: Cargo) -> Double {
        return lhs.volume + rhs.volume
    }
}

#Preview {
    CargoView()
}
