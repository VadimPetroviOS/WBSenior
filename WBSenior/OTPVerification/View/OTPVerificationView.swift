//
//  OTPVerificationView.swift
//  phoneAuth
//
//  Created by Вадим on 05.07.2024.
//

import SwiftUI
import Utils

struct OTPVerificationView<ViewModel: OTPVerification>: View {
    
    @StateObject
    private var viewModel: ViewModel
    
    @Environment(\.presentationMode)
    private var presentationMode
    
    @State private var timerCount = 60
    let timer = Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    var phoneNumber: String
    
    init(_ phoneNumber: String) where ViewModel == OTPVerificationViewModel {
        _viewModel = StateObject(wrappedValue: OTPVerificationViewModel())
        self.phoneNumber = phoneNumber
    }
    
    @State
    private var buttonTapped: Bool = false
    
    var body: some View {
        ZStack {
            backgroundView
            ZStack {
                verificationBackgroundView
                verificationView
            }
            backButton
        }
        .foregroundColor(.white)
        .onReceive(timer) { _ in
            if timerCount > 0 {
                timerCount -= 1
            }
        }
        .onTapGesture {
            hideKeyboardOnTap()
        }
    }
    
    private var backgroundView: some View {
        LinearGradient(
            gradient:
                Gradient(colors: Constants.backgroundColor),
            startPoint: .topTrailing,
            endPoint: .bottomLeading
        )
        .ignoresSafeArea()
    }
    
    private var verificationBackgroundView: some View {
        RoundedRectangle(cornerRadius: 28)
            .fill(
                LinearGradient(
                    gradient:
                        Gradient(colors: Constants.verificationBackground),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .opacity(0.8)
            .frame(width: 400, height: 429)
    }
    
    private var verificationView: some View {
            VStack(spacing: 16) {
                mailImage
                phoneNumberText
                otpField
                countdownTimerText
                verificationButton
            }
    }
    
    private var mailImage: some View {
        Image(Constants.mail)
            .resizable()
            .frame(width: 40, height: 40)
    }
    
    private var phoneNumberText: some View {
        Text(phoneNumber)
            .font(.title2)
    }
    
    private var otpField: some View {
        OTPTextField(
            otpText: $viewModel.code,
            isCorrectCode: $viewModel.isCorrectCode,
            wrongInputMessage: Constants.wrongMessage
        )
        .frame(height: 104)
        .padding(.top, 16)
    }
    
    private var countdownTimerText: some View {
        Text("Запросить повторно через \(timerCount) сек")
            .font(.subheadline)
            .padding(.top, 20)
    }
    
    private var verificationButton: some View {
        Button {
            Task {
                try await Task.sleep(nanoseconds: 1_000_000_000)
                buttonTapped.toggle()
            }
        } label: {
            Text(Constants.verification)
                .font(.headline)
        }
        .frame(width: 352, height: 48)
        .background(Constants.buttonColor)
        .opacity(!viewModel.isButtonDisabled ? 0.8 : 1)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.top, 8)
        .disabled(!viewModel.isButtonDisabled)
    }
    
    private var backButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            HStack(spacing: 0) {
                Image(systemName: Constants.back)
                    .frame(width: 20, height: 20)
                Text("Вернуться назад")
                    .font(.footnote)
            }
        }
        .padding(.top, 494)
        .foregroundColor(.white)
    }
}

private enum Constants {
    static let backgroundColor = [Color(#colorLiteral(red: 0.1496119499, green: 0.06467439979, blue: 0.2613010705, alpha: 1)), Color(#colorLiteral(red: 0.3601459265, green: 0.1982631087, blue: 0.4574922919, alpha: 1)), Color(#colorLiteral(red: 0.1496119499, green: 0.06467439979, blue: 0.2613010705, alpha: 1)), Color(#colorLiteral(red: 0.3601459265, green: 0.1982631087, blue: 0.4574922919, alpha: 1)), Color(#colorLiteral(red: 0.1496119499, green: 0.06467439979, blue: 0.2613010705, alpha: 1))]
    static let verificationBackground = [Color(#colorLiteral(red: 0.1342031956, green: 0.03351112828, blue: 0.1756711602, alpha: 1)), Color(#colorLiteral(red: 0.2551369667, green: 0.1475356817, blue: 0.3486914635, alpha: 1))]
    static let buttonColor = Color(#colorLiteral(red: 0.5204287767, green: 0.005214344244, blue: 0.9993483424, alpha: 1))
    
    static let wrongMessage = "Неверный пароль"
    static let verification = "Авторизоваться"
    
    static let mail = "mail"
    static let back = "chevron.backward"
}

struct OTPVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        OTPVerificationView("+7 (098) 545-34-34")
    }
}
