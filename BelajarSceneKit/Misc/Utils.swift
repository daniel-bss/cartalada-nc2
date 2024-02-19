//
//  Utils.swift
//  BelajarSceneKit
//
//  Created by Daniel Bernard Sahala Simamora on 18/02/24.
//

import Foundation

class Utils {
    
    static func generateRandomString() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789"
        return String((0..<[10, 20, 30].randomElement()!).map{ _ in letters.randomElement()! })
    }
    
}
