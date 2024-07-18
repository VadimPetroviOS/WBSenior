//
//  PhoneAuthorizationView.swift
//  phoneAuth
//
//  Created by Вадим on 29.06.2024.
//

import SwiftUI
import Utils

struct PhoneAuthorizationView<ViewModel: PhoneAuthorization>: View {
    
    @StateObject
    private var viewModel: ViewModel
    
    @State
    private var buttonTapped: Bool = false
    
    init() where ViewModel == PhoneAuthorizationViewModel {
        _viewModel = StateObject(wrappedValue: PhoneAuthorizationViewModel())
    }
    
    var body: some View {
        ZStack {
            backgroundView
            ZStack {
                authorizationBackgroundView
                authorizationView
            }
            .foregroundColor(.white)
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
    
    private var authorizationBackgroundView: some View {
        RoundedRectangle(cornerRadius: 28)
            .fill(
                LinearGradient(
                    gradient:
                        Gradient(colors: Constants.authorizationBackground),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .opacity(0.8)
            .frame(width: 400, height: 429)
    }
    
    private var authorizationView: some View {
        VStack(spacing: 16) {
            authorizationTitleText
            userImage
            phoneNumberLoginText
            phoneField
            requestCodeButton
        }
    }
    
    private var authorizationTitleText: some View {
        Text(Constants.autorization)
            .font(.title)
            .bold()
    }
    
    private var userImage: some View {
        Image(Constants.avatar)
            .resizable()
            .frame(width: 96, height: 96)
            .padding(.top, 12)
    }
    
    private var phoneNumberLoginText: some View  {
        Text(Constants.phoneNumberLogin)
            .font(.subheadline)
    }
    
    private var phoneField: some View {
        PrimaryClearTextField(
            Constants.placeholder,
            wrongInputMessage: Constants.wrongMessage, content: .init(
                image: Image(systemName: Constants.xmark),
                action: { viewModel.text = "" }
                ),
                text: $viewModel.text,
                isCorrectPhoneNumber: $viewModel.isCorrectPhoneNumber
        )
        .frame(width: 352, height: 48)
        .padding(.top, 16)
        .onChange(of: viewModel.text) { _ in
            viewModel.text = viewModel.text.formatUserInput(
                pattern: Constants.incorrectNumber
            )
        }
        .keyboardType(.numberPad)
        
    }
    
    private var requestCodeButton: some View {
        Button {
            buttonTapped.toggle()
            hideKeyboardOnTap()
        } label: {
            Text(Constants.requestCode)
                .font(.headline)
        }
        .frame(width: 352, height: 48)
        .background(Constants.buttonColor)
        .opacity(!viewModel.isButtonDisabled ? 0.8 : 1)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.top, 8)
        .disabled(!viewModel.isButtonDisabled)
    }
}

private enum Constants {
    static let backgroundColor = [Color(#colorLiteral(red: 0.280854702, green: 0.1572261453, blue: 0.397690475, alpha: 1)), Color(#colorLiteral(red: 0.4826056361, green: 0.2909101248, blue: 0.5895795226, alpha: 1)), Color(#colorLiteral(red: 0.280854702, green: 0.1572261453, blue: 0.397690475, alpha: 1)), Color(#colorLiteral(red: 0.4826056361, green: 0.2909101248, blue: 0.5895795226, alpha: 1)), Color(#colorLiteral(red: 0.280854702, green: 0.1572261453, blue: 0.397690475, alpha: 1))]
    static let authorizationBackground = [Color(#colorLiteral(red: 0.1342031956, green: 0.03351112828, blue: 0.1756711602, alpha: 1)), Color(#colorLiteral(red: 0.2551369667, green: 0.1475356817, blue: 0.3486914635, alpha: 1))]
    static let buttonColor = Color(#colorLiteral(red: 0.5204287767, green: 0.005214344244, blue: 0.9993483424, alpha: 1))
    
    static let autorization = "Авторизация"
    static let phoneNumberLogin = "Вход по номеру телефона"
    static let placeholder = "+7 (___) ___-__-__"
    static let incorrectNumber = "+7 (___) ___-__-_____"
    static let wrongMessage = "Некорректный формат номера"
    static let requestCode = "Запросить код"
    
    static let avatar = "avatar"
    static let xmark = "xmark.circle.fill"
}

struct PhoneAuthorizationView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneAuthorizationView()
    }
}

