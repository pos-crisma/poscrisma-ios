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
                Section {
                    VStack(spacing: 8) {
                        Image(systemName: "tent.fill")
                            .font(.system(size: 80))
                            .padding(.bottom, 16)
                        
                        
                        HStack(spacing: 8) {
                            Image(systemName: "laurel.leading")
                                .fontDesign(.rounded)
                                .fontWeight(.semibold)
                            Text("login.buble.app.name")
                                .fontDesign(.rounded)
                                .fontWeight(.semibold)
                            Image(systemName: "laurel.trailing")
                                .fontDesign(.rounded)
                                .fontWeight(.semibold)
                        }
                        .font(.title3)
                        Text("2024, \(model.tile.location)")
                            .font(.body.monospaced())
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.bottom, 8)
            
                Section("login.camping.section.title") {
                    Text(model.tile.title)
                    Text(model.tile.title)
                    Text(model.tile.title)
                    Text(model.tile.title)
                }
            }
        }
    }
}

#Preview {
    Camping.ViewController(model: .init(tile: Login.tileDataMock[1]!))
}
