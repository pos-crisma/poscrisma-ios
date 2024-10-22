//
//  OnboardingView.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 22/10/2024.
//

import Epoxy
import UIKit
import UIKitNavigation

extension Onboarding {
    final class ViewController: CollectionViewController {
        
        @UIBinding private var model: Controller
            
        init(model: Controller) {
            self.model = model
            super.init(layout: UICollectionViewCompositionalLayout.list(using: .init(appearance: .grouped)))
            setSections(sections, animated: false)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
            collectionView.backgroundColor = .white
        }
        
        var sections: [SectionModel] {
            [
                SectionModel(items: items)
            ]
        }
        
        private enum DataIDs {
            case title
        }
        
        private var items: [ItemModeling] {
            [
                ItemModel<UILabel>(
                    dataID: DataIDs.title,
                    content: "This is my title",
                    setContent: { content, value in
                        content.view.text = value
                        content.view.font = .systemFont(ofSize: 24, weight: .bold)
                        content.view.textColor = .red
                    }
                ),
                ItemModel<UILabel>(
                    dataID: DataIDs.title,
                    content: "This is my title",
                    setContent: { content, value in
                        content.view.text = value
                        content.view.textColor = .red
                    }
                ),
            ]
        }
    }
}


