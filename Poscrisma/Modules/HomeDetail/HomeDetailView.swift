//
//  HomeDetailView.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 18/10/2024.
//

import Epoxy
import UIKit
import UIKitNavigation

extension HomeDetail {
    final class ViewController: UIViewController {
        
        @UIBindable var controller: Controller
        
        init(controller: Controller) {
            self.controller = controller
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


