//
//  Login+Components.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 17/10/24.
//

import Foundation
import SpriteKit
import SwiftUI

extension Login {
    
    struct BackgroundView: View {
        @State private var viewModel: BackgroundViewModel
        let handler: (Int) -> Void
        
        init(tiles: [Int: TileData], handler: @escaping (Int) -> Void) {
            self._viewModel = State(initialValue: BackgroundViewModel(tiles: tiles))
            self.handler = handler
        }
        
        var body: some View {
            GeometryReader { geometry in
                ZStack {
                    if let scene = viewModel.scene {
                        SpriteView(scene: scene)
                            .edgesIgnoringSafeArea(.all)
                    }
                    
                    ForEach(0..<viewModel.tilesState.count, id: \.self) { id in
                        if let tile = viewModel.tiles[id] {
                            TileWrapper(
                                id: id,
                                config: viewModel.tilesState.getConfig(id),
                                geometrySize: geometry.size,
                                content: { _ in
                                    TileView(
                                        data: tile,
                                        rotation: Angle(radians: Double(viewModel.tilesState.getConfig(id).angle))
                                    )
                                    .onTapGesture {
                                        handler(id)
                                    }
                                },
                                onDragChanged: { newPosition, rotation in
                                    viewModel.scene?.updateTilePosition(id: id, position: newPosition, rotation: rotation)
                                },
                                onDragEnded: { finalPosition, velocity, angularVelocity in
                                    viewModel.scene?.endTileDrag(id: id, position: finalPosition, velocity: velocity, angularVelocity: angularVelocity)
                                }
                            )
                            .allowsHitTesting(true)
                        }
                    }
                }
                .onAppear {
                    viewModel.initializeScene(size: geometry.size)
                    viewModel.initializeTiles(geometrySize: geometry.size)
                }
            }
        }
    }
    
    @Observable
    class BackgroundViewModel {
        var tilesState: TilesState
        var scene: BackgroundSimulation?
        var tiles: [Int: TileData]
        
        init(tiles: [Int: TileData]) {
            self.tiles = tiles
            self.tilesState = TilesState()
        }
        
        func initializeScene(size: CGSize) {
            if scene == nil {
                scene = BackgroundSimulation(tilesState: tilesState, size: size)
            }
        }
        
        func initializeTiles(geometrySize: CGSize) {
            guard tilesState.count == 0 else { return }
            
            for i in 0..<tiles.count {
                let config = TileConfig(
                    position: CGPoint(x: CGFloat.random(in: 0...geometrySize.width),
                                      y: CGFloat.random(in: 0...geometrySize.height)),
                    size: CGSize(width: 300, height: 50),
                    angle: CGFloat.random(in: 0...CGFloat.pi * 2)
                )
                tilesState.setConfig(id: i, config: config)
            }
            tilesState.setReady()
        }
    }

    struct TileWrapper<Content: View>: View {
        let id: Int
        let config: TileConfig
        let geometrySize: CGSize
        let content: (CGFloat) -> Content
        let onDragChanged: (CGPoint, CGFloat) -> Void
        let onDragEnded: (CGPoint, CGVector, CGFloat) -> Void
        
        @State private var dragOffset: CGSize = .zero
        @State private var isDragging = false
        @State private var lastDragPosition: CGPoint?
        @State private var angularVelocity: CGFloat = 0
        @State private var currentRotation: CGFloat
        @State private var dragAnchor: CGPoint = .zero
        
        init(id: Int, config: TileConfig, geometrySize: CGSize, content: @escaping (CGFloat) -> Content, onDragChanged: @escaping (CGPoint, CGFloat) -> Void, onDragEnded: @escaping (CGPoint, CGVector, CGFloat) -> Void) {
            self.id = id
            self.config = config
            self.geometrySize = geometrySize
            self.content = content
            self.onDragChanged = onDragChanged
            self.onDragEnded = onDragEnded
            self._currentRotation = State(initialValue: config.angle)
        }
        
