//
//  NetworkManagerTests.swift
//  WBSenior
//
//  Created by Вадим on 27.07.2024.
//

@testable import WBSenior
import XCTest
import Foundation


class NetworkManagerTests: XCTestCase {
    
    var networkManager: NetworkManager!
    var url: URL!
    let expectedStatusCode = 200
    
    override func setUp() {
        super.setUp()
        networkManager = NetworkManager(session: URLSession(configuration: .ephemeral))
    }
    
    override func tearDown() {
        networkManager = nil
        url = nil
        super.tearDown()
    }
    
    func testGet() async throws {
        url = URL(string: "http://petstore.swagger.io/v2/pet/findByStatus?status=available")!
        let (_, response) = try await networkManager.get(url: url)
        XCTAssertEqual(response.statusCode, expectedStatusCode)
    }
    
    
    func testPost() async throws {
        url = URL(string: "https://petstore.swagger.io/v2/pet")!
        let postData: [String: Any] = [
                "id": 0,
                "category": [
                    "id": 0,
                    "name": "string"
                ],
                "name": "doggie",
                "photoUrls": ["string"],
                "tags": [
                    [
                        "id": 0,
                        "name": "string"
                    ]
                ],
                "status": "available"
            ]
        let jsonData = try JSONSerialization.data(withJSONObject: postData)
        let (_, response) = try await networkManager.post(url: url, body: jsonData)
        XCTAssertEqual(response.statusCode, expectedStatusCode)
    }
    
    func testPut() async throws {
        url = URL(string: "https://petstore.swagger.io/v2/pet")!
        let putData: [String: Any] = [
                "id": 1,
                "category": [
                    "id": 0,
                    "name": "string"
                ],
                "name": "doggie",
                "photoUrls": ["string"],
                "tags": [
                    [
                        "id": 0,
                        "name": "string"
                    ]
                ],
                "status": "available"
            ]
        let jsonData = try JSONSerialization.data(withJSONObject: putData)
        let (_, response) = try await networkManager.put(url: url, body: jsonData)
        XCTAssertEqual(response.statusCode, expectedStatusCode)
    }
    
    func testDelete() async throws {
        url = URL(string: "https://petstore.swagger.io/v2/pet")!
        let petId = 9223372036854600000
        let postData: [String: Any] = [
                "id": petId,
                "category": [
                    "id": 0,
                    "name": "string"
                ],
                "name": "doggie",
                "photoUrls": ["string"],
                "tags": [
                    [
                        "id": 0,
                        "name": "string"
                    ]
                ],
                "status": "available"
            ]
        Task {
            let postJsonData = try JSONSerialization.data(withJSONObject: postData)
            let (_, _) = try await networkManager.post(url: url, body: postJsonData)
            
            url = URL(string: "https://petstore.swagger.io/v2/pet/9223372036854600000")!
            let deleteData = [
                    "petId": petId,
                ]
            try await Task.sleep(nanoseconds: 2_000_000_000)
            let deleteJsonData = try JSONSerialization.data(withJSONObject: deleteData)
            let (_, response) = try await networkManager.delete(url: url, body: deleteJsonData)
            XCTAssertEqual(response.statusCode, expectedStatusCode)
        }
    }
}

