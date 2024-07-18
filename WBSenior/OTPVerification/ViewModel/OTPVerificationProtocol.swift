//
//  OTPVerificationProtocol.swift
//  phoneAuth
//
//  Created by Вадим on 07.07.2024.
//

import Foundation

protocol OTPVerification: ObservableObject {
    var code: String { get set }
    var isCorrectCode: Bool? { get set }
    var isButtonDisabled: Bool { get }
}
