//
//  Manager+Network.swift
//  GetUp
//
//  Created by Rodrigo Souza on 05/09/24.
//

import Foundation
import Dependencies
import CustomDump

extension Manager {
    struct Network: Sendable {
        // Configuration
        struct Configuration {
            let baseURL: URL
            let timeout: TimeInterval
            let retryCount: Int
            
            static let `default` = Configuration(
                baseURL: URL(string: "http://192.168.15.75:3300")!,
                timeout: 0,
                retryCount: 0
            )
        }
        
        private let configuration: Configuration = .default
        
        public var get: @Sendable (String) async throws -> Data
        public var post: @Sendable (String, Data?) async throws -> Data
        public var put: @Sendable (String, Data?) async throws -> Data
        public var delete: @Sendable (String) async throws -> Data
    }
}

extension Manager.Network: DependencyKey {
    public static let liveValue: Self = {
        let configuration = Configuration.default
        return Self(
            get: { endpoint in
                return try await request(endpoint: endpoint, method: "GET", configuration: configuration)
            },
            post: { endpoint, body in
                return try await request(endpoint: endpoint, method: "POST", body: body, configuration: configuration)
            },
            put: { endpoint, body in
                return try await request(endpoint: endpoint, method: "PUT", body: body, configuration: configuration)
            },
            delete: { endpoint in
                return try await request(endpoint: endpoint, method: "DELETE", configuration: configuration)
            }
        )
    }()
    
    private static func request(
        endpoint: String,
        method: String,
        body: Data? = nil,
        configuration: Configuration
    ) async throws -> Data {
        let url = configuration.baseURL.appendingPathComponent(endpoint)
        
        // Create URLSession with configuration
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = configuration.timeout
        let session = URLSession(configuration: sessionConfig)
        
        func performRequest(attempt: Int) async throws -> Data {
            var request = URLRequest(url: url)
            request.httpMethod = method
            request.httpBody = body
            
            interceptRequest(&request)
            
            do {
                let (data, response) = try await session.data(for: request)
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }
                
                switch httpResponse.statusCode {
                case 200...299:
                    return data
                case 400...599:
                    // Tenta decodificar o erro do serviço
                    do {
                        #if DEBUG
                        if let jsonString = String(data: data, encoding: .utf8) {
                            print("Error - Raw JSON:", jsonString)
                        }
                        #endif
                        
                        let serviceError = try JSONDecoder().decode(ServiceException.self, from: data)
                        
                        // Se for erro 5xx e ainda houver tentativas, faz retry
                        if httpResponse.statusCode >= 500 && attempt < configuration.retryCount {
                            try await Task.sleep(nanoseconds: UInt64(pow(2.0, Double(attempt)) * 1_000_000_000))
                            return try await performRequest(attempt: attempt + 1)
                        }
                        
                        throw NetworkError.serviceException(serviceError)
                    } catch let decodingError as DecodingError {
                        // Se não conseguir decodificar o erro do serviço
                        throw NetworkError.decodingError(decodingError.localizedDescription)
                    }
                default:
                    throw NetworkError.invalidResponse
                }
            } catch let error as NetworkError {
                throw error
            } catch {
                if attempt < configuration.retryCount {
                    try await Task.sleep(nanoseconds: UInt64(pow(2.0, Double(attempt)) * 1_000_000_000))
                    return try await performRequest(attempt: attempt + 1)
                }
                throw NetworkError.connectionError(error.localizedDescription)
            }
        }
        
        return try await performRequest(attempt: 0)
    }
    
    private static func interceptRequest(_ request: inout URLRequest) {
        guard let session = Manager.Supabase.supabaseClient.auth.currentSession else { return }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(session.accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("json", forHTTPHeaderField: "X-Requested-With")
        request.setValue("application/json", forHTTPHeaderField: "Accept-Encoding")
        
    }
    
    // Custom Network Errors
    enum NetworkError: LocalizedError {
        case invalidResponse
        case serviceException(ServiceException)
        case connectionError(String)
        case decodingError(String)
        
        var errorDescription: String? {
            switch self {
            case .invalidResponse:
                return "Invalid server response"
            case .serviceException(let error):
                return error.detail
            case .connectionError(let error):
                return "Connection error: \(error)"
            case .decodingError(let error):
                return "Decoding error: \(error)"
            }
        }
    }

    
    struct ServiceException: Codable {
        
        let brief: String
        let cause: String
        let code: Int
        let detail: String
        let name: String
    }
}


extension Manager.Network: TestDependencyKey {
    public static let testValue = Self(
        get: { _ in
            return Data("Test GET data".utf8)
        },
        post: { _, _ in
            return Data("Test POST data".utf8)
        },
        put: { _, _ in
            return Data("Test PUT data".utf8)
        },
        delete: { _ in
            return Data("Test DELETE data".utf8)
        }
    )
}
