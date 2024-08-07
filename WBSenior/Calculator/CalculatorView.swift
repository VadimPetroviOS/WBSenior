//
//  CalculatorView.swift
//  WBSenior
//
//  Created by Вадим on 06.08.2024.
//

import SwiftUI

struct CalculatorView: View {
    
    @StateObject
    var viewModel = CalculatorViewModel()
    
    let chars = ["1", "2", "3", "+", "4", "5", "6", "-", "7", "8", "9", "/", "0", "C", "=", "x"]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            calculatorInterfaceView
            calculatedValuesView
        }
    }
    
    private var calculatorInterfaceView: some View {
        LazyVGrid(columns: columns) {
            ForEach(0..<chars.count, id: \.self) { index in
                Button {
                    viewModel.appendNumberOrOperation(String(chars[index]))
                } label: {
                    Text(chars[index])
                        .font(.title)
                }
                .frame(width: 75, height: 75)
            }
            
        }
        .padding()
    }
    
    private var calculatedValuesView: some View {
        HStack {
            Text(viewModel.text)
                .font(.title)
                .accessibilityIdentifier("resultLabel")
            
            Spacer()
        }
        .padding(.horizontal, 48)
    }
}


#Preview {
    CalculatorView()
}
