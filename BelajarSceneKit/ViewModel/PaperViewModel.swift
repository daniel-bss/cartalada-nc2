//
//  NasiPadang.swift
//  BelajarSceneKit
//
//  Created by Daniel Bernard Sahala Simamora on 25/05/23.
//

import SwiftUI
import RealityKit

class PaperViewModel: ObservableObject {
    @Published var lastPosition: SIMD3<Float> = SIMD3<Float>(0.0, 0.0, 0.0)
    @Published var paperColor: Color = .white
    @Published var papers: [Paper] = []
    @Published var isPosted: Bool = false
//    @Published var postedCoordinates: [SIMD3<Float>] = []

}
