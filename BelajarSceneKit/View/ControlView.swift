//
//  JoystickView.swift
//  BelajarSceneKit
//
//  Created by Daniel Bernard Sahala Simamora on 23/05/23.
//

import SwiftUI
import Foundation
import RealityKit


struct ControlView: View {
    @Binding var rotation: simd_quatf
    @Binding var planeTranslation: SIMD3<Float>
    
    var body: some View {
        Group {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.gray)
                        .frame(width: 150, height: 200)
                        .opacity(0.3)
                    
                    VStack {
                        AltitudeUpButton()
                            .padding(.bottom, 10)
                            .gesture(
                                DragGesture(minimumDistance: -10)
                                    .onChanged({ value in
                                        self.planeTranslation.y += (0.02)
                                    })
                                    .onEnded({ _ in })
                            )

                        
                        AltitudeDownButton()
                            .gesture(
                                DragGesture(minimumDistance: -10)
                                    .onChanged({ value in
                                        self.planeTranslation.y -= (0.02)
                                    })
                                    .onEnded({ _ in })
                            )
                    }
                }
                .padding(.trailing, 15)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.gray)
                        .frame(width: 200, height: 200)
                        .opacity(0.3)
                    JoystickView(rotation: $rotation, planeTranslation: $planeTranslation)
                }
            }
            .padding(.top, 550)
        }
    }
}

struct JoystickView: View {
    @State var buletanOffset: CGSize = .zero
    @Binding var rotation: simd_quatf
    @Binding var planeTranslation: SIMD3<Float>
    
    var body: some View {
        ZStack {
            Circle()
                .fill(.gray)
                .frame(width: 175, height: 175)
            
            Circle()
                .fill(RadialGradient(gradient: Gradient(colors: [.black, .white]), center: .center, startRadius: 0, endRadius: 55))
                .frame(width: 75, height: 75)
                .offset(self.buletanOffset)
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            let x = value.translation.width
                            let y = -value.translation.height
                            let border = 65.0
                            let aTan = atan((y / x) as Double)
                            
                            // JOYSTICK
                            if ((abs(value.translation.width) <= border) && (abs(value.translation.height) <= border)) {
                                // jaga di dalem
                                self.buletanOffset = value.translation
                            } else {
                                // batesin
                                if (x > 0 && y > 0) {        // KUADRAN 1
                                    self.buletanOffset = CGSize(width: border * cos(aTan), height: -border * sin(aTan))
                                } else if (x < 0 && y > 0) { // KUADRAN 2
                                    self.buletanOffset = CGSize(width: -border * cos(aTan), height: border * sin(aTan))
                                } else if (x < 0 && y < 0) { // KUADRAN 3
                                    self.buletanOffset = CGSize(width: -border * cos(aTan), height: border * sin(aTan))
                                } else if (x > 0 && y < 0) { // KUADRAN 4
                                    self.buletanOffset = CGSize(width: border * cos(aTan), height: -border * sin(aTan))
                                }
                            }
                            
                            // MANIPULATE PLANE ROTATION
                            if (x > 0 && y > 0) {        // KUADRAN 1
                                self.rotation = simd_quatf(angle: Float(aTan - (Double.pi / 2)), axis: SIMD3<Float>(0, 1, 0))
                            } else if (x < 0 && y > 0) { // KUADRAN 2
                                self.rotation = simd_quatf(angle: Float(aTan + (Double.pi) - (Double.pi / 2)), axis: SIMD3<Float>(0, 1, 0))
                            } else if (x < 0 && y < 0) { // KUADRAN 3
                                self.rotation = simd_quatf(angle: Float(aTan + (Double.pi) - (Double.pi / 2)), axis: SIMD3<Float>(0, 1, 0))
                            } else if (x > 0 && y < 0) { // KUADRAN 4
                                self.rotation = simd_quatf(angle: Float(aTan + (Double.pi * 2) - (Double.pi / 2)), axis: SIMD3<Float>(0, 1, 0))
                            }
                            
                            // MANIPULATE XZ TRANSLATION
                            self.planeTranslation.x += Float(x * 0.0003)
                            self.planeTranslation.z -= Float(y * 0.0003)
                        })
                        .onEnded({ value in
                            self.buletanOffset = .zero
                        })
                )
            
        }
    }
}

struct AltitudeUpButton: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.gray)
            .frame(width: 110, height: 75)
    }
}

struct AltitudeDownButton: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.gray)
            .frame(width: 110, height: 75)
    }
}

struct ControlView_Previews : PreviewProvider {
    static var previews: some View {
        ControlView(
            rotation: .constant(simd_quatf(angle: Float(0 * Double.pi / 180.0), axis: SIMD3<Float>(0, 1, 0))),
            planeTranslation: .constant(SIMD3<Float>(0, -0.5, -0.5))
        )
    }
}
