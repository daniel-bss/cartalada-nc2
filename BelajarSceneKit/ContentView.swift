//
//  ContentView.swift
//  BelajarSceneKit
//
//  Created by Daniel Bernard Sahala Simamora on 22/05/23.
//


// UKURAN COLLISION UTK PESAWAT:
// SIMD3<Float>(0.16, 0.04, 0.21)

import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    @ObservedObject var paperVm: PaperViewModel
    let paperColor: Color
    let words: String
    
    @State var planeTranslation: SIMD3<Float> = SIMD3<Float>(0, -0.2, -0.35)
    @State var rotation: simd_quatf = simd_quatf(angle: Float(0 * Double.pi / 180.0), axis: SIMD3<Float>(0, 1, 0))
    
    @State var showingText: Bool = true
    
    var body: some View {
        ZStack {
            ARViewContainer(
                paperColor: paperColor,
                rotation: $rotation,
                planeTranslation: $planeTranslation,
                paperVm: paperVm,
                words: words
                
            )
//            ARViewContainer()
            if paperVm.isPosted {
                VStack {
                    if showingText {
                        Text("WKAOWKOAKWOWKA")
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    self.showingText = false
                                }
                            }
                    }

                    NavigationLink {
                        ZStack {
                            OnboardingView(paperVm: paperVm)
                        }
                        .ignoresSafeArea()
                        .navigationBarBackButtonHidden(true)
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color(red: (136/255), green: 85/255, blue: 212/255))
                                .frame(width: 48, height: 48)
                            Image(systemName: "repeat")
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.top, 50)
                }
            }
            
            if !paperVm.isPosted {
                ControlView(rotation: $rotation, planeTranslation: $planeTranslation)
            }
        }
        .ignoresSafeArea()
    }
}


// =================


//struct ARViewContainer: UIViewRepresentable {
//
//    func makeUIView(context: Context) -> ARView {
//
//        let arView = ARView(frame: .zero)
//
//        // Load the "Box" scene from the "Experience" Reality File
//        let boxAnchor = try! Experience.loadScene()
//
//        // Add the box anchor to the scene
//        arView.scene.anchors.append(boxAnchor)
//
//        return arView
//
//    }
//
//    func updateUIView(_ uiView: ARView, context: Context) {}
//
//}





//    func makeUIView(context: Context) -> ARView {
//        let arView = ARView(frame: .zero)
//        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: Bundle.main) else {
//            fatalError("Missing expected asset catalog resources.")
//        }
//        print(referenceImages)
////        let configuration = ARImageTrackingConfiguration()
//
//        let anchor = AnchorEntity()
//        let modelEntity = try! Entity.loadModel(named: "sneaker_airforce")
//
//        arView.scene.anchors.append(entity)
////        arView.session.run(configuration)
////        let anchor = AnchorEntity(anchor: ARImageAnchor()
//
//
////          if let imagesToTrack = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources",
////                                                                  bundle: Bundle.main) {
////              configuration.trackingImages = imagesToTrack
////              configuration.maximumNumberOfTrackedImages = 1
////          }
//
////        let coordinator = Coordinator2(arView: arView)
////        arView.session.run(configuration)
////        let anchor = AnchorEntity()
////        let modelEntity = try! Entity.loadModel(named: "paperplane")
////
////        modelEntity.position = SIMD3<Float>(0,-0.1, -0.5)
////        modelEntity.scale = SIMD3<Float>(repeating: 0.0001)
////
////        anchor.addChild(modelEntity)
////
////
////        arView.scene.anchors.compactMap {$0 as? ARImageAnchor}.forEach {
////            let anchorEntity = AnchorEntity()
////            let modelEntity = try! Entity.loadModel(named: "sneaker_airforce")
////            anchorEntity.addChild(modelEntity)
////            arView.scene.addAnchor(anchorEntity)
////        }
////        arView.scene.anchors.append(anchor)
//
//        return arView
//    }

//class Coordinator2: NSObject, ARSessionDelegate {
//    let arView: ARView
//
//    init(arView: ARView) {
//        self.arView = arView
//        super.init()
//        self.arView.session.delegate = self
//    }
//
//    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
//        guard let imageAnchor = anchors.compactMap({ $0 as? ARImageAnchor }).first else { return }
//
//        // Create an anchor entity when the tracked image is detected
//        let anchorEntity = AnchorEntity(anchor: imageAnchor)
//
//        // Create your 3D content and add it to the anchor entity
//        let modelEntity = try! ModelEntity.load(named: "sneaker_airforce.usdz")
//        anchorEntity.addChild(modelEntity)
//
//        // Add the anchor entity to the AR scene
//        arView.scene.addAnchor(anchorEntity)
//    }
//}

//#if DEBUG
//struct ContentView_Previews : PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
//#endif







//    func makeCoordinator() -> Coordinator {
//        print("OKEE")
//        return Coordinator(self)
//    }

/*
 
 func renderJoystickView() -> SKView {
 let spriteKitView = SKView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
 spriteKitView.allowsTransparency = true
 
 let spriteKitScene = SKScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
 spriteKitScene.backgroundColor = .clear
 
 let leftCircleNode = SKShapeNode(circleOfRadius: 50)
 leftCircleNode.fillColor = .red
 leftCircleNode.position = CGPoint(x: spriteKitScene.size.width / 4, y: spriteKitScene.size.height / 2 - 300) // POSITIF. (0,0) DI KIRI ATAS
 leftCircleNode.name = "leftCircle"
 
 // Create the right circle node in the SpriteKit scene
 let rightCircleNode = SKShapeNode(circleOfRadius: 50)
 rightCircleNode.fillColor = .gray
 rightCircleNode.position = CGPoint(x: (spriteKitScene.size.width / 4) * 3, y: spriteKitScene.size.height / 2 - 300)
 leftCircleNode.name = "rightCircle"
 
 // Add the circle nodes to the SpriteKit scene
 spriteKitScene.addChild(leftCircleNode)
 spriteKitScene.addChild(rightCircleNode)
 
 spriteKitView.presentScene(spriteKitScene)
 return spriteKitView
 }
 */
