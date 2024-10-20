//
//  HomeView.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 11/09/2024.
//

import Epoxy
import SwiftUI
import UIKitNavigation
import SnapKit

import SwiftUI


struct ContentView: View {
    
    @State var sheet = false
    @State var cover = false
    
    var body: some View {
        Button("Click me for sheet") {
            sheet = true
        }
        .fullScreenCover(isPresented: $cover) {
            Text("This is a full screen cover")
        }
        .sheet(isPresented: $sheet, onDismiss: {cover = true}) {
            Text("This is a sheet")
        }
    }
}

#Preview {
    ContentView()
}


extension Home {
    struct ViewController: View {
        @State var controller: Controller
        
        var body: some View {
            UIViewControllerRepresenting {
                Screen(controller: controller)
            }
            .fullScreenCover(item: $controller.destination.airbnb) { model in
                UIViewControllerRepresenting {
                    Airbnb.ViewController(controller: model)
                } 
                .ignoresSafeArea()
            }
        }
    }
    
    final class Screen: UIViewController {
        
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
            label.textColor = .black
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
            label.textColor = .black
            label.numberOfLines = 0
            label.backgroundColor = .gray.withAlphaComponent(0.1)
            return label
        }()
        
        lazy var trailingContent: UIView = {
            let view = UIView()
            view.backgroundColor = .cyan
            return view
        }()
        
        lazy var buttonPresentAirbnb: Style.ScaleButton = {
            let label = UILabel()
            label.text = "Present Airbnb"
            label.font = .systemFont(ofSize: 16, weight: .bold)
            label.textColor = .white
            label.textAlignment = .center
            
            let button = Style.ScaleButton()
            button.setAction(handlerPresentAirbnb)
            button.setCustomContent(label)
            
            button.backgroundColor = .black
            button.layer.cornerRadius = 8

            return button
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
            
            setupUI()
        }
        
        private func setupUI() {
            
            view.addSubview(trailingContent)
            view.addSubview(labelTitle)
            view.addSubview(labelContent)
            view.addSubview(buttonPresentAirbnb)
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
            
            buttonPresentAirbnb.snp.makeConstraints { make in
                make.top.equalTo(labelContent.snp.bottom).offset(16)
                make.left.equalTo(view.snp.left).offset(16)
                make.right.equalTo(view.snp.right).offset(-16)
                make.height.equalTo(54)
            }
            
            buttonLogout.snp.makeConstraints { make in
                make.top.equalTo(buttonPresentAirbnb.snp.bottom).offset(16)
                make.left.equalTo(view.snp.left).offset(16)
                make.right.equalTo(view.snp.right).offset(-16)
                make.height.equalTo(54)
            }
            
            trailingContent.snp.makeConstraints { make in
                make.top.equalTo(view.snp.top)
                make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
                make.height.equalTo(300)
                make.width.equalTo(300)
            }
        }
        
        @objc private func handlerPresentAirbnb() {
            controller.presentAirbnb()
        }
        
        @objc private func handlerLogout() {
            controller.setLogout()
        }
    }
}


#Preview {
    Home.ViewController(controller: .init())
}
