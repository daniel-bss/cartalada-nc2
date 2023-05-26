//
//  CustomEntity.swift
//  BelajarSceneKit
//
//  Created by Daniel Bernard Sahala Simamora on 26/05/23.
//

import Foundation
import SwiftUI
import RealityKit
import Combine // untuk Cancellable


class CustomEntity: Entity, HasModel, HasAnchoring, HasCollision {
//    @ObservedObject var paperVm: PaperViewModel
    
    var collisionSubs: [Cancellable] = []
    
    required init(color: UIColor) {
        super.init()
        
        self.components[CollisionComponent] = CollisionComponent(
//            shapes: [.generateBox(size: [10, 8, 0.03])],
            shapes: [.generateBox(size: [0.4, 0.2, 0.03])],
            mode: .trigger,
          filter: .sensor
        )
        
        self.components[ModelComponent] = ModelComponent(
//            mesh: .generateBox(size: [10, 8, 0.03]),
            mesh: .generateBox(size: [0.4, 0.2, 0.03]),
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
    
    func addCollisions(uiView: ARView, entityName: String, paperColor: Color, paperVm: PaperViewModel, words: String) {
        guard let scene = self.scene else {
          return
        }

        collisionSubs.append(scene.subscribe(to: CollisionEvents.Began.self, on: self) { event in
            guard let boxA = event.entityA as? CustomEntity else {
                return
            }
            
            for entity in uiView.scene.anchors[0].children {
                if (entity.name == "planedefault" || entity.name == "planeblue" || entity.name == "planelightblue" || entity.name == "planegreen" || entity.name == "planelightgreen" || entity.name == "planeyellow" || entity.name == "planepink"){
                    entity.removeFromParent()
                    
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
                            alignment: .center,
                            lineBreakMode: .byWordWrapping
                        ),
                        materials: [SimpleMaterial(
                            color: .black,
                            isMetallic: false)
                        ]
                    )
                    
                    newEntity.name = "loremipsum"
                    newEntity.position = entity.position
                    textEntity.position = entity.position
                    textEntity.position.z += 0.005
                    uiView.scene.anchors[0].addChild(newEntity)
                    uiView.scene.anchors[0].addChild(textEntity)
                    
                    
                    print("GOOO")
//                    self.paperVm.postedCoordinates.append(entity.position)
//                    print("\n==========")
//                    print(self.paperVm.postedCoordinates)
//                    print("berapa: ", uiView.scene.anchors.count)
                }
            }
            
        })
      }
}
