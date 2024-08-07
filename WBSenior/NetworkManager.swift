//
//  NetworkManager.swift
//  WBSenior
//
//  Created by Вадим on 07.08.2024.
//

import Foundation

//class NetworkManager {
//    private let session: URLSession
//    
//    init(session: URLSession = .shared) {
//        self.session = session
//    }
//    
//    func get(url: URL) async throws -> (Data, HTTPURLResponse) {
//        let (data, response) = try await session.data(from: url)
//        guard let httpResponse = response as? HTTPURLResponse else {
//            throw URLError(.badServerResponse)
//        }
//        return (data, httpResponse)
//    }
//    
//    func post(url: URL, body: Data) async throws -> (Data, HTTPURLResponse) {
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = body
//        let (data, response) = try await session.data(for: request)
//        guard let httpResponse = response as? HTTPURLResponse else {
//            throw URLError(.badServerResponse)
//        }
//        return (data, httpResponse)
//    }
//    
//    func put(url: URL, body: Data) async throws -> (Data, HTTPURLResponse) {
//        var request = URLRequest(url: url)
//        request.httpMethod = "PUT"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = body
//        let (data, response) = try await session.data(for: request)
//        guard let httpResponse = response as? HTTPURLResponse else {
//            throw URLError(.badServerResponse)
//        }
//        return (data, httpResponse)
//    }
//    
//    func delete(url: URL, body: Data) async throws -> (Data, HTTPURLResponse) {
//        var request = URLRequest(url: url)
//        request.httpMethod = "DELETE"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = body
//        let (data, response) = try await session.data(for: request)
//        guard let httpResponse = response as? HTTPURLResponse else {
//            throw URLError(.badServerResponse)
//        }
//        return (data, httpResponse)
//    }
//}

class NetworkManager {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func get(url: URL) async throws -> (Data, HTTPURLResponse) {
        try await request(url: url, method: "GET")
    }
    
    func post(url: URL, body: Data) async throws -> (Data, HTTPURLResponse) {
        try await request(url: url, method: "POST", body: body)
    }
    
    func put(url: URL, body: Data) async throws -> (Data, HTTPURLResponse) {
        try await request(url: url, method: "PUT", body: body)
    }
    
    func delete(url: URL, body: Data) async throws -> (Data, HTTPURLResponse) {
        try await request(url: url, method: "DELETE", body: body)
    }
    
    private func request(url: URL, method: String, body: Data? = nil) async throws -> (Data, HTTPURLResponse) {
        var request = URLRequest(url: url)
        request.httpMethod = method
        if let body = body {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = body
        }
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        return (data, httpResponse)
    }
}
