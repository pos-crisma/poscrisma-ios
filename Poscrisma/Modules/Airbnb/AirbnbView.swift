//
//  AirbnbView.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 08/09/2024.
//

import Epoxy
import UIKit
import UIKitNavigation

extension Airbnb {
    final class ViewController: CollectionViewController, UIScrollViewDelegate, UICollectionViewDelegate {
        
        @UIBindable var controller: Controller
        
        private enum SectionID {
            case header, subHeader, details, amenities, price
        }
        
        lazy var icon: AppStyle.ScaleButton = {
            let icon = UIImage(systemName: "xmark.circle.fill")
            let imageView = UIImageView(image: icon)
            imageView.tintColor = .white
            
            let button = AppStyle.ScaleButton()
            button.setAction(onClose)
            button.setCustomContent(imageView)
            
            imageView.snp.makeConstraints { make in
                make.height.width.equalTo(12)
                make.top.equalTo(button.snp.top).offset(8)
                make.bottom.equalTo(button.snp.bottom).offset(-8)
                make.trailing.equalTo(button.snp.trailing).offset(-8)
                make.leading.equalTo(button.snp.leading).offset(8)
            }
            
            button.addTarget(self, action: #selector(onClose), for: .touchUpInside)
            return button
        }()
        
        private var headerImageView: Row.Image?
        private let headerHeight: CGFloat = 300 // Altura padrão do header
        private let maxHeaderHeight: CGFloat = 600 // Altura máxima do header durante o stretch
        
        init(controller: Controller) {
            self.controller = controller
            super.init(layout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
                switch sectionIndex {
                case 0: return .stretchyHeader
                default: return .list()
                }
            })
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .systemBackground
            collectionView.backgroundColor = .systemBackground
            collectionView.contentInsetAdjustmentBehavior = .never
            collectionView.showsVerticalScrollIndicator = false
            collectionView.scrollDelegate = self
            
            view.addSubview(icon)
            
            icon.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                make.trailing.equalToSuperview().offset(-16)
            }
            
            observe { [weak self] in
                guard let self else { return }
                setSections(sections, animated: false)
            }
        }
        
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            if section == 0 {
                return CGSize(width: collectionView.bounds.width, height: headerHeight)
            }
            return .zero
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offsetY = scrollView.contentOffset.y
            
            if let header = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0)) {
                if offsetY < 0 {
                    let stretchAmount = min(-offsetY, maxHeaderHeight - headerHeight)
                    let scale = 1 + (stretchAmount / headerHeight)
                    
                    header.frame.origin.y = offsetY
                    header.frame.size.height = headerHeight + stretchAmount
                    
                    // Aplicar zoom suave à imagem do header
                    if let imageView = header.subviews.first as? UIImageView {
                        imageView.transform = CGAffineTransform(scaleX: scale, y: scale)
                    }
                } else {
                    header.frame.size.height = headerHeight
                    
                    if let imageView = header.subviews.first as? UIImageView {
                        imageView.transform = .identity
                    }
                }
            }
        }
        
        @SectionModelBuilder
        private var sections: [SectionModel] {
            // Header Section
            SectionModel(dataID: SectionID.header) {
                
                Row.TextRow.itemModel(
                    dataID: "title",
                    content: .init(title: "Dreamy A-Frame Cabin in the Woods"),
                    style: .title())
                Row.TextRow.itemModel(
                    dataID: "location",
                    content: .init(title: "Idyllwild-Pine Cove, California,\nUnited States"),
                    style: .subtitle())
            }
            .supplementaryItems(ofKind: UICollectionView.elementKindSectionHeader, [
                Row.Image.supplementaryItemModel(
                    dataID: "cabinImage",
                    content: .init(imageName: "cabin"),
                    style: .large
                )
                .willDisplay { [weak self] context in
                    self?.headerImageView = context.view
                }
            ])
            .compositionalLayoutSection(.stretchyHeader)
            
            
            // Details Section
            SectionModel(dataID: SectionID.details) {
                Row.IconText.itemModel(
                    dataID: "guests",
                    content: .init(icon: "person.2.fill", text: "5 guests"))
                Row.IconText.itemModel(
                    dataID: "bedrooms",
                    content: .init(icon: "bed.double.fill", text: "2 bedrooms • 3 beds"))
                Row.IconText.itemModel(
                    dataID: "bath",
                    content: .init(icon: "shower.fill", text: "1 bath"))
            }
            .compositionalLayoutSection(.list())
            
            // Amenities Section
            SectionModel(dataID: SectionID.amenities) {
                Row.TextRow.itemModel(
                    dataID: "amenitiesTitle",
                    content: .init(title: "Amenities"),
                    style: .sectionTitle())
                Row.IconText.itemModel(
                    dataID: "entireHome",
                    content: .init(icon: "house.fill", text: "Entire home"))
                Row.IconText.itemModel(
                    dataID: "enhancedClean",
                    content: .init(icon: "sparkles", text: "Enhanced Clean"))
            }
            .compositionalLayoutSection(.list())
            
            // Price Section
            SectionModel(dataID: SectionID.price) {
                Row.ButtonRow.itemModel(
                    dataID: "checkAvailability",
                    content: .init(title: "Check availability"),
                    style: .primary())
                .didSelect { _ in
                    print("Check availability tapped")
                }
            }
            .compositionalLayoutSection(.list())
        }
        
        @objc private func onClose() {
            Manager.Haptic.shared.playHaptic(for: .impact(.medium))
            controller.onClose()
        }
    }
}

// MARK: - Helpers

extension NSCollectionLayoutSection {
    static var stretchyHeader: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(44))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        
        // Configuração do header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(300))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        
        sectionHeader.pinToVisibleBounds = false
        sectionHeader.zIndex = -1
        
        section.boundarySupplementaryItems = [sectionHeader]
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0)
        
        
        return section
    }
    
    static func list(spacing: CGFloat = 16, contentInsets: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = contentInsets
        
        return section
    }
}
