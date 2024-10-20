//
//  Manager+Supabase.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 19/10/24.
//

import Dependencies
import AuthenticationServices
import Supabase
import CustomDump

extension Manager {
    struct Supabase {
        static let url = "https://vfdofmtybnkocmhxedme.supabase.co"
        static let key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZmZG9mbXR5Ym5rb2NtaHhlZG1lIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjY3NzQzOTgsImV4cCI6MjA0MjM1MDM5OH0.zJMvmMCi2NGr49SdHtH_FoIxHsHxzL003jUZGOKHG5M"
        
        static let supabaseClient = SupabaseClient(supabaseURL: URL(string: url)!, supabaseKey: key)
        
        public var signInApple: @Sendable (String) async throws -> Session
        public var refreshToken: @Sendable (String) async throws -> Session
        public var getUser: @Sendable () async throws -> User?
        public var logout: @Sendable () async throws -> Void
        public var getAccessToken: @Sendable () async throws -> Session?
        
        enum SupabaseClientError: Error {
            case apple(String)
        }
    }
}

extension Manager.Supabase: DependencyKey {
    public static let liveValue = Self(
        signInApple: { idToken in
            do {
                let content = try await supabaseClient.auth.signInWithIdToken(credentials: .init(provider: .apple, idToken: idToken))
                
                customDump(content)
                
                return content
                
            } catch let error {
                throw SupabaseClientError.apple(error.localizedDescription)
            }
        }, refreshToken: { token in
            let content = try await supabaseClient.auth.refreshSession()
            
            customDump(content)
            
            return content
        }, getUser: {
            let user = supabaseClient.auth.currentUser

            customDump(user)
            
            return user
        }, logout: {
            try await supabaseClient.auth.signOut()
        }, getAccessToken: {
            return supabaseClient.auth.currentSession
        }
    )
}

extension Manager.Supabase: TestDependencyKey {
    public static let previewValue = Self.noop
    
    public static let testValue = Self(
        signInApple: unimplemented(placeholder: .init(accessToken: "", tokenType: "", expiresIn: .pi, expiresAt: .pi, refreshToken: "", user: .init(id: .init(), appMetadata: [:], userMetadata: [:], aud: "", createdAt: .now, updatedAt: .now))),
        refreshToken: unimplemented(placeholder: .init(accessToken: "", tokenType: "", expiresIn: .pi, expiresAt: .pi, refreshToken: "", user: .init(id: .init(), appMetadata: [:], userMetadata: [:], aud: "", createdAt: .now, updatedAt: .now))),
        getUser: unimplemented(placeholder: .init(id: .init(), appMetadata: [:], userMetadata: [:], aud: "", createdAt: .now, updatedAt: .now)),
        logout: unimplemented(placeholder: ()),
        getAccessToken: unimplemented(placeholder: nil)
    )
}

extension Manager.Supabase {
    static let noop = Self(
        signInApple: { _ in
            .init(accessToken: "", tokenType: "", expiresIn: .pi, expiresAt: .pi, refreshToken: "", user: .init(id: .init(), appMetadata: [:], userMetadata: [:], aud: "", createdAt: .now, updatedAt: .now))
        }, refreshToken: {_ in
            .init(accessToken: "", tokenType: "", expiresIn: .pi, expiresAt: .pi, refreshToken: "", user: .init(id: .init(), appMetadata: [:], userMetadata: [:], aud: "", createdAt: .now, updatedAt: .now))
        }, getUser: {
            .init(id: .init(), appMetadata: [:], userMetadata: [:], aud: "", createdAt: .now, updatedAt: .now)
        }, logout: { }, getAccessToken: { nil }
        
    )
}