//
//  Model.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 22/10/24.
//

import Foundation
import Dependencies
import CustomDump

enum AppModel { }

extension AppModel {
    struct User: Codable {
        let id: String
        let firstName: String?
        let lastName: String?
        let email: String
        
        @Dependency(\.network) static var network
        
        // CodingKeys para mapear os campos snake_case do JSON para camelCase do Swift
        enum CodingKeys: String, CodingKey {
            case id
            case firstName = "first_name"
            case lastName = "last_name"
            case email
        }
    }
}

// Extensão para funcionalidades adicionais
extension AppModel.User {
    
    // Computed property para nome completo
    var fullName: String {
        [firstName, lastName]
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
    
    // Helper para criar instâncias mock para testes
    static func mock(
        id: String = "123",
        firstName: String? = "John",
        lastName: String? = "Doe",
        email: String = "john@example.com"
    ) -> Self {
        return Self(
            id: id,
            firstName: firstName,
            lastName: lastName,
            email: email
        )
    }
    
    static func getUserContent() async throws -> Self {
        do {
            let data = try await Self.network.get("/v1/profile")
            #if DEBUG
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON:", jsonString)
            }
            #endif
            let profile = try JSONDecoder().decode(Self.self, from: data)
            customDump(profile, name: "PROFILE")
            
            return profile
        } catch let error{
            throw error
        }
    }
}
