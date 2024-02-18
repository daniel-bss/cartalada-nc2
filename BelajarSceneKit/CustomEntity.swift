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
    
    required init(color: UIColor) {
        super.init()
        
        self.collision = CollisionComponent(
            shapes: [.generateBox(size: [1.2, 0.9, 0.04])],
            mode: .trigger,
            filter: .sensor
        )
        
        self.model = ModelComponent(
            mesh: .generateBox(size: [1.2, 0.9, 0.03]),
            materials: [SimpleMaterial(
                color: color,
                isMetallic: false)
            ]
        )
        
        self.name = "papan"
    }
    
    convenience init(color: UIColor, position: SIMD3<Float>) {
        self.init(color: color)
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
                print("PAPER PLANE ENTITY ISN'T DETECTED")
                return
            }
            
            let newEntity = ModelEntity(
                mesh: .generateBox(width: 0.2, height: 0.2, depth: 0.001),
                materials: [SimpleMaterial(
                    color: UIColor(paperColor),
                    isMetallic: false)
                ]
            )
            
            let textEntity = ModelEntity(
                mesh: .generateText(
                    words,
                    extrusionDepth: 0.001,
                    font: .systemFont(ofSize: 0.017, weight: .bold),
                    containerFrame: CGRect(x: -0.19/2.0, y: -0.12, width: 0.19, height: 0.19),
                    alignment: .left,
                    lineBreakMode: .byWordWrapping
                ),
                materials: [SimpleMaterial(
                    color: .black,
                    isMetallic: false)
                ]
            )
            
            newEntity.position = SIMD3<Float>(x: paperPlane.position.x, y: paperPlane.position.y, z: paperPlane.position.z + 0.05)
            textEntity.position = .zero
            textEntity.position.z += 0.005
            newEntity.addChild(textEntity)
            
            arView.scene.anchors[0].addChild(newEntity)
            
            for entity in arView.scene.anchors[0].children {
                if entity.name.contains("plane") {
                    print("POSITION", entity.position)
                    entity.removeFromParent()
                    
                    self.customEntityDelegate?.didCollide(
                        postedPaper: PostedPaper(
                            color: paperColor,
                            words: words,
                            position: newEntity.position
                        )
                    )
                }
            }
            
            
            
        })
        
      }
}
