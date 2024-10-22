//
//  LoginViewController.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 15/10/2024.
//

import UIKit

extension Login {
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
}

