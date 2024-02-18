//
//  AppViewModel.swift
//  BelajarSceneKit
//
//  Created by Daniel Bernard Sahala Simamora on 18/02/24.
//

import SwiftUI
import RealityKit

class AppViewModel: ObservableObject {
    
    var paperColor: Color = .red
    var words: String = ""
    var postedPapers = [PostedPaper]()
    
    @Published var isShowingWelcomeView = true
    @Published var didFinishPosting = false

//    @Published var isShowingWelcomeView = false
//    @Published var didFinishPosting = false
    
    @Published var planeTranslation: SIMD3<Float> = SIMD3<Float>(0, -0.3, -0.45)
    @Published var rotation: simd_quatf = simd_quatf(angle: Float(0 * Double.pi / 180.0), axis: SIMD3<Float>(0, 1, 0))
    
    
    
}
