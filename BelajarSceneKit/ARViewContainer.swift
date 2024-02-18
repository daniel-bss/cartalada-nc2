//
//  ARViewContainer.swift
//  BelajarSceneKit
//
//  Created by Daniel Bernard Sahala Simamora on 26/05/23.
//

import SwiftUI
import RealityKit

struct ARViewContainer: UIViewRepresentable {
    
    
    
    @ObservedObject var vm: AppViewModel
    
    @State var entityName: String = ""
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(aRViewContainer: self)
    }
    
    final class Coordinator: NSObject, CustomEntityDelegate {
        
        private let aRViewContainer: ARViewContainer
        
        init(aRViewContainer: ARViewContainer) {
            self.aRViewContainer = aRViewContainer
        }
        
        func didCollide(postedPaper: PostedPaper) {
            aRViewContainer.vm.postedPapers.append(postedPaper)
            aRViewContainer.vm.didFinishPosting = true
        }
    }

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        print("BARU NIH!!!")
        

        let anchor = AnchorEntity()
        anchor.name = "anchor"
        arView.scene.anchors.append(anchor)

        print("ENTITIES: \(arView.scene.anchors[0].children.count)")
        
        // ============ PAPAN
        let papan = CustomEntity(color: .green, position: SIMD3<Float>(0,0,-2.5))
        
        papan.collisionSubs.forEach {
            $0.cancel()
        }
        papan.collisionSubs.removeAll()
        papan.customEntityDelegate = context.coordinator
        anchor.addChild(papan)

        papan.addCollisions(arView: arView, paperVm: vm, paperColor: vm.paperColor, words: vm.words)
        
        self.createPostIt(arView: arView)
        
        // ============ PESAWAT
        let color = vm.paperColor
        var modelEntity = ModelEntity()
        
        switch color {
        case .primaryBlue:
            modelEntity = try! Entity.loadModel(named: "planeblue")
            modelEntity.name = "planeblue"
            modelEntity.transform.rotation = simd_quatf(angle: Float(0 * Double.pi / 180.0), axis: SIMD3<Float>(0, 1, 0))
            DispatchQueue.global(qos: .background).async {
                self.entityName = "planeblue"
            }
        case .primaryLightBlue:
            modelEntity = try! Entity.loadModel(named: "planelightblue")
            modelEntity.name = "planelightblue"
            DispatchQueue.global(qos: .background).async {
                self.entityName = "planelightblue"
            }
        case .primaryGreen:
            modelEntity = try! Entity.loadModel(named: "planegreen")
            modelEntity.name = "planegreen"
            DispatchQueue.global(qos: .background).async {
                self.entityName = "planegreen"
            }
        case .primaryLightGreen:
            modelEntity = try! Entity.loadModel(named: "planelightgreen")
            modelEntity.name = "planelightgreen"
            DispatchQueue.global(qos: .background).async {
                self.entityName = "planelightgreen"
            }
        case .primaryYellow:
            modelEntity = try! Entity.loadModel(named: "planeyellow")
            modelEntity.name = "planeyellow"
            DispatchQueue.global(qos: .background).async {
                self.entityName = "planeyellow"
            }
        case .primaryPink:
            modelEntity = try! Entity.loadModel(named: "planepink")
            modelEntity.name = "planepink"
            DispatchQueue.global(qos: .background).async {
                self.entityName = "planepink"
            }
        default:
            modelEntity = try! Entity.loadModel(named: "planedefault")
            modelEntity.name = "planedefault"
            DispatchQueue.global(qos: .background).async {
                self.entityName = "planedefault"
            }
        }

        modelEntity.position = SIMD3<Float>(0, -0.2, -0.35)
        vm.planeTranslation = SIMD3<Float>(0, -0.3, -0.45)
        
        modelEntity.collision = CollisionComponent(shapes: [.generateBox(size: SIMD3<Float>(0.16, 0.04, 0.21))])
        modelEntity.physicsBody = .init()
        modelEntity.physicsBody?.mode = .kinematic
        anchor.addChild(modelEntity)

        
        
        print("TOTAL ENTITIES: \(arView.scene.anchors[0].children.count)")
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        let entities = uiView.scene.anchors[0].children
        
        for entity in entities {
            if entity.name == self.entityName {
                print("<><>", entity.name)
                let paperPlaneEntity = entity
                paperPlaneEntity.transform.translation = vm.planeTranslation
                paperPlaneEntity.transform.rotation = vm.rotation
                
            }
        }
        
    }
    
    func createPostIt(arView: ARView) {
        let entities = arView.scene.anchors[0].children
        var papan = Entity()
        for entity in entities {
            if entity.name == "papan" {
                print("\(entity.position)")
                papan = entity
            }
        }
        for postedPaper in vm.postedPapers {
            let newEntity = ModelEntity(
                mesh: .generateBox(width: 0.2, height: 0.2, depth: 0.001),
                materials: [SimpleMaterial(
                    color: UIColor(postedPaper.color),
                    isMetallic: false)
                ]
            )
            newEntity.name = "post-it"
            
            let textEntity = ModelEntity(
                mesh: .generateText(
                    postedPaper.words,
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
            
            newEntity.position = SIMD3<Float>(
                x: postedPaper.position.x,
                y: postedPaper.position.y,
                z: papan.position.z + 0.05
            )
            
            textEntity.position = .zero
            textEntity.position.z += 0.005
            
            newEntity.addChild(textEntity)
            arView.scene.anchors[0].addChild(newEntity)
        }

    }
    
}

