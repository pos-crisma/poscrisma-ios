//
//  PanGesture.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 08/02/25.
//

import SwiftUI

struct PanGesture: UIGestureRecognizerRepresentable {
	var onChange: (Value) -> ()
	var onEnd: (Value) -> ()

	func makeUIGestureRecognizer(context: Context) -> UIPanGestureRecognizer {
		let gesture = UIPanGestureRecognizer()
		return gesture
	}

	func updateUIGestureRecognizer(_ recognizer: UIPanGestureRecognizer, context: Context) {
		
	}

	func handleUIGestureRecognizerAction(_ recognizer: UIPanGestureRecognizer, context: Context) {
		let state = recognizer.state
		let transition = recognizer.translation(in: recognizer.view).toSize()
		let velocity = recognizer.velocity(in: recognizer.view).toSize()
		let value = Value(translation: transition, velocity: velocity)

		if state == .began || state == .changed {
			onChange(value)
		} else {
			onEnd(value)
		}

	}

	struct Value {
		var translation: CGSize
		var velocity: CGSize
	}
}

