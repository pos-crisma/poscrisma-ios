//
//  CampingController.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 18/10/2024.
//

import UIKit

extension Camping {
    @Observable
    class Controller: Identifiable { 
        var tile: Login.TileData
        
        init(tile: Login.TileData) {
            self.tile = tile
        }
    }
}
