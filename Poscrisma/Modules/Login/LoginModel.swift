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
        0: .init(title: "Acampamento 2013", location: "123"),
        1: .init(title: "Acampamento 2014", location: "123"),
        2: .init(title: "Acampamento 2015", location: "123"),
        3: .init(title: "Acampamento 2016", location: "123"),
        4: .init(title: "Acampamento 2017", location: "123"),
        5: .init(title: "Acampamento 2018", location: "123"),
        6: .init(title: "Acampamento 2019", location: "123"),
        7: .init(title: "Acampamento 2020", location: "123"),
        8: .init(title: "Acampamento 2021", location: "123"),
        9: .init(title: "Acampamento 2022", location: "123"),
        10: .init(title: "Acampamento 2023", location: "123"),
        11: .init(title: "Acampamento 2024", location: "123")
    ]
}
