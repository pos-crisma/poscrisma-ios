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
        
        lazy var icon: Style.ScaleButton = {
            let icon = UIImage(systemName: "xmark.circle.fill")
            let imageView = UIImageView(image: icon)
            imageView.tintColor = .white
            
            let button = Style.ScaleButton()
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
        
        private var headerImageView: ImageRow?
        private let headerHeight: CGFloat = 300 // Altura padrão do header
        private let maxHeaderHeight: CGFloat = 600 // Altura máxima do header durante o stretch
        
        init(controller: Controller) {
            self.controller = controller
            super.init(layout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
                switch sectionIndex {
                case 0: return .stretchyHeader
                default: return .list
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
                
                TextRow.itemModel(
                    dataID: "title",
                    content: .init(title: "Dreamy A-Frame Cabin in the Woods"),
                    style: .title)
                TextRow.itemModel(
                    dataID: "location",
                    content: .init(title: "Idyllwild-Pine Cove, California,\nUnited States"),
                    style: .subtitle)
            }
            .supplementaryItems(ofKind: UICollectionView.elementKindSectionHeader, [
                ImageRow.supplementaryItemModel(
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
                IconTextRow.itemModel(
                    dataID: "guests",
                    content: .init(icon: "person.2.fill", text: "5 guests"))
                IconTextRow.itemModel(
                    dataID: "bedrooms",
                    content: .init(icon: "bed.double.fill", text: "2 bedrooms • 3 beds"))
                IconTextRow.itemModel(
                    dataID: "bath",
                    content: .init(icon: "shower.fill", text: "1 bath"))
            }
            .compositionalLayoutSection(.list)
            
            // Amenities Section
            SectionModel(dataID: SectionID.amenities) {
                TextRow.itemModel(
                    dataID: "amenitiesTitle",
                    content: .init(title: "Amenities"),
                    style: .sectionTitle)
                IconTextRow.itemModel(
                    dataID: "entireHome",
                    content: .init(icon: "house.fill", text: "Entire home"))
                IconTextRow.itemModel(
                    dataID: "enhancedClean",
                    content: .init(icon: "sparkles", text: "Enhanced Clean"))
            }
            .compositionalLayoutSection(.list)
            
            // Price Section
            SectionModel(dataID: SectionID.price) {
                ButtonRow.itemModel(
                    dataID: "checkAvailability",
                    content: .init(title: "Check availability"),
                    style: .primary)
                .didSelect { _ in
                    print("Check availability tapped")
                }
            }
            .compositionalLayoutSection(.list)
        }
        
        @objc private func onClose() {
            Manager.Haptic.shared.playHaptic(for: .impact(.medium))
            controller.onClose()
        }
    }
    
    // MARK: - Custom Row Types
    
    final class ImageRow: UIView, EpoxyableView {
        private let imageView = UIImageView()
        
        private var heightConstraint: NSLayoutConstraint?
        
        enum Style {
            case large
        }
        
        init(style: Style) {
            super.init(frame: .zero)
            setupImageView(style: style)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupImageView(style: Style) {
            addSubview(imageView)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            
            imageView.snp.makeConstraints { make in
                make.top.leading.trailing.bottom.equalToSuperview()
            }
        }
        
        struct Content: Equatable {
            var imageName: String
        }
        
        func setContent(_ content: Content, animated: Bool) {
            imageView.image = UIImage(named: content.imageName)
        }
    }
    
    
    final class TextRow: UILabel, EpoxyableView {
        enum Style {
            case title, subtitle, sectionTitle
        }
        
        init(style: Style) {
            super.init(frame: .zero)
            setupLabel(style: style)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupLabel(style: Style) {
            translatesAutoresizingMaskIntoConstraints = false
            numberOfLines = 0
            
            switch style {
            case .title:
                font = UIFont.systemFont(ofSize: 24, weight: .bold)
                textColor = .white
            case .subtitle:
                font = UIFont.systemFont(ofSize: 16)
                textColor = .lightGray
            case .sectionTitle:
                font = UIFont.systemFont(ofSize: 20, weight: .semibold)
                textColor = .white
            }
        }
        
        struct Content: Equatable {
            var title: String
        }
        
        func setContent(_ content: Content, animated: Bool) {
            text = content.title
        }
    }
    
    final class IconTextRow: UIView, EpoxyableView {
        private let iconImageView = UIImageView()
        private let label = UILabel()
        
        init() {
            super.init(frame: .zero)
            setupViews()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupViews() {
            addSubview(iconImageView)
            addSubview(label)
            
            
            iconImageView.tintColor = .systemGray
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 16)
            
            iconImageView.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                make.centerY.equalToSuperview()
                make.size.equalTo(CGSize(width: 24, height: 24))
            }

            label.snp.makeConstraints { make in
                make.leading.equalTo(iconImageView.snp.trailing).offset(16)
                make.trailing.equalToSuperview()
                make.centerY.equalToSuperview()
            }

            self.snp.makeConstraints { make in
                make.height.equalTo(44)
            }
            
        }
        
        struct Content: Equatable {
            var icon: String
            var text: String
        }
        
        func setContent(_ content: Content, animated: Bool) {
            iconImageView.image = UIImage(systemName: content.icon)
            label.text = content.text
        }
    }
    
    final class ButtonRow: UIButton, EpoxyableView {
        enum Style {
            case primary, secondary
        }
        
        init(style: Style) {
            super.init(frame: .zero)
            setupButton(style: style)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupButton(style: Style) {
            self.snp.makeConstraints { make in
                make.height.equalTo(50)
            }
            
            switch style {
            case .primary:
                backgroundColor = .systemPink
                setTitleColor(.white, for: .normal)
            case .secondary:
                backgroundColor = .systemGray5
                setTitleColor(.black, for: .normal)
            }
            
            layer.cornerRadius = 8
            titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        }
        
        struct Content: Equatable {
            var title: String
        }
        
        func setContent(_ content: Content, animated: Bool) {
            setTitle(content.title, for: .normal)
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
    
    static var list: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(44))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        
        return section
    }
}
