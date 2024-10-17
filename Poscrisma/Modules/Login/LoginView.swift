//
//  LoginView.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 15/10/2024.
//
//
//import Epoxy
//import UIKit
//import UIKitNavigation
//
//extension Login {
//    final class ViewController: UIViewController {
//
//        override func viewDidLoad() {
//            super.viewDidLoad()
//            view.backgroundColor = .white
//        }
//    }
//}
//
// MARK: - OLD
//
//import SwiftUI
//import SpriteKit
//
//
//#Preview {
//    BackgroundView()
//}
//
//struct BackgroundView: View {
//    @StateObject private var tilesState = TilesState()
//    @State private var scene: BackgroundSimulation?
//    
//    
//    private func convertPosition(_ position: CGPoint, in size: CGSize) -> CGPoint {
//        return CGPoint(x: position.x, y: size.height - position.y)
//    }
//    
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack {
//                SpriteView(scene: scene ?? BackgroundSimulation(tilesState: tilesState, size: geometry.size))
//                    .edgesIgnoringSafeArea(.all)
//                
//                ForEach(0..<tilesState.count, id: \.self) { id in
//                    
//                    TileWrapper(config: tilesState.getConfig(id), geometrySize: geometry.size) {
//                        TileView(data: TileData(title: "Tile \(id)", location: "Location \(id)"))
//                            .onTapGesture {
//                                dump("onTap")
//                            }
//                    }
//                    .allowsHitTesting(false) // Ignore user interactions
//                    
//                }
//            }
//            .onAppear {
//                if scene == nil {
//                    scene = BackgroundSimulation(tilesState: tilesState, size: geometry.size)
//                }
//                
//                // Initialize tiles (você pode ajustar isso conforme necessário)
//                for i in 0..<10 {
//                    let config = TileConfig(
//                        position: CGPoint(x: CGFloat.random(in: 0...geometry.size.width),
//                                          y: CGFloat.random(in: 0...geometry.size.height)),
//                        size: CGSize(width: 200, height: 50),
//                        angle: CGFloat.random(in: 0...CGFloat.pi * 2)
//                    )
//                    tilesState.setConfig(id: i, config: config)
//                }
//                tilesState.setReady()
//            }
//        }
//    }
//}
//
//
//struct TileWrapper<Content: View>: View {
//    let config: TileConfig
//    let geometrySize: CGSize
//    let content: () -> Content
//    
//    var body: some View {
//        GeometryReader { proxy in
//            content()
//                .frame(width: config.size.width, height: config.size.height)
//                .position(x: proxy.size.width / 2, y: proxy.size.height / 2)
//                .rotationEffect(Angle(radians: -Double(config.angle)), anchor: .center)
//        }
//        .frame(width: config.size.width, height: config.size.height)
//        .position(convertPosition(config.position, in: geometrySize))
//    }
//    
//    private func convertPosition(_ position: CGPoint, in size: CGSize) -> CGPoint {
//        return CGPoint(x: position.x, y: size.height - position.y)
//    }
//}
//
//
//// MARK: - BackgroundSimulation
//
//class BackgroundSimulation: SKScene, ObservableObject {
//    static let zoom: CGFloat = 5
//
//    private let tilesState: TilesState
//    private var bodies: [Int: SKPhysicsBody] = [:]
//    private var sprites: [Int: SKSpriteNode] = [:]
//    private var touchedNode: SKSpriteNode?
//    private var initialTouchPosition: CGPoint?
//    private var lastTouchPosition: CGPoint?
//    private var touchOffset: CGPoint?
//    private var touchStartTime: TimeInterval?
//    private var lastUpdateTime: TimeInterval?
//    
//    // Parâmetros para detecção de rotação
//    private let rotationThreshold: CGFloat = 0.001
//    private let minMovementForRotation: CGFloat = 1
//    
//    
//    init(tilesState: TilesState, size: CGSize) {
//        self.tilesState = tilesState
//        super.init(size: size)
//        self.scaleMode = .aspectFit
//        self.physicsWorld.gravity = .zero
//        createBoundaries()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func didMove(to view: SKView) {
//        backgroundColor = .white
//        createBoundaries()
//    }
//    
//    override func update(_ currentTime: TimeInterval) {
//        super.update(currentTime)
//        
//        guard tilesState.isReady else { return }
//        
//        if bodies.isEmpty {
//            for id in 0..<tilesState.count {
//                createTileBody(id: id, config: tilesState.getConfig(id))
//            }
//        } else {
//            for (id, sprite) in sprites {
//                let previousConfig = tilesState.getConfig(id)
//                let position = sprite.position
//                let angle = sprite.zRotation
//                
//                let newPosition = CGPoint(
//                    x: position.x - previousConfig.size.width / (2 * BackgroundSimulation.zoom),
//                    y: position.y - previousConfig.size.height / (2 * BackgroundSimulation.zoom)
//                )
//                
//                let config = previousConfig.copyWith(position: newPosition, angle: angle)
//                tilesState.setConfig(id: id, config: config)
//                
//                // Aplicar amortecimento à velocidade angular
//                if let body = sprite.physicsBody {
//                    body.angularVelocity *= 0.98  // Reduzir velocidade angular em 5% a cada frame
//                }
//            }
//            
//            tilesState.notifyListenersIfChanged()
//        }
//    }
//    
//    private func createBoundaries() {
//        let visibleRect = self.frame
//        let translation: CGFloat = 1.0
//        
//        let topLeft = CGPoint(x: visibleRect.minX - translation, y: visibleRect.minY - translation)
//        let topRight = CGPoint(x: visibleRect.maxX + translation, y: visibleRect.minY - translation)
//        let bottomRight = CGPoint(x: visibleRect.maxX + translation, y: visibleRect.maxY + translation)
//        let bottomLeft = CGPoint(x: visibleRect.minX - translation, y: visibleRect.maxY + translation)
//        
//        createBoundary(start: topLeft, end: topRight)
//        createBoundary(start: topRight, end: bottomRight)
//        createBoundary(start: bottomRight, end: bottomLeft)
//        createBoundary(start: bottomLeft, end: topLeft)
//    }
//    
//    private func createBoundary(start: CGPoint, end: CGPoint) {
//        let node = SKNode()
//        let physicsBody = SKPhysicsBody(edgeFrom: start, to: end)
//        physicsBody.friction = 0.3
//        physicsBody.restitution = 0.5
//        physicsBody.isDynamic = false
//        node.physicsBody = physicsBody
//        addChild(node)
//    }
//    
//    private func createTileBody(id: Int, config: TileConfig) {
//        let size = CGSize(
//            width: config.size.width / 2,
//            height: config.size.height
//        )
//        let sprite = SKSpriteNode(color: .blue, size: size)
//        sprite.position = CGPoint(
//            x: config.position.x + size.width / 2,
//            y: config.position.y + size.height / 2
//        )
//        sprite.zRotation = config.angle
//        
//        let body = SKPhysicsBody(rectangleOf: size)
//        body.restitution = 0.2
//        body.friction = 0.5
//        body.density = 1000
//        body.angularDamping = 0.5
//        body.linearDamping = 0.1
//        body.allowsRotation = true
//        body.affectedByGravity = false
//        body.mass = 1.0
//        body.collisionBitMask = 0xFFFFFFFF
//        body.contactTestBitMask = 0xFFFFFFFF
//        
//        sprite.physicsBody = body
//        addChild(sprite)
//        
//        bodies[id] = body
//        sprites[id] = sprite
//        
//        applyRandomForces(to: body)
//    }
//    
//    private func applyRandomForces(to body: SKPhysicsBody) {
//        if Bool.random() {
//            let impulse = CGFloat.random(in: 800...1300)
//            body.applyImpulse(CGVector(dx: CGFloat.random(in: -impulse...impulse),
//                                       dy: CGFloat.random(in: -impulse...impulse)))
//        }
//        
//        if Bool.random() {
//            let angularImpulse = CGFloat.random(in: 3...6)
//            body.applyAngularImpulse(angularImpulse * (Bool.random() ? 1 : -1))
//        }
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        let location = touch.location(in: self)
//        
//        if let sprite = atPoint(location) as? SKSpriteNode, sprites.values.contains(sprite) {
//            touchedNode = sprite
//            initialTouchPosition = location
//            lastTouchPosition = location
//            
//            // Calcular o offset entre o ponto de toque e o centro do sprite
//            touchOffset = CGPoint(x: location.x - sprite.position.x,
//                                  y: location.y - sprite.position.y)
//            
//            touchStartTime = touch.timestamp
//            lastUpdateTime = touch.timestamp
//            
//            if let physicsBody = sprite.physicsBody {
//                physicsBody.velocity = .zero
//                physicsBody.angularVelocity = 0
//            }
//        }
//    }
//    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first,
//              let sprite = touchedNode,
//              let offset = touchOffset else { return }
//        
//        let location = touch.location(in: self)
//        
//        // Calcular a nova posição
//        let newPosition = CGPoint(x: location.x - offset.x, y: location.y - offset.y)
//        
//        // Aplicar o movimento suave
//        let movementSmoothFactor: CGFloat = 0.8
//        var nextX = sprite.position.x + (newPosition.x - sprite.position.x) * movementSmoothFactor
//        var nextY = sprite.position.y + (newPosition.y - sprite.position.y) * movementSmoothFactor
//        
//        // Obter os limites da cena
//        let minX = frame.minX + sprite.size.width / 2
//        let maxX = frame.maxX - sprite.size.width / 2
//        let minY = frame.minY + sprite.size.height / 2
//        let maxY = frame.maxY - sprite.size.height / 2
//        
//        // Restringir a posição do sprite dentro dos limites da cena
//        nextX = max(minX, min(maxX, nextX))
//        nextY = max(minY, min(maxY, nextY))
//        
//        // Atualizar a posição do sprite
//        sprite.position = CGPoint(x: nextX, y: nextY)
//        
//        // ... (resto do código de touchesMoved permanece inalterado)
//        
//        lastTouchPosition = location
//        lastUpdateTime = touch.timestamp
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let sprite = touchedNode,
//              let physicsBody = sprite.physicsBody,
//              let lastPosition = lastTouchPosition,
//              let lastUpdateTime = self.lastUpdateTime,
//              let touch = touches.first else {
//            resetTouchVariables()
//            return
//        }
//        
//        let location = touch.location(in: self)
//        let currentTime = touch.timestamp
//        let dt = currentTime - lastUpdateTime
//        
//        // Aplicar velocidade linear final
//        let dx = location.x - lastPosition.x
//        let dy = location.y - lastPosition.y
//        let velocity = CGVector(dx: dx / CGFloat(dt), dy: dy / CGFloat(dt))
//        
//        // Limitar a velocidade máxima
//        let maxVelocity: CGFloat = 2000
//        let speed = sqrt(velocity.dx * velocity.dx + velocity.dy * velocity.dy)
//        if speed > maxVelocity {
//            let scale = maxVelocity / speed
//            physicsBody.velocity = CGVector(dx: velocity.dx * scale, dy: velocity.dy * scale)
//        } else {
//            physicsBody.velocity = velocity
//        }
//        
//        resetTouchVariables()
//    }
//    
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        touchesEnded(touches, with: event)
//    }
//    
//    private func resetTouchVariables() {
//        touchedNode = nil
//        initialTouchPosition = nil
//        lastTouchPosition = nil
//        touchOffset = nil
//        touchStartTime = nil
//        lastUpdateTime = nil
//    }
//    
//    private func shortestAngleBetween(angle1: CGFloat, angle2: CGFloat) -> CGFloat {
//        var angle = (angle2 - angle1).truncatingRemainder(dividingBy: .pi * 2)
//        if angle >= .pi {
//            angle -= .pi * 2
//        }
//        if angle <= -.pi {
//            angle += .pi * 2
//        }
//        return angle
//    }
//}
//
//class TilesState: ObservableObject {
//    @Published private(set) var configs: [Int: TileConfig] = [:]
//    private(set) var isReady: Bool = false
//    var count: Int { configs.count }
//    
//    func getConfig(_ id: Int) -> TileConfig {
//        configs[id] ?? TileConfig(position: .zero, size: .zero, angle: 0)
//    }
//    
//    func setConfig(id: Int, config: TileConfig) {
//        configs[id] = config
//    }
//    
//    func notifyListenersIfChanged() {
//        objectWillChange.send()
//    }
//    
//    func setReady() {
//        isReady = true
//    }
//}
//
//// Definições de dados e configuração dos tiles
//struct TileConfig: Equatable {
//    var position: CGPoint
//    var size: CGSize
//    var angle: CGFloat
//    
//    func copyWith(position: CGPoint? = nil, size: CGSize? = nil, angle: CGFloat? = nil) -> TileConfig {
//        TileConfig(
//            position: position ?? self.position,
//            size: size ?? self.size,
//            angle: angle ?? self.angle
//        )
//    }
//}
//
//// Estrutura de dados para o Tile
//struct TileData {
//    let title: String
//    let location: String
//}
//
//// Visualização de um Tile
//struct TileView: View {
//    let data: TileData
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 4) {
//            HStack {
//                // Imagem circular
//                Circle()
//                    .fill(Color.blue.opacity(0.2))
//                    .frame(width: 30, height: 30)
//                
//                VStack(alignment: .leading) {
//                    Text("data.title - data.title")
//                        .font(.system(size: 16, weight: .semibold))
//                        .lineLimit(1)
//                        .foregroundStyle(.black)
//                    
//                    Text("data.location")
//                        .font(.system(size: 12, weight: .semibold))
//                        .foregroundColor(.gray)
//                }
//            }
//            .padding(.vertical, 12)
//            .padding(.horizontal, 16)
//            .background(Color.white)
//            .cornerRadius(16)
//            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
//        }
//    }
//}
//
//extension CGVector {
//    var magnitude: CGFloat {
//        return sqrt(dx*dx + dy*dy)
//    }
//}


import SwiftUI
import SpriteKit


struct BackgroundView: View {
    @StateObject private var tilesState = TilesState()
    @State private var scene: BackgroundSimulation?
    @State private var dragOffsets: [Int: CGSize] = [:]
    
    private func convertPosition(_ position: CGPoint, in size: CGSize) -> CGPoint {
        return CGPoint(x: position.x, y: size.height - position.y)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                SpriteView(scene: scene ?? BackgroundSimulation(tilesState: tilesState, size: geometry.size))
                    .edgesIgnoringSafeArea(.all)
                
                ForEach(0..<tilesState.count, id: \.self) { id in
                    TileWrapper(
                        id: id,
                        config: tilesState.getConfig(id),
                        geometrySize: geometry.size,
                        content: {_ in 
                            TileView(data: TileData(title: "Locassddfgd \(id)", location: "Location \(id)"), rotation: Angle(radians: Double(tilesState.getConfig(id).angle)))
                        },
                        dragOffset: Binding(
                            get: { dragOffsets[id] ?? .zero },
                            set: { dragOffsets[id] = $0 }
                        ),
                        onDragChanged: { newPosition, rotation in
                            scene?.updateTilePosition(id: id, position: newPosition, rotation: rotation)
                        },
                        onDragEnded: { finalPosition, velocity, angularVelocity in
                            scene?.endTileDrag(id: id, position: finalPosition, velocity: velocity, angularVelocity: angularVelocity)
                            dragOffsets[id] = .zero
                        }
                    )
                    .allowsHitTesting(true)
                }
            }
            .onAppear {
                if scene == nil {
                    scene = BackgroundSimulation(tilesState: tilesState, size: geometry.size)
                }
                
                // Initialize tiles
                for i in 0..<30 {
                    let config = TileConfig(
                        position: CGPoint(x: CGFloat.random(in: 0...geometry.size.width),
                                          y: CGFloat.random(in: 0...geometry.size.height)),
                        size: CGSize(width: 300, height: 50),
                        angle: CGFloat.random(in: 0...CGFloat.pi * 2)
                    )
                    tilesState.setConfig(id: i, config: config)
                }
                tilesState.setReady()
            }
        }
    }
}

