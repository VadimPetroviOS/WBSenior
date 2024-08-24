//
//  CustomRectangle.swift
//
//
//  Created by Вадим on 23.08.2024.
//

import SwiftUI

public struct CustomRectangle: View {
    
    let cornerRadius: CGFloat
    let barBackground = [Color(#colorLiteral(red: 0.1342031956, green: 0.03351112828, blue: 0.1756711602, alpha: 1)), Color(#colorLiteral(red: 0.2551369667, green: 0.1475356817, blue: 0.3486914635, alpha: 1))]
    
     public init(_ cornerRadius: CGFloat) {
        self.cornerRadius = cornerRadius
    }
    
    public var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: barBackground),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }
}
