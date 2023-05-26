//
//  ARViewContainer.swift
//  BelajarSceneKit
//
//  Created by Daniel Bernard Sahala Simamora on 26/05/23.
//

import SwiftUI
import RealityKit

// logic: anchor -> anchor.addChild(entity) -> arview.scene.anchors.append(anchor)
struct ARViewContainer: UIViewRepresentable { // swiftui
    let paperColor: Color
    @State var entityName: String = ""
    
    @Binding var rotation: simd_quatf
    @Binding var planeTranslation: SIMD3<Float>
    @ObservedObject var paperVm: PaperViewModel
    let words: String
    
//    func makeUIView(context: Context) -> ARView {
//        let arView = ARView(frame: .zero)
//
//        let anchor = AnchorEntity() // 1st time open the app
//        anchor.name = "anchor"
//        arView.scene.anchors.append(anchor)
//
//
//        return arView
//    }

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        let anchor = AnchorEntity() // 1st time open the app
        anchor.name = "anchor"

        // ============ PESAWAT
        let color = self.paperColor
        var modelEntity = ModelEntity()
        switch color {
        case .primaryBlue:
            modelEntity = try! Entity.loadModel(named: "planeblue")
            modelEntity.name = "planeblue"
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

        modelEntity.collision = CollisionComponent(shapes: [.generateBox(size: SIMD3<Float>(0.16, 0.04, 0.21))])
        modelEntity.physicsBody = .init()
        modelEntity.physicsBody?.mode = .kinematic
        anchor.addChild(modelEntity)

        // ============ PAPAN
        let papan = CustomEntity(color: .green, position: SIMD3<Float>(0,0,-1))
        anchor.addChild(papan)

        arView.scene.anchors.append(anchor)
        papan.addCollisions(uiView: arView, entityName: self.entityName, paperColor: paperColor, paperVm: paperVm, words: words)

        print(">> ANCHORS")
        for anchor in arView.scene.anchors {
            print(anchor)
        }
//        print(arView.scene.anchors[0])
        print("====================================")
//        print(">> ANCHORS")
//        for entity in arView.scene.anchors {
//            print(anchor)
//        }
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) { // selalu dipanggil 1x pertama kali
        let entities = uiView.scene.anchors[0].children
        
        
//        for anchor in uiView.scene.anchors {
//            if anchor.name == "tempAnchor" {
//                anchor.removeFromParent()
//            }
//        }
        for entity in entities {
            if entity.name == self.entityName {
//                print("nama saya \(self.entityName)")
                let paperPlaneEntity = entity
                paperPlaneEntity.transform.translation = self.planeTranslation
                paperPlaneEntity.transform.rotation = self.rotation
                
            }
        }
        
    }
    
}
