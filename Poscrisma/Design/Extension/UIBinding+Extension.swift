//
//  UIBinding+Extension.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 25/10/24.
//

import SwiftNavigation

extension UIBinding: Equatable where Value: Equatable {
    public static func == (lhs: SwiftNavigation.UIBinding<Value>, rhs: SwiftNavigation.UIBinding<Value>) -> Bool {
        return lhs.wrappedValue == rhs.wrappedValue
    }
}
