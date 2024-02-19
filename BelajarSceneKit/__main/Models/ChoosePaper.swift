//
//  ChoosePaper.swift
//  BelajarSceneKit
//
//  Created by Daniel Bernard Sahala Simamora on 18/02/24.
//

import SwiftUI

enum PaperSize: String {
    case small, medium, large
}

struct ChoosePaper: Identifiable {
    
    var id: UUID = UUID()
    
    var color: Color
    var frameSize: CGFloat = 75
    var realDimension: Int = 20
    var isClicked: Bool
    
}