struct TileWrapper<Content: View>: View {
    let id: Int
    let config: TileConfig
    let geometrySize: CGSize
    let content: (CGFloat) -> Content
    @Binding var dragOffset: CGSize
    let onDragChanged: (CGPoint, CGFloat) -> Void
    let onDragEnded: (CGPoint, CGVector, CGFloat) -> Void
    
    @State private var isDragging = false
    @State private var lastDragPosition: CGPoint?
    @State private var angularVelocity: CGFloat = 0
    @State private var currentRotation: CGFloat
    @State private var dragAnchor: CGPoint = .zero
    
    init(id: Int, config: TileConfig, geometrySize: CGSize, content: @escaping (CGFloat) -> Content, dragOffset: Binding<CGSize>, onDragChanged: @escaping (CGPoint, CGFloat) -> Void, onDragEnded: @escaping (CGPoint, CGVector, CGFloat) -> Void) {
        self.id = id
        self.config = config
        self.geometrySize = geometrySize
        self.content = content
        self._dragOffset = dragOffset
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
            
            tilesState.notifyListenersIfChanged()
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

class TilesState: ObservableObject {
    @Published private(set) var configs: [Int: TileConfig] = [:]
    private(set) var isReady: Bool = false
    var count: Int { configs.count }
    
    func getConfig(_ id: Int) -> TileConfig {
        configs[id] ?? TileConfig(position: .zero, size: .zero, angle: 0)
    }
    
    func setConfig(id: Int, config: TileConfig) {
        configs[id] = config
    }
    
    func notifyListenersIfChanged() {
        objectWillChange.send()
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

struct TileData {
    let title: String
    let location: String
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

extension CGVector {
    var magnitude: CGFloat {
        return sqrt(dx*dx + dy*dy)
    }
}

#Preview {
    BackgroundView()
}