        var body: some View {
            let dragGesture = DragGesture(minimumDistance: 0, coordinateSpace: .global)
                .onChanged { value in
                    if !isDragging {
                        isDragging = true
                        let touchPoint = value.startLocation
                        dragAnchor = CGPoint(
                            x: touchPoint.x - config.position.x,
                            y: touchPoint.y - (geometrySize.height - config.position.y)
                        )
                        Manager.Haptic.shared.playHaptic(for: .impact(.soft))
                    }
                    
                    let currentPosition = value.location
                    let newPosition = CGPoint(
                        x: currentPosition.x - dragAnchor.x,
                        y: geometrySize.height - (currentPosition.y - dragAnchor.y)
                    )
                    
                    if let lastPosition = lastDragPosition {
                        let dx = currentPosition.x - lastPosition.x
                        let dy = currentPosition.y - lastPosition.y
                        let distance = sqrt(dx*dx + dy*dy)
                        
                        if distance > 0 {
                            let dragAngle = atan2(dy, dx)
                            let rotationDelta = calculateRotationDelta(dragAngle: dragAngle, distance: distance)
                            currentRotation = (currentRotation + rotationDelta).truncatingRemainder(dividingBy: .pi * 2)
                            angularVelocity = rotationDelta / 0.016 // Assuming 60 FPS
                        }
                    }
                    
                    dragOffset = CGSize(
                        width: newPosition.x - config.position.x,
                        height: newPosition.y - config.position.y
                    )
                    onDragChanged(newPosition, currentRotation)
                    lastDragPosition = currentPosition
                }
                .onEnded { value in
                    isDragging = false
                    let finalPosition = CGPoint(
                        x: value.location.x - dragAnchor.x,
                        y: geometrySize.height - (value.location.y - dragAnchor.y)
                    )
                    let velocity = CGVector(
                        dx: value.predictedEndLocation.x - value.location.x,
                        dy: -(value.predictedEndLocation.y - value.location.y)
                    )
                    onDragEnded(finalPosition, velocity, angularVelocity)
                    lastDragPosition = nil
                    angularVelocity = 0
                    dragOffset = .zero
                }
            
            return GeometryReader { proxy in
                content(currentRotation)
                    .frame(width: config.size.width, height: config.size.height)
                    .position(x: proxy.size.width / 2, y: proxy.size.height / 2)
                    .rotationEffect(Angle(radians: Double(currentRotation)))
                    .offset(x: isDragging ? dragOffset.width : 0,
                            y: isDragging ? dragOffset.height : 0)
                    .gesture(dragGesture)
            }
            .frame(width: config.size.width, height: config.size.height)
            .position(convertPosition(config.position, in: geometrySize))
        }
        
        private func convertPosition(_ position: CGPoint, in size: CGSize) -> CGPoint {
            return CGPoint(x: position.x, y: size.height - position.y)
        }
        
        private func calculateRotationDelta(dragAngle: CGFloat, distance: CGFloat) -> CGFloat {
            let sensitivity: CGFloat = 0.005 // Reduced sensitivity even further
            let rotationFactor = distance * sensitivity
            let angleDifference = (dragAngle - currentRotation).truncatingRemainder(dividingBy: .pi * 2)
            let shortestAngle = (angleDifference + .pi).truncatingRemainder(dividingBy: .pi * 2) - .pi
            return shortestAngle * rotationFactor
        }
    }

    enum DragState {
        case inactive
        case dragging(translation: CGSize)
        
        var translation: CGSize {
            switch self {
            case .inactive:
                return .zero
            case .dragging(let translation):
                return translation
            }
        }
    }


    @Observable
    class BackgroundSimulation: SKScene, ObservableObject {
        static let zoom: CGFloat = 5
        
