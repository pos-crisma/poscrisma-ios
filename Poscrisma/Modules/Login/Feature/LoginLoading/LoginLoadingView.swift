//
//  LoginLoadingView.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 20/10/2024.
//

import SwiftUI
import Epoxy
import UIKit
import UIKitNavigation
import Lottie

extension LoginLoading {
    final class ViewController: UIViewController {
        
        @UIBinding private var model: Controller
        
        private lazy var loadingView: LottieAnimationView = {
            let animationView = LottieAnimationView(name: "loading_person_up_steps.json.json")
            animationView.loopMode = .loop
            return animationView
        }()
        
        private lazy var label: UILabel = {
            let label = UILabel()
            label.text = "Carregando suas informações"
            label.textColor = .black
            label.textAlignment = .center
            return label
        }()
        
        private lazy var stack: UIStackView = {
            let stack = UIStackView()
            stack.addArrangedSubview(loadingView)
            stack.addArrangedSubview(label)
            
            stack.spacing = 16
            stack.axis = .vertical
            
            loadingView.snp.makeConstraints { make in
                make.height.equalTo(300)
            }
            return stack
        }()
        
        
        init(model: Controller) {
            self.model = model
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .loginLoadingBackend
            
            view.addSubview(stack)
            
            stack.snp.makeConstraints { make in
                make.centerX.centerY.equalToSuperview()
            }
            
            loadingView.play()
        }
    }
}

#Preview {    
    UIViewControllerRepresenting {
        LoginLoading.ViewController(model: .init())
    }
}


