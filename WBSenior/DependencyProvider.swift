//
//  DependencyProvider.swift
//  WBSenior
//
//  Created by Вадим on 25.08.2024.
//

import SwiftUI
import Swinject

protocol APIServiceProtocol {
    func requestData()
}

class APIService: APIServiceProtocol {
    func requestData() {
        print("Запросить данные")
    }
}

protocol StorageServiceProtocol {
    func saveData()
}

class StorageService: StorageServiceProtocol {
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func saveData() {
        apiService.requestData()
        print("Сохранить данные")
    }
}

class DependencyContainer {
    static let shared = DependencyContainer()
    let container: Container
    
    private init() {
        container = Container()
        setupDependencies()
    }
    
    private func setupDependencies() {
        container.register(APIServiceProtocol.self) { _ in APIService() }
        container.register(StorageServiceProtocol.self) { resolver in
            let apiService = resolver.resolve(APIServiceProtocol.self)!
            return StorageService(apiService: apiService)
        }
    }
    
    func resolve<T>(_ type: T.Type) -> T? {
        return container.resolve(type)
    }
}

class DependencyProvider {
    static let shared = DependencyProvider()
    let container: Container
    
    private init() {
        container = Container()
        setupDependencies()
    }
    
    private func setupDependencies() {
        container.register(APIServiceProtocol.self) { _ in APIService() }
        container.register(StorageServiceProtocol.self) { resolver in
            let apiService = resolver.resolve(APIServiceProtocol.self)!
            return StorageService(apiService: apiService)
        }
    }
    
    func resolve<T>(_ type: T.Type) -> T? {
        return container.resolve(type)
    }
}

class ViewModel: ObservableObject {
    private let storageService: StorageServiceProtocol
    
    init(storageService: StorageServiceProtocol = DependencyContainer.shared.resolve(StorageServiceProtocol.self)!) {
        self.storageService = storageService
    }
    
    func storeData() {
        storageService.saveData()
    }
}

struct TestView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            Text("Welcome to TestView!")
            Button(action: {
                viewModel.storeData()
            }) {
                Text("Save Data")
            }
        }
        .padding()
    }
}


