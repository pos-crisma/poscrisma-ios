//
//  ApplePhotoViewController.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 08/02/2025.
//

import UIKit

extension ApplePhoto {
	struct Item: Identifiable, Hashable {
		var id: String = UUID().uuidString
		var title: String
		var image: UIImage?
		var previewImage: UIImage?
		var appeared: Bool = false
	}
}

// Extensão para fornecer dados de exemplo para Item
extension ApplePhoto.Item {
	static let sampleItems: [ApplePhoto.Item] = {
		let customTitles = [
			"Melodia de Amanhã",
			"Ritmo Vibrante",
			"Batida Urbana",
			"Harmonia Infinita",
			"Som Tranquilo",
			"Canção da Vida",
			"Nota Encantada",
			"Eco Sonoro",
			"Vibração Natural",
			"Ritmo da Alma"
		]
		return (1...10).map { i in
			let imageName = "pic-\(i)"
			let image = UIImage(named: imageName)
			return ApplePhoto.Item(title: customTitles[i - 1], image: image, previewImage: image, appeared: false)
		}
	}()
}
