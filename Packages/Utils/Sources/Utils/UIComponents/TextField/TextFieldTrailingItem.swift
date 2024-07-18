//
//  TextFieldTrailingItem.swift
//
//
//  Created by Вадим on 05.07.2024.
//

import SwiftUI

public struct TextFieldTrailingItem {
    let image: Image
    let action: (() -> Void)?

    public init(image: Image, action: (() -> Void)?) {
        self.image = image
        self.action = action
    }
}
