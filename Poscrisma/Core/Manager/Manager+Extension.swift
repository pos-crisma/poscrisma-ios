//
//  Dependency+Extension.swift
//  GetUpCore
//
//  Created by Rodrigo Souza on 07/09/24.
//

import Dependencies

extension DependencyValues {
    var storeManager: Manager.Store {
        get { self[Manager.Store.self] }
        set { self[Manager.Store.self] = newValue }
    }
    
    var userDefaults: Manager.UserDefaultsClient {
        get { self[Manager.UserDefaultsClient.self] }
        set { self[Manager.UserDefaultsClient.self] = newValue }
    }
    
    var analytics: Manager.Analitycs {
        get { self[Manager.Analitycs.self] }
        set { self[Manager.Analitycs.self] = newValue }
    }
    
    var firebaseCore: Manager.Firebase {
        get { self[Manager.Firebase.self] }
        set { self[Manager.Firebase.self] = newValue }
    }
    
    var supabaseClient: Manager.Supabase {
        get { self[Manager.Supabase.self] }
        set { self[Manager.Supabase.self] = newValue }
    }
    
    var network: Manager.Network {
        get { self[Manager.Network.self] }
        set { self[Manager.Network.self] = newValue }
    }
}

enum Manager { }
