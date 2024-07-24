//
//  LanguageView.swift
//  WBSenior
//
//  Created by Вадим on 20.07.2024.
//

import Foundation
import SwiftUI

protocol LanguageDateUnit: ObservableObject {
    var selectedLanguage: String { get set }
    var meters: String { get set }
    var kilomiles: String { get set }
    func formattedCurrentDate(_ type: DateFormatter.Style) -> String
    func convertDistance(_ meters: String) -> String
}

final class LanguageDateUnitViewModel: LanguageDateUnit {
    @Published
    var selectedLanguage: String = (Locale.current.language.languageCode?.identifier ?? "en")
    
    @Published
    var meters: String = "" {
        didSet {
            kilomiles = convertDistance(meters)
        }
    }
    
    @Published
    var kilomiles: String = ""
    
    func formattedCurrentDate(_ type: DateFormatter.Style) -> String {
        let currentDate = Date()
        let formatter: DateFormatter
        
        switch type {
        case .long:
            formatter = DateFormatter.long
        case .medium:
            formatter = DateFormatter.medium
        default:
            formatter = DateFormatter.short
        }
        
        formatter.locale = Locale(identifier: selectedLanguage)
        return formatter.string(from: currentDate)
    }
    
    func convertDistance(_ meters: String) -> String {
        guard let metersValue = Double(meters) else { return "" }
        
        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.locale = Locale(identifier: selectedLanguage)
        measurementFormatter.unitOptions = .providedUnit
        
        let distanceInMeters = Measurement(value: metersValue, unit: UnitLength.meters)
        
        switch selectedLanguage {
        case "en":
            let distanceInMiles = distanceInMeters.converted(to: .miles)
            return measurementFormatter.string(from: distanceInMiles)
            
        default:
            let distanceInKilometers = distanceInMeters.converted(to: .kilometers)
            return measurementFormatter.string(from: distanceInKilometers)
        }
    }

}

struct LanguageDateUnitView<ViewModel: LanguageDateUnit>: View {
    @StateObject
    private var viewModel: ViewModel
    
    init() where ViewModel == LanguageDateUnitViewModel {
        _viewModel = StateObject(wrappedValue: LanguageDateUnitViewModel())
    }
    
    var body: some View {
        VStack {
            languageView
            dateView
            convertDistanceView
            changeLanguageButton
        }
        .environment(\.locale, Locale(identifier: viewModel.selectedLanguage))
        .padding()
    }
    
    private var languageView: some View {
        Text("hello")
            .font(.title)
            .padding()
    }
    
    private var dateView: some View {
        VStack {
            Text(viewModel.formattedCurrentDate(.long))
            Text(viewModel.formattedCurrentDate(.medium))
            Text(viewModel.formattedCurrentDate(.short))
        }
    }
    
    private var changeLanguageButton: some View {
        Button {
            viewModel.selectedLanguage = (viewModel.selectedLanguage == "en") ? "ru" : "en"
            viewModel.kilomiles = viewModel.convertDistance(viewModel.meters)
        } label: {
            Text("switchToEn/Ru")
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
    
    private var convertDistanceView: some View {
        VStack {
            TextField("distanceInMeters", text: $viewModel.meters)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .padding()
            
            Text("distance") + Text(viewModel.kilomiles)
        }
    }
}

public extension DateFormatter {
    static let long: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .long
        formatter.dateStyle = .long
        
        return formatter
    }()
    
    static let medium: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .medium
        
        return formatter
    }()
    
    static let short: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        
        return formatter
    }()
}

#Preview {
    LanguageDateUnitView()
}
