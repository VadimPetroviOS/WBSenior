//
//  PhoneAuthorizationProtocol.swift
//  phoneAuth
//
//  Created by Вадим on 04.07.2024.
//

import Foundation

protocol PhoneAuthorization: ObservableObject {
    var text: String { get set }
    var isCorrectPhoneNumber: Bool { get set }
    var isButtonDisabled: Bool { get }
}
