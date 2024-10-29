//
//  OnboardingInitialView.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 27/10/2024.
//

import Epoxy
import UIKit
import UIKitNavigation
import XCTestDynamicOverlay

extension OnboardingInitial {
    final class ViewController: CollectionViewController, UIScrollViewDelegate, UICollectionViewDelegate {
        
        var onHandler: () -> Void = {
            XCTFail("OnboardingInitial.onHandler unimplemented.")
        }
        
        private lazy var bottomBarInstaller = BottomBarInstaller(viewController: self, bars: bars)
        
        private enum SectionID {
            case header
        }
     
        init(onHandler: @escaping () -> Void) {
            self.onHandler = onHandler
            super.init(layout: UICollectionViewFlowLayout())
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
                    content: .init(title: String(localized: "onboarding.initial.title")),
                    style: .title(fontSize: 28, textColor: .onboardingText, alignment: .center)
                )
                .flowLayoutItemSize(.init(width: UIScreen.main.bounds.size.width - 80, height: UIScreen.main.bounds.size.height - 120))
            }
        }
        
        
        @BarModelBuilder private var bars: [BarModeling] {
            Row.ButtonRow.barModel(
                content: .init(title: "Continuar"),
                behaviors: .init(didTap: onHandler),
                style: .primary(horizontalPadding: 12, backgroundColor: .black, tintColor: .white)
            )
        }
    }
}


