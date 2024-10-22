//
//  LoginViewController.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 15/10/2024.
//

import UIKit

extension Login {
    struct Model { }
    
    
    struct TileData: Equatable, Identifiable {
        let id = UUID()
        let title: String
        let location: String
    }
    
    static let tileDataMock: [Int: TileData] = [
        0: .init(title: "Acampamento 2013", location: "Brasilia, JK"),
        1: .init(title: "Acampamento 2014", location: "Brasilia, JK"),
        2: .init(title: "Acampamento 2015", location: "Brasilia, JK"),
        3: .init(title: "Acampamento 2016", location: "Brasilia, JK"),
        4: .init(title: "Acampamento 2017", location: "Brasilia, JK"),
        5: .init(title: "Acampamento 2018", location: "Brasilia, JK"),
        6: .init(title: "Acampamento 2019", location: "Brasilia, JK"),
        7: .init(title: "Acampamento 2020", location: "Brasilia, JK"),
        8: .init(title: "Acampamento 2021", location: "Brasilia, JK"),
        9: .init(title: "Acampamento 2022", location: "Brasilia, JK"),
        10: .init(title: "Acampamento 2023", location: "Brasilia, JK"),
        11: .init(title: "Acampamento 2024", location: "Brasilia, JK")
    ]
    
    
    struct User: Codable {
        let id: String
        let firstName: String?
        let lastName: String?
        let email: String
        
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
extension Login.User {
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
    ) -> Login.User {
        return Login.User(
            id: id,
            firstName: firstName,
            lastName: lastName,
            email: email
        )
    }
}
