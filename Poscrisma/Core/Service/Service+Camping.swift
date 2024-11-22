//
//  Service+Camping.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 28/10/24.
//

import Foundation
import Dependencies
import CustomDump

extension Service {
    struct Camping: Codable {
        
        struct CampingCreateRequest: Codable {
            let address: String
            let campingCode: String
            let name: String
            
            enum CodingKeys: String, CodingKey {
                case address
                case campingCode = "camping_code"
                case name
            }
        }
    }
}

extension Service.Camping {
    @Dependency(\.network) static var network
    
    // Computed property para nome completo
    
    // Helper para criar instâncias mock para testes
    static func mock() -> Self {
        return Self()
    }
    
    static func createCamping(
        address: String,
        campingCode: String,
        name: String
    ) async throws -> Void {
        let request = CampingCreateRequest(
            address: address,
            campingCode: campingCode,
            name: name
        )
        print("data JSON:", request)
        let jsonData = try JSONEncoder().encode(request)
        print("data JSON:", jsonData)
        
        do {
            let data = try await Self.network.post("/v1/camping/create", jsonData)
            #if DEBUG
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON:", jsonString)
            }
            #endif
        } catch let error{
            throw error
        }
    }
}
