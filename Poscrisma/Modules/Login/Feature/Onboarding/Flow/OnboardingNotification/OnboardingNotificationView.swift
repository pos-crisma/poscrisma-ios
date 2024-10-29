//
//  OnboardingNotificationView.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 27/10/2024.
//

import Epoxy
import UIKit
import UIKitNavigation

extension OnboardingNotification {
    final class ViewController: UIViewController {
        
        @UIBinding private var model: Controller
        
        
        private lazy var bottomBarInstaller = BottomBarInstaller(viewController: self, bars: bars)
            
        init(model: Controller) {
            self.model = model
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
            
            bottomBarInstaller.install()
        }
        
        @BarModelBuilder private var bars: [BarModeling] {
            Row.ButtonRow.barModel(
                content: .init(title: "Continuar"),
                behaviors: .init(didTap: model.onHandler),
                style: .primary(horizontalPadding: 12, backgroundColor: .black, tintColor: .white)
            )
        }
    }
}


