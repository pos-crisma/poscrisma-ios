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
    final class ViewController: CollectionViewController, UIScrollViewDelegate, UICollectionViewDelegate {
        
        @UIBinding private var model: Controller
        
        
        private lazy var bottomBarInstaller = BottomBarInstaller(viewController: self, bars: bars)
        
        private enum SectionID {
            case header
            case input
            case block
        }
     
        init(model: Controller) {
            self.model = model
            super.init(layout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
                switch sectionIndex {
                case 0: return .list(spacing: 16, contentInsets: .init(top: 0, leading: 16, bottom: 16, trailing: 16))
                case 1: return .list(spacing: 32, contentInsets: .init(top: 0, leading: 16, bottom: 0, trailing: 16))
                case 2: return .list(spacing: 4, contentInsets: .init(top: 16, leading: 16, bottom: 0, trailing: 16))
                default: return .list()
                }
            })
        }
        
        // MARK: - Properties
        
        
        
        // MARK: - UI actions
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            bottomBarInstaller.install()
            
            collectionView.contentInsetAdjustmentBehavior = .never
            collectionView.showsVerticalScrollIndicator = false
            collectionView.scrollDelegate = self
            
            observe { [weak self] in
                guard let self else { return }
                setSections(sections, animated: false)
            }
        }
        
        
        @SectionModelBuilder private var sections: [SectionModel] {
            
            // Details Section
            SectionModel(dataID: SectionID.header) {
                
                Row.TextRow.itemModel(
                    dataID: "title",
                    content: .init(title: String(localized: "onboarding.title")),
                    style: .title(.onboardingText)
                )
                
                Row.TextRow.itemModel(
                    dataID: "info.1",
                    content: .init(title: String(localized: "onboarding.label.info.1")),
                    style: .subtitle(.onboardingText)
                )

            }

            SectionModel(dataID: SectionID.input) {
                Row.TextField.itemModel(
                    dataID: "input",
                    content: .init(
                        text: $model.text,
                        isTextFocused: $model.isFocus,
                        placeHolder: String(localized: "onboarding.input.placeholder")
                    ),
                    style: .init(
                        hasIcon: true,
                        icon: "info.circle.fill",
                        backgroundColor: .gray.withAlphaComponent(0.1),
                        borderColor: .onboardingInput,
                        shadowColor: .onboardingInput,
                        shadowOffset: .init(x: 0, y: 0),
                        borderWidth: 1
                    )
                )
            }

            SectionModel(dataID: SectionID.block) {
                Row.TextRow.itemModel(
                    dataID: "info.2",
                    content: .init(title: String(localized: "onboarding.label.info.2")),
                    style: .footnote(.onboardingText)
                )
                
                Row.TextRow.itemModel(
                    dataID: "info.3",
                    content: .init(title: String(localized: "onboarding.label.info.3")),
                    style: .footnote(.onboardingText)
                )
            }
        }
        
        
        @BarModelBuilder private var bars: [BarModeling] {
            Row.ButtonRow.barModel(
                content: .init(title: "Continuar"),
                behaviors: .init(didTap: {
                    dump("Tapped")
                }),
                style: .primary(0)
            )
        }
    }
}

