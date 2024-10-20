//
//  LoginErrorView.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 20/10/2024.
//

import Epoxy
import UIKit
import UIKitNavigation

extension LoginError {
    final class ViewController: UIViewController {
        
        @UIBinding private var model: Controller
        
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
        }
    }
}


