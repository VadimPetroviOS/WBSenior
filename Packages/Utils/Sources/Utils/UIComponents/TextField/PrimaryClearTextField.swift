//
//  PrimaryClearTextField.swift
//  WBSenior
//
//  Created by Вадим on 03.07.2024.
//

import SwiftUI

public struct PrimaryClearTextField: View {
    private var wrongInputMessage: String?
    private let content: TextFieldTrailingItem?

    @State
    private var title: String

    @Binding
    private var text: String
    
    @Binding
    private var isCorrectPhoneNumber: Bool

    public init(
        _ title: String,
        wrongInputMessage: String? = nil,
        content: TextFieldTrailingItem? = nil,
        text: Binding<String>,
        isCorrectPhoneNumber: Binding<Bool>
    ) {
        self.title = title
        self.wrongInputMessage = wrongInputMessage
        self.content = content
        _text = text
        _isCorrectPhoneNumber = isCorrectPhoneNumber
    }

    public var body: some View {
        textFieldContent
    }

    // MARK: - Managing Subviews

    @ViewBuilder
    private var textFieldContent: some View {
            HStack(spacing: 0) {
                ZStack {
                    textField
                    if isCorrectPhoneNumber {
                        wrongInputMessageContent
                    }
                }
                if !text.isEmpty {
                    trailingContent
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .opacity(0.08)
                    .frame(height: Constants.contentSize)
            )

            
    }

    private var image: some View {
        content?.image
            .frame(width: Constants.contentSize, height: Constants.contentSize)
            .contentShape(Rectangle())
    }

    private var textField: some View {
        TextField(
            "",
            text: _text,
            prompt:
                Text(title)
                    .foregroundColor(.white)
                    .font(.headline)
        )
            .font(.headline)
            .padding(
                EdgeInsets(
                    top: isCorrectPhoneNumber ? 16 : 0,
                    leading: 16,
                    bottom: isCorrectPhoneNumber ? 8 : 0,
                    trailing: content.isNil ? 12 : 0
                )
            )
    }

    @ViewBuilder
    private var wrongInputMessageContent: some View {
        if let wrongInputMessage = wrongInputMessage {
            HStack(spacing: 0) {
                Text(wrongInputMessage)
                    .font(.caption2)
                    .foregroundColor(Color.red)
                    .padding(EdgeInsets(top: .zero, leading: 16, bottom: 28, trailing: .zero))
                
                Spacer()
            }
        }
    }

    @ViewBuilder
    private var trailingContent: some View {
        if let content = content {
            if let action = content.action {
                Button(
                    action: action,
                    label: { image.foregroundColor(.white) }
                )
            } else {
                image
                    .foregroundColor(.white)
            }
        }
    }
}

private enum Constants {
    static let contentSize: CGFloat = 48
}
