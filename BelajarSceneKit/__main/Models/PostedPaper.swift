//
//  PostedPaper.swift
//  BelajarSceneKit
//
//  Created by Daniel Bernard Sahala Simamora on 18/02/24.
//

import SwiftUI

struct PostedPaper: Identifiable {
    
    let id = UUID()
    
    let color: Color
    let words: String
    let position: SIMD3<Float>
    
}
