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
            aRViewContainer.vm.didFinishPosting = true
            aRViewContainer.vm.addPaper(postedPaper: postedPaper) // proceed to core data
        }
    }

    func makeUIView(context: UIViewRepresentableContext<ARViewContainer>) -> ARView {
        let arView = ARView(frame: .zero)
        
        let anchor = AnchorEntity()
        anchor.name = "anchor"
        arView.scene.anchors.append(anchor)
        
        // ============ PAPAN
        let papan = createBoardEntity(context: context, arView: arView)
        
        anchor.addChild(papan)

        papan.addCollisions(arView: arView, paperVm: vm, paperColor: vm.paperColor, words: vm.words)
        
        // ============ PAST POST-ITS
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
        
        DispatchQueue.main.async {
            vm.planeTranslation = SIMD3<Float>(0, -0.3, -0.35)
        }
        
        modelEntity.collision = CollisionComponent(shapes: [.generateBox(size: SIMD3<Float>(0.16, 0.04, 0.21))])
        
        anchor.addChild(modelEntity)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: UIViewRepresentableContext<ARViewContainer>) {
        let entities = uiView.scene.anchors[0].children
        
        // RESPOND TO JOYSTICK CONTROLVIEW
        for entity in entities {
            if entity.name == self.entityName {
                let paperPlaneEntity = entity
                paperPlaneEntity.transform.translation = vm.planeTranslation
                paperPlaneEntity.transform.rotation = vm.rotation
            }
        }
        
    }
    
    func createBoardEntity(context: UIViewRepresentableContext<ARViewContainer>, arView: ARView) -> CustomEntity {
        let innerBoardWidth: Float = 2.35
        let innerBoardHeight: Float = 1.15
        
        // note, hardcoded position would not affect when .addChild()
        let outerBoard = CustomEntity(color: .darkGray, position: SIMD3<Float>(0, 0 , -2.5), width: innerBoardWidth + 0.15, height: innerBoardHeight + 0.15)
        let innerBoard = CustomEntity(color: .white, position: SIMD3<Float>(0, 0 , -2.5), width: innerBoardWidth, height: innerBoardHeight)
        
        outerBoard.name = "papan-outer"
        innerBoard.name = "papan-inner"
        
        outerBoard.collisionSubs.forEach {
            $0.cancel()
        }
        outerBoard.collisionSubs.removeAll()
        outerBoard.customEntityDelegate = context.coordinator
        
        innerBoard.collisionSubs.forEach {
            $0.cancel()
        }
        innerBoard.collisionSubs.removeAll()
        innerBoard.customEntityDelegate = context.coordinator
        
        innerBoard.position.z += 0.03
        outerBoard.addChild(innerBoard)
        
        innerBoard.addCollisions(arView: arView, paperVm: vm, paperColor: vm.paperColor, words: vm.words)
        
        let textEntity = ModelEntity(
            mesh: .generateText(
                Utils.getFormattedDateString(date: Date()),
                extrusionDepth: 0.001,
                font: .systemFont(ofSize: 0.05, weight: .bold),
                containerFrame: CGRect(
                    x: Double(-innerBoardWidth / 2.0) + 0.04,
                    y: 0,
                    width: 0,
                    height: 0
                ),
                alignment: .left,
                lineBreakMode: .byWordWrapping
            ),
            materials: [
                SimpleMaterial(
                    color: UIColor.red,
                    isMetallic: false
                )
            ]
        )
        
        textEntity.position = .zero
        textEntity.position.y += (innerBoardHeight / 2.0 - 0.08)
        textEntity.position.z += 0.085
        
        outerBoard.addChild(textEntity)
        
        return outerBoard
    }
    
    // MARK: CREATE EXISTING POST-IT
    
    func createPostIt(arView: ARView) {
        let entities = arView.scene.anchors[0].children
        
        // GET PAPAN POSITION
        var papan = Entity()
        for entity in entities {
            if entity.name.contains("papan") {
                papan = entity
            }
        }
        
        // ADD EXISTING PAST PAPERS
        for postedPaper in vm.postedPapers {
            var dimension: Float = 0
            var yOffset: Float = 0
            
            switch postedPaper.paperSize {
            case "small":
                dimension = 0.2
                yOffset = -0.095
            case "medium":
                dimension = 0.25
                yOffset = -0.12
            case "large":
                dimension = 0.3
                yOffset = -0.15
            default:
                dimension = 0.2
                yOffset = -0.095
            }
            
            let paperEntity = ModelEntity(
                mesh: .generateBox(
                    width: dimension,
                    height: dimension,
                    depth: 0.001
                ),
                materials: [
                    SimpleMaterial(
                        color: Utils.hexStringToUIColor(hex: postedPaper.color),
                        isMetallic: false
                    )
                ]
            )
            paperEntity.name = "post-it"
            
            let textEntity = ModelEntity(
                mesh: .generateText(
                    postedPaper.words ?? "Failed to convert the input String",
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
            
            paperEntity.position = SIMD3<Float>(
                x: postedPaper.xPosition,
                y: postedPaper.yPosition,
                z: papan.position.z + 0.05
            )
            
            textEntity.position = .zero
            textEntity.position.z += 0.005
            
            paperEntity.addChild(textEntity)
            
            arView.scene.anchors[0].addChild(paperEntity)
        }

    }
    
    
}

