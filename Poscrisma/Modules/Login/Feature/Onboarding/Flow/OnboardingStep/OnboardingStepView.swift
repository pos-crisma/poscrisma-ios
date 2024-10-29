//
//  OnboardingStepView.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 27/10/2024.
//

import Epoxy
import UIKit
import UIKitNavigation

extension OnboardingStep {
    final class ViewController: CollectionViewController, UIScrollViewDelegate, UICollectionViewDelegate {
        @UIBinding private var model: Controller
        
        private lazy var bottomBarInstaller = BottomBarInstaller(viewController: self, bars: bars)
            
        private enum SectionID {
            case header
        }
        
        init(model: Controller) {
            self.model = model
            super.init(layout: UICollectionViewCompositionalLayout.epoxy)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
            
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
                    content: .init(title: String(localized: "onboarding.initial.title")),
                    style: .title(textColor: .onboardingText, alignment: .center)
                )
                
                Row.TextRow.itemModel(
                    dataID: "text.1",
                    content: .init(title: String(localized: "onboarding.initial.title")),
                    style: .subtitle(textColor: .onboardingText, alignment: .center)
                )
                
                Row.TextRow.itemModel(
                    dataID: "text.2",
                    content: .init(title: String(localized: "onboarding.initial.title")),
                    style: .subtitle(textColor: .onboardingText, alignment: .center)
                )
            }
            .compositionalLayoutSection(.list(contentInsets: .init(top: 100, leading: 32, bottom: 0, trailing: 32)))
        }
        
        
        @BarModelBuilder private var bars: [BarModeling] {
            Row.ButtonRow.barModel(
                dataID: "entry",
                content: .init(title: "Entrar no acampamento"),
                behaviors: .init(didTap: model.onHandlerEntryCamping),
                style: .secondary(horizontalPadding: 12, backgroundColor: .black, tintColor: .black)
            )
            .willDisplay { context in
                context.view.button.isEnabled = false
            }
            
            Row.ButtonRow.barModel(
                dataID: "create",
                content: .init(title: "Criar acampamento"),
                behaviors: .init(didTap: model.onHandlerCreateCamping),
                style: .primary(horizontalPadding: 12, backgroundColor: .black, tintColor: .white)
            )
        }
    }
}