        private let tilesState: TilesState
        private var bodies: [Int: SKPhysicsBody] = [:]
        private var sprites: [Int: SKSpriteNode] = [:]
        private var isDragging: [Int: Bool] = [:]

        
        init(tilesState: TilesState, size: CGSize) {
            self.tilesState = tilesState
            super.init(size: size)
            self.scaleMode = .aspectFit
            self.physicsWorld.gravity = .zero
            createBoundaries()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func didMove(to view: SKView) {
            backgroundColor = .white
            createBoundaries()
        }
        
        override func update(_ currentTime: TimeInterval) {
            super.update(currentTime)
            
            guard tilesState.isReady else { return }
            
            if bodies.isEmpty {
                for id in 0..<tilesState.count {
                    createTileBody(id: id, config: tilesState.getConfig(id))
                }
            } else {
                for (id, sprite) in sprites {
                    if isDragging[id] != true {
                        let position = sprite.position
                        let angle = sprite.zRotation
                        
                        let newPosition = CGPoint(
                            x: position.x - sprite.size.width / 2,
                            y: position.y - sprite.size.height / 2
                        )
                        
                        let config = tilesState.getConfig(id).copyWith(position: newPosition, angle: angle)
                        tilesState.setConfig(id: id, config: config)
                    }
                    
                    // Apply damping to angular velocity
                    if let body = sprite.physicsBody {
                        body.angularVelocity *= 0.33
                    }
                }
            }
        }
        
        private func createBoundaries() {
            let visibleRect = self.frame
            let translation: CGFloat = 1.0
            
            let topLeft = CGPoint(x: visibleRect.minX - translation, y: visibleRect.minY - translation)
            let topRight = CGPoint(x: visibleRect.maxX + translation, y: visibleRect.minY - translation)
            let bottomRight = CGPoint(x: visibleRect.maxX + translation, y: visibleRect.maxY + translation)
            let bottomLeft = CGPoint(x: visibleRect.minX - translation, y: visibleRect.maxY + translation)
            
            createBoundary(start: topLeft, end: topRight)
            createBoundary(start: topRight, end: bottomRight)
            createBoundary(start: bottomRight, end: bottomLeft)
            createBoundary(start: bottomLeft, end: topLeft)
        }
        
        private func createBoundary(start: CGPoint, end: CGPoint) {
            let node = SKNode()
            let physicsBody = SKPhysicsBody(edgeFrom: start, to: end)
            physicsBody.friction = 0.3
            physicsBody.restitution = 0.5
            physicsBody.isDynamic = false
            node.physicsBody = physicsBody
            addChild(node)
        }
        
        private func createTileBody(id: Int, config: TileConfig) {
            let size = CGSize(
                width: config.size.width / BackgroundSimulation.zoom,
                height: config.size.height / BackgroundSimulation.zoom
            )
            let sprite = SKSpriteNode(color: .clear, size: size)
            sprite.position = CGPoint(
                x: config.position.x + size.width / 2,
                y: config.position.y + size.height / 2
            )
            sprite.zRotation = config.angle
            
            let body = SKPhysicsBody(rectangleOf: size)
            body.restitution = 0.2
            body.friction = 0.5
            body.density = 1000
            body.angularDamping = 0.5
            body.linearDamping = 0.2
            body.allowsRotation = true
            body.affectedByGravity = false
            body.mass = 1.0
            body.collisionBitMask = 0xFFFFFFFF
            body.contactTestBitMask = 0xFFFFFFFF
            
            sprite.physicsBody = body
            addChild(sprite)
            
            bodies[id] = body
            sprites[id] = sprite
        }
        
        
     
        func updateTilePosition(id: Int, position: CGPoint, rotation: CGFloat) {
            if let sprite = sprites[id] {
                let boundedPosition = boundPosition(position, for: sprite)
                sprite.position = CGPoint(
                    x: boundedPosition.x + sprite.size.width / 2,
                    y: boundedPosition.y + sprite.size.height / 2
                )
                sprite.zRotation = rotation
                sprite.physicsBody?.velocity = .zero
                sprite.physicsBody?.angularVelocity = 0
                
                let config = tilesState.getConfig(id)
                let newConfig = config.copyWith(position: boundedPosition, angle: rotation)
                tilesState.setConfig(id: id, config: newConfig)
                
                isDragging[id] = true
            }
        }
        
        func endTileDrag(id: Int, position: CGPoint, velocity: CGVector, angularVelocity: CGFloat) {
            if let sprite = sprites[id], let body = sprite.physicsBody {
                let boundedPosition = boundPosition(position, for: sprite)
                sprite.position = CGPoint(
                    x: boundedPosition.x + sprite.size.width / 2,
                    y: boundedPosition.y + sprite.size.height / 2
                )
                body.velocity = CGVector(dx: velocity.dx, dy: velocity.dy)
                body.angularVelocity = angularVelocity
                
                let config = tilesState.getConfig(id)
                let newConfig = config.copyWith(position: boundedPosition, angle: sprite.zRotation)
                tilesState.setConfig(id: id, config: newConfig)
                
                isDragging[id] = false
            }
        }
        
        private func boundPosition(_ position: CGPoint, for sprite: SKSpriteNode) -> CGPoint {
            let halfWidth = sprite.size.width / 2
            let halfHeight = sprite.size.height / 2
            let minX = frame.minX + halfWidth
            let maxX = frame.maxX - halfWidth
            let minY = frame.minY + halfHeight
            let maxY = frame.maxY - halfHeight
            
            return CGPoint(
                x: min(max(position.x, minX), maxX),
                y: min(max(position.y, minY), maxY)
            )
        }
    }

    @Observable
    class TilesState {
        private(set) var configs: [Int: TileConfig] = [:]
        private(set) var isReady: Bool = false
        var count: Int { configs.count }
        
        func getConfig(_ id: Int) -> TileConfig {
            configs[id] ?? TileConfig(position: .zero, size: .zero, angle: 0)
        }
        
        func setConfig(id: Int, config: TileConfig) {
            configs[id] = config
        }
        
        func setReady() {
            isReady = true
        }
    }

    struct TileConfig: Equatable {
        var position: CGPoint
        var size: CGSize
        var angle: CGFloat
        
        func copyWith(position: CGPoint? = nil, size: CGSize? = nil, angle: CGFloat? = nil) -> TileConfig {
            TileConfig(
                position: position ?? self.position,
                size: size ?? self.size,
                angle: angle ?? self.angle
            )
        }
    }


    struct TileView: View {
        let data: TileData
        let rotation: Angle
        
        var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Circle()
                        .fill(Color.blue.opacity(0.2))
                        .frame(width: 30, height: 30)
                    
                    VStack(alignment: .leading) {
                        Text(data.title)
                            .font(.system(size: 16, weight: .semibold))
                            .lineLimit(1)
                            .foregroundStyle(.black)
                        
                        Text(data.location)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.2), radius: 32, x: 0, y: 0)
            }
        }
    }
}
