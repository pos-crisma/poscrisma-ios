//
//  CampingView.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 18/10/2024.
//

import Epoxy
import SwiftUI
import SwiftUINavigation

extension Camping {
    struct ViewController: View {
        
        @State private var model: Controller
        
        init(model: Controller) {
            self.model = model
        }

        var body: some View {
            Form {
                Text(model.tile.title)
            }
        }
    }
}


