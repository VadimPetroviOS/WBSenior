//
//  OTPVerificationViewModel.swift
//  phoneAuth
//
//  Created by Вадим on 06.07.2024.
//

import Foundation
import Combine

final class OTPVerificationViewModel: OTPVerification {
    @Published
    var code: String = ""
    
    @Published
    var isCorrectCode: Bool?
    
    var isButtonDisabled: Bool {
        guard let isCorrectCode = isCorrectCode else { return false }
        return isCorrectCode
    }
    
    private(set) var cancellables = Set<AnyCancellable>()
    
    init() {
        $code
            .dropFirst()
            .sink { [weak self] text in
                guard let self else { return }
                isCorrectCode = validateCode(code)
            }
            .store(in: &cancellables)
    }
    
    func validateCode(_ code: String) -> Bool? {
        let trueCode = "3221"
        if code.contains(trueCode) && code.count >= 4 {
            return true
        } else if code.count >= 4 {
            return false
        } else {
            return nil
        }
    }
}
