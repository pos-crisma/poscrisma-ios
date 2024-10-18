//
//  HomeView.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 11/09/2024.
//

import Epoxy
import UIKit
import UIKitNavigation
import SnapKit

extension Home {
    final class ViewController: UIViewController {
        
        @UIBinding var controller: Controller
        
        init(controller: Controller) {
            self.controller = controller
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        lazy var labelTitle: UILabel = {
            let label = UILabel()
            label.text = """
            Essas mudanças garantem que seus labels respeitem a *Safe Area*, evitando que fiquem sob a barra de status, o notch (se houver) ou outros elementos da interface do sistema.
            Gostaria que eu explicasse mais algum detalhe ou fizesse alguma outra modificação?
            """
            label.numberOfLines = 0
            return label
        }()
        
        lazy var labelContent: UILabel = {
            let label = UILabel()
            label.text = """
            Essas mudanças garantem que seus labels respeitem a *Safe Area*, evitando que fiquem sob a barra de status, o notch (se houver) ou outros elementos da interface do sistema.
            Gostaria que eu explicasse mais algum detalhe ou fizesse alguma outra modificação?

            Essas mudanças garantem que seus labels respeitem a *Safe Area*, evitando que fiquem sob a barra de status, o notch (se houver) ou outros elementos da interface do sistema.
            Gostaria que eu explicasse mais algum detalhe ou fizesse alguma outra modificação?
            
            Essas mudanças garantem que seus labels respeitem a *Safe Area*, evitando que fiquem sob a barra de status, o notch (se houver) ou outros elementos da interface do sistema.
            Gostaria que eu explicasse mais algum detalhe ou fizesse alguma outra modificação?
            """
            label.numberOfLines = 0
            label.backgroundColor = .gray.withAlphaComponent(0.1)
            return label
        }()
        
        lazy var trailingContent: UIView = {
            let view = UIView()
            view.backgroundColor = .cyan
            return view
        }()
        
        lazy var buttonLogout: Style.ScaleButton = {
            let label = UILabel()
            label.text = "Logout"
            label.font = .systemFont(ofSize: 16, weight: .bold)
            label.textColor = .white
            label.textAlignment = .center
            
            let button = Style.ScaleButton()
            button.setAction(handlerLogout)
            button.setCustomContent(label)
            
            button.backgroundColor = .black
            button.layer.cornerRadius = 8

            return button
        }()

        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
            
            view.addSubview(trailingContent)
            view.addSubview(labelTitle)
            view.addSubview(labelContent)
            view.addSubview(buttonLogout)
            
            labelTitle.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                make.left.equalTo(view.snp.left).offset(16)
                make.right.equalTo(view.snp.right).offset(-16)
            }
            
            labelContent.snp.makeConstraints { make in
                make.top.equalTo(labelTitle.snp.bottom).offset(8)
                make.left.equalTo(view.snp.left).offset(16)
                make.right.equalTo(view.snp.right).offset(-16)
            }
            
            buttonLogout.snp.makeConstraints { make in
                make.top.equalTo(labelContent.snp.bottom).offset(16)
                make.left.equalTo(view.snp.left).offset(16)
                make.right.equalTo(view.snp.right).offset(-16)
                make.height.equalTo(44)
            }
            
            trailingContent.snp.makeConstraints { make in
                make.top.equalTo(view.snp.top)
                make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
                make.height.equalTo(300)
                make.width.equalTo(300)
            }
        }
        
        @objc private func handlerLogout() {
            controller.setLogout()
        }
    }
}


#Preview {
    Home.ViewController(controller: .init())
}
