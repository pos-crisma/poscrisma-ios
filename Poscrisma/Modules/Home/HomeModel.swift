//
//  HomeViewController.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 11/09/2024.
//

import UIKit

extension Home {
    struct Model { }

    struct CategoryTab: Identifiable {
        private(set) var id: Tab
        var size: CGSize = .zero
        var minX: CGFloat = .zero

        enum Tab: String, CaseIterable {
            case research = "Research"
            case development = "Development"
            case analytics = "Analytics"
            case audience = "Audience"
            case content = "Content"
            case settings = "Settings"
            case help = "Help"
        }
    }
}
