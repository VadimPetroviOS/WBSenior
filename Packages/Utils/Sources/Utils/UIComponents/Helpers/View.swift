//
//  View.swift
//
//
//  Created by Вадим on 06.07.2024.
//

import SwiftUI

public extension View {
    func hideKeyboardOnTap() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}
