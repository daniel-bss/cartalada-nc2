//
//  Utils.swift
//  BelajarSceneKit
//
//  Created by Daniel Bernard Sahala Simamora on 18/02/24.
//

import Foundation
import UIKit

class Utils {
    
    static func generateRandomString() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789"
        return String((0..<[10, 20, 30].randomElement()!).map{ _ in letters.randomElement()! })
    }
    
    static func hexStringToUIColor(hex: String?) -> UIColor {
        guard let hex else {
            return UIColor.yellow
        }
        
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            if cString.count == 8 {
                cString = String(cString[..<cString.index(cString.endIndex, offsetBy: -2)])
            } else {
                return UIColor.yellow
            }
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static func getFormattedDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none

        return dateFormatter.string(from: date)
    }
    
}
