//
//  OTPTextField.swift
//  WBSenior
//
//  Created by Вадим on 05.07.2024.
//

import SwiftUI

public struct OTPTextField: View {
    
    @Binding
    private var otpText: String
    
    @Binding
    private var isCorrectCode: Bool?
    
    @FocusState
    private var isKeyboardShowing: Bool
    
    private var wrongInputMessage: String?
    
    public init(
        otpText: Binding<String>,
        isCorrectCode: Binding<Bool?>,
        wrongInputMessage: String? = nil
    ) {
        _otpText = otpText
        _isCorrectCode = isCorrectCode
        self.wrongInputMessage = wrongInputMessage
    }
    
    public var body: some View {
        ZStack {
            HStack(spacing: 0) {
                ForEach(0..<4, id: \.self) { index in
                    otpTextBox(index)
                }
            }
            .background(
                TextField("", text: $otpText.limit(4))
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .frame(width: 1, height: 1)
                    .opacity(0.001)
                    .blendMode(.screen)
                    .focused($isKeyboardShowing)
            )
            .contentShape(Rectangle())
            .onTapGesture {
                isKeyboardShowing.toggle()
            }
            if let isCorrectCode, !isCorrectCode {
                wrongInputMessageContent
                    .padding(.top, 112)
            }
        }
    }
    
    @ViewBuilder
    private func otpTextBox(_ index: Int) -> some View {
        ZStack {
            if otpText.count > index {
                let startIndex = otpText.startIndex
                let charIndex = otpText.index(
                    startIndex,
                    offsetBy: index
                )
                let charToString = String(otpText[charIndex])
                Text(charToString)
                    .font(.system(size: 36))
            } else {
                Text("")
            }
        }
        .frame(width: 64, height: 80)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .background(.white).opacity(0.08)
                .overlay(
                    Group {
                        if let isCorrectCode = isCorrectCode {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(isCorrectCode ? Color.green : Color.red, lineWidth: 1)
                        } else {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.clear, lineWidth: 1)
                        }
                    }
                )
        )
        .frame(maxWidth: 86)
    }
    
    @ViewBuilder
    private var wrongInputMessageContent: some View {
        if let wrongInputMessage = wrongInputMessage {
                Text(wrongInputMessage)
                .font(.callout)
                .foregroundColor(Color.red)
                .padding(.top, 12)
        }
    }
}

struct OTPVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        OTPTextField(
            otpText: .constant("1111"),
            isCorrectCode: .constant(false),
            wrongInputMessage: "Неверный пароль"
        )
    }
}

@MainActor
extension Binding where Value == String {
    func limit(_ length: Int) -> Self {
        if self.wrappedValue.count > length {
            Task {
                self.wrappedValue = String(self.wrappedValue.prefix(length))
            }
        }
        return self
    }
}
