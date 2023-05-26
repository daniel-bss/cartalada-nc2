////
////  CustomUIViewEntity.swift
////  BelajarSceneKit
////
////  Created by Daniel Bernard Sahala Simamora on 26/05/23.
////
//
//import SwiftUI
//import RealityKit
//
//class CustomUIViewEntity: Entity, HasModel {
//    init(view: any View, arView: ARView) {
//        super.init()
//        
//        let hostView = UIHostingController(rootView: view)
//        let viewSize = arView.bounds.size
//        
////        let viewEntity = AnchorEntity(.zero)
//        let viewEntity = AnchorEntity()
//        viewEntity.addChild(view)
//        
//        let scale = 0.001 * Float(viewSize.width)
//        let matrixScale = float4x4(scale: scale)
//        self.model = ModelComponent(
//            mesh: .generateBox(size: 1),
//            materials: [SimpleMaterial(color: .clear, isMetallic: false)]
//        )
//        self.scale = matrixScale
//        self.addChild(viewEntity)
//    }
//    
//    required init() {
//        fatalError("init() has not been implemented")
//    }
//}
