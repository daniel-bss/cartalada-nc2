//
//  MyARContainerView.swift
//  BelajarSceneKit
//
//  Created by Daniel Bernard Sahala Simamora on 16/02/24.
//

import SwiftUI
import RealityKit
import Combine

struct MyARContainerView: UIViewRepresentable {
    
    @Binding var model1Offset: CGSize
    
    @State var mysubs = [Cancellable]()
    
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        let anchor = AnchorEntity()
        arView.scene.anchors.append(anchor)
        
        let model1 = CustomBox(color: .blue)
        let model2 = CustomBox(color: .blue)
        
        model1.name = "model1"
        
        model1.position = SIMD3<Float>(0.15, 0, -0.2)
        model2.position = SIMD3<Float>(-0.15, 0, -0.2)
        

        anchor.addChild(model1)
        anchor.addChild(model2)

        let beginSub = arView.scene.subscribe(
            to: CollisionEvents.Began.self,
            on: model1
        ) { event in
            // Get both of the entities from the event
            let boxA = event.entityA as? CustomBox
            let boxB = event.entityB as? CustomBox
            // Change the materials
            boxA!.model?.materials = [
                SimpleMaterial(color: .red, isMetallic: false)
            ]
            boxB!.model?.materials = [
                SimpleMaterial(color: .red, isMetallic: false)
            ]
        }
        let endSub = arView.scene.subscribe(
            to: CollisionEvents.Ended.self,
            on: model2
        ) { event in
            // Get both of the entities from the event
            let boxA = event.entityA as? CustomBox
            let boxB = event.entityB as? CustomBox
            // Change the materials
            boxA!.model?.materials = [
                SimpleMaterial(color: .green, isMetallic: false)
            ]
            boxB!.model?.materials = [
                SimpleMaterial(color: .green, isMetallic: false)
            ]
        }
        
        mysubs.append(beginSub)
        mysubs.append(endSub)
        
//        model1.addColllisions()
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        let entities = uiView.scene.anchors[0].children
        
        let xSign: Float = model1Offset.width > 0 ? 1 : -1
        let ySign: Float = (-1 * model1Offset.height) > 0 ? 1 : -1
        
        for entity in entities {
            if entity.name == "model1" {
                entity.transform.translation += SIMD3<Float>(xSign * 0.01, ySign * 0.01, 0)
            }
        }
        
        
    }
}
