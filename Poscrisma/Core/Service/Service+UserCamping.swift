//
//  Service+UserCamping.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 29/10/24.
//

import Foundation
import Dependencies
import CustomDump

extension Service {
    
    // MARK: - Root Response
    struct MemberCampingResponse: Codable {
        let data: [MemberCamping]
    }

    // MARK: - Camping
    struct MemberCamping: Codable {
        let campingAddress: String
        let campingCode: String
        let campingId: UUID
        let campingName: String
        let memberRole: MemberRole
        let whenEntered: Date
        
        enum CodingKeys: String, CodingKey {
            case campingAddress = "camping_address"
            case campingCode = "camping_code"
            case campingId = "camping_id"
            case campingName = "camping_name"
            case memberRole = "member_role"
            case whenEntered = "when_entered"
        }
    }

    // MARK: - MemberRole
    enum MemberRole: String, Codable {
        case admin = "Admin"
        case manager = "Manager"
        case support = "Suport"
        case member = "Member"
    }
}

extension Service.MemberCamping {
    @Dependency(\.network) static var network
    
    // Helper para criar instâncias mock para testes
    static func mock(
        id: String = "123",
        firstName: String? = "John",
        lastName: String? = "Doe",
        email: String = "john@example.com"
    ) -> Self {
        return .init(
            campingAddress: "",
            campingCode: "",
            campingId: UUID(),
            campingName: "",
            memberRole: .admin,
            whenEntered: .now
        )
    }
    
    static func getUserHasCamping() async throws -> Service.MemberCampingResponse {
        do {
            let data = try await Self.network.get("/v1/camping/by_user")
            #if DEBUG
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON:", jsonString)
            }
            #endif

            let profile = try Service.MemberCampingResponse.decode(from: data)
            customDump(profile, name: "MemberCampingResponse")
            
            return profile
        } catch let error {
            throw error
        }
    }
}

// MARK: - Decoding Extension
extension Service.MemberCampingResponse {
    private static let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]
        return formatter
    }()
    
    static func decode(from jsonData: Data) throws -> Self {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            if let date = dateFormatter.date(from: dateString) {
                return date
            }
            
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Expected date string to be ISO8601-formatted with fractional seconds."
                )
            )
        }
        return try decoder.decode(Self.self, from: jsonData)
    }
}
