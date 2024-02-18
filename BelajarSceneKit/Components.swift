//
//  Components.swift
//  BelajarSceneKit
//
//  Created by Daniel Bernard Sahala Simamora on 16/02/24.
//

import Foundation
import RealityKit
import UIKit
import Combine

class CustomBox: Entity, HasModel, HasCollision, HasAnchoring {
    
    var collisionSubs = [Cancellable]()
    
    init(color: UIColor) {
        super.init()
        
        self.model = ModelComponent(
            mesh: MeshResource.generateBox(size: [0.2, 0.1, 0.2]),
            materials: [
                SimpleMaterial(color: color, isMetallic: false)
            ]
        )
        
        self.collision = CollisionComponent(
            shapes: [.generateBox(size: [0.2, 0.1, 0.2])],
            mode: .trigger,
            filter: .sensor
        )
        
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    func addColllisions() {
        guard let scene = self.scene else {
            print("KOSONG SCENE")
            return
        }
        
        collisionSubs.append(scene.subscribe(to: CollisionEvents.Began.self, on: self) { event in
            guard let boxA = event.entityA as? CustomBox, let boxB = event.entityB as? CustomBox else {
                print("KOSONG BEGIN")
                return
            }
            
            boxA.model?.materials = [SimpleMaterial(color: .red, isMetallic: false)]
            boxB.model?.materials = [SimpleMaterial(color: .red, isMetallic: false)]
        })
        
        collisionSubs.append(scene.subscribe(to: CollisionEvents.Ended.self, on: self) { event in
            guard let boxA = event.entityA as? CustomBox, let boxB = event.entityB as? CustomBox else {
                print("KOSONG ENDED")
                return
            }
            
            boxA.model?.materials = [SimpleMaterial(color: .green, isMetallic: false)]
            boxB.model?.materials = [SimpleMaterial(color: .green, isMetallic: false)]
        })
    }
}

struct CardComponent: Component, Codable {
    var isRevealed = false
    var id: Int
    
    init(isRevealed: Bool = false, id: Int) {
        self.isRevealed = isRevealed
        self.id = id
        
        Self.registerComponent()
    }
}

protocol HasCard: Entity {
//    var card: CardComponent { get set }
//    var cardID: Int { get }
//    var isRevealed: Bool { get }
}

extension HasCard {
//extension HasCard: Entity {
    
    var card: CardComponent {
        get {
            return self.components[CardComponent.self]! // ??
        }
        
        set {
            components[CardComponent.self] = newValue
        }
    }
    
    var cardID: Int {
        self.card.id
    }
    
    var isRevealed: Bool {
        return self.card.isRevealed
    }
}

extension CustomBox: HasCard {
    func x() {
//        self.ca
    }
}
