//
//  LoginErrorView.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 20/10/2024.
//

import Epoxy
import UIKit
import SwiftUI
import UIKitNavigation

extension LoginError {
    final class ViewController: UIViewController {
        
        lazy var stack: UIStackView = {
            let stack = UIStackView()
            stack.distribution = .fill
            stack.axis = .vertical
            stack.spacing = 16
            stack.alignment = .center
            return stack
        }()
        
        lazy var labelTitle: UILabel = {
            let label = UILabel()

            label.font = .systemFont(ofSize: 26, weight: .semibold)
            label.numberOfLines = 0
            return label
        }()
        
        lazy var labelContent: UILabel = {
            let label = UILabel()

            label.font = .systemFont(ofSize: 20)
            label.numberOfLines = 0
            return label
        }()
        
        lazy var icon: AppStyle.ScaleButton = {
            let icon = UIImage(systemName: "xmark.circle.fill")
            let imageView = UIImageView(image: icon)
            imageView.tintColor = .gray
            
            let button = AppStyle.ScaleButton()
            button.setAction(onClose)
            button.setCustomContent(imageView)
            
            imageView.snp.makeConstraints { make in
                make.height.width.equalTo(16)
                make.top.equalTo(button.snp.top).offset(8)
                make.bottom.equalTo(button.snp.bottom).offset(-8)
                make.trailing.equalTo(button.snp.trailing).offset(-8)
                make.leading.equalTo(button.snp.leading).offset(8)
            }
            return button
        }()
        
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
            
            stack.addArrangedSubview(labelTitle)
            stack.addArrangedSubview(labelContent)
            
            view.addSubview(icon)
            view.addSubview(stack)
            
            icon.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
                make.trailing.equalToSuperview().offset(-16)
            }
            
            stack.snp.makeConstraints { make in
                make.centerX.centerY.equalToSuperview()
                make.leading.equalToSuperview().offset(24)
                make.trailing.equalToSuperview().offset(-24)
            }
            
            labelTitle.text = "Ooops,"
            
            observe { [weak self] in
                guard let self else { return }
                
                switch model.errorType {
                case .appleCancel:
                    labelContent.text = "Você cancelou o sua autenticação com a Apple"
                    break
                case .appleError:
                    labelContent.text = "Erro na autenticação com a Apple"
                    break
                case .appleUnknown:
                    labelContent.text = "Erro desconhecido durante a autenticação com a Apple"
                    break
                case .appleSupabase:
                    labelContent.text = "Erro para se finalizar a autenticação com a plataforma, tente novamente"
                    break
                case .googleCancel:
                    labelContent.text = "Você cancelou o sua autenticação com o Google"
                    break
                case .googleError:
                    labelContent.text = "Erro na autenticação com o Google"
                    break
                case .googleUnknown:
                    labelContent.text = "Erro desconhecido durante a autenticação com o Google"
                    break
                case .googleSupabase:
                    labelContent.text = "Erro para se finalizar a autenticação com a plataforma, tente novamente"
                    break
                case .endpoint(let error):
                    labelContent.text = "Erro para recuperar as informações do usuario. Codigo do erro: \(error)"
                    break
                case .unknown:
                    labelContent.text = "Erro desconhecido"
                    break
                }
                
            }
        }
        
        @objc private func onClose() {
            Manager.Haptic.shared.playHaptic(for: .impact(.medium))
            model.onHandler()
        }
    }
}

#Preview {
    UIViewControllerRepresenting {
        LoginError.ViewController(model: .init(errorType: .endpoint(.connectionError("Erro de conexão"))))
    }
}
