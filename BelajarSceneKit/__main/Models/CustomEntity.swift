//
//  CustomEntity.swift
//  BelajarSceneKit
//
//  Created by Daniel Bernard Sahala Simamora on 26/05/23.
//

import SwiftUI
import RealityKit
import Combine

protocol CustomEntityDelegate {
    func didCollide(postedPaper: PostedPaper)
}

class CustomEntity: Entity, HasModel, HasAnchoring, HasCollision {
    
    var customEntityDelegate: CustomEntityDelegate?
    
    public var collisionSubs = [Cancellable]()
    
    required init(color: UIColor, position: SIMD3<Float>, width: Float, height: Float) {
        super.init()
        
        self.collision = CollisionComponent(
            shapes: [.generateBox(size: [width, height, 0.03])],
            mode: .trigger,
            filter: .sensor
        )
        
        self.model = ModelComponent(
            mesh: .generateBox(size: [width, height, 0.03]),
            materials: [SimpleMaterial(
                color: color,
                isMetallic: false)
            ]
        )
        
        self.position = position
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    func addCollisions(arView: ARView, paperVm: AppViewModel, paperColor: Color, words: String) {
        guard let scene = self.scene else {
          return
        }

        collisionSubs.append(scene.subscribe(to: CollisionEvents.Began.self, on: self) {
            event in
            var paperPlane: Entity?
            
            if event.entityA.name.contains("plane") {
                paperPlane = event.entityA
            } else if event.entityB.name.contains("plane") {
                paperPlane = event.entityB
            }
            
            guard let paperPlane else {
                // the collision still happens even though the Cancellables array has been cleared and cancel()
                return
            }
            
            var dimension: Float = 0
            var yOffset: Float = 0
            
            switch paperVm.paperSize {
            case .small:
                dimension = 0.2
                yOffset = -0.095
            case .medium:
                dimension = 0.25
                yOffset = -0.12
            case .large:
                dimension = 0.3
                yOffset = -0.15
            }
            
            let newEntity = ModelEntity(
                mesh: .generateBox(width: dimension, height: dimension, depth: 0.001),
                materials: [
                    SimpleMaterial(
                        color: UIColor(paperColor),
                        isMetallic: false
                    )
                ]
            )
            
            let textEntity = ModelEntity(
                mesh: .generateText(
                    words,
                    extrusionDepth: 0.001,
                    font: .systemFont(ofSize: 0.017, weight: .bold),
                    containerFrame: CGRect(
                        x: (-(Double(dimension) - 0.01) / 2.0) + 0.003,
                        y: Double(yOffset),
                        width: Double(dimension - 0.01),
                        height: Double(dimension - 0.01)
                    ),
                    alignment: .left,
                    lineBreakMode: .byWordWrapping
                ),
                materials: [
                    SimpleMaterial(
                        color: .black,
                        isMetallic: false
                    )
                ]
            )
            
            newEntity.position = SIMD3<Float>(x: paperPlane.position.x, y: paperPlane.position.y, z: paperPlane.position.z + 0.05)
            textEntity.position = .zero
            textEntity.position.z += 0.005
            newEntity.addChild(textEntity)
            
            arView.scene.anchors[0].addChild(newEntity)
            
            for entity in arView.scene.anchors[0].children {
                if entity.name.contains("plane") {
                    entity.removeFromParent()
                    
                    self.customEntityDelegate?.didCollide(
                        postedPaper: PostedPaper(
                            color: paperColor,
                            words: words,
                            paperSize: paperVm.paperSize,
                            position: newEntity.position
                        )
                    )
                }
            }
        })
        
      }
}
