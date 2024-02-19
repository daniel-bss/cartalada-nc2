//
//  JoystickView.swift
//  BelajarSceneKit
//
//  Created by Daniel Bernard Sahala Simamora on 23/05/23.
//

import SwiftUI
import RealityKit

struct ControlView: View {
    
    @ObservedObject var vm: AppViewModel
    
    var body: some View {
        Group {
            VStack {
                
                ZStack {
                    Circle()
                        .fill(.gray)
                        .frame(width: 75, height: 200)
                        .opacity(0.3)
                    Image(systemName: "camera.metering.center.weighted")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50)
                    Image(systemName: "plus")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30)
                        .rotationEffect(Angle(degrees: 45))
                    
                }
                .foregroundColor(.black)
                .padding(.bottom, -60)
                .padding(.trailing, 60)
                .onTapGesture {
                    vm.planeTranslation = SIMD3<Float>(0, -0.3, -0.45)
                    vm.rotation = simd_quatf(angle: Float(0 * Double.pi / 180.0), axis: SIMD3<Float>(0, 1, 0))
                }
                
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.gray)
                            .frame(width: 150, height: 200)
                            .opacity(0.3)
                        
                        AltitudeView(planeTranslation: $vm.planeTranslation)
                    }
                    .padding(.trailing, 5)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.gray)
                            .frame(width: 200, height: 200)
                            .opacity(0.3)
                        JoystickView(rotation: $vm.rotation, planeTranslation: $vm.planeTranslation)
                    }
                }
            }
            .padding(.top, 400)

        }
    }
}

struct JoystickView: View {
    
    @Binding var rotation: simd_quatf
    @Binding var planeTranslation: SIMD3<Float>
    
    @State var buletanOffset: CGSize = .zero
    
    var body: some View {
        ZStack {
            Circle()
                .fill(.gray)
                .frame(width: 175, height: 175)
            
            Circle()
                .fill(RadialGradient(gradient: Gradient(colors: [.black, .white]), center: .center, startRadius: 0, endRadius: 65))
                .frame(width: 75, height: 75)
                .overlay(
                    Circle()
                        .stroke(.black, lineWidth: 1)
                )
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

struct AltitudeView: View {
    @State var altitudeOffset: CGSize = .zero
    @Binding var planeTranslation: SIMD3<Float>
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(.gray)
            .frame(width: 110, height: 170)
        
        RoundedRectangle(cornerRadius: 15)
            .fill(LinearGradient(gradient: Gradient(colors: [.gray, .black, .gray]), startPoint: .top, endPoint: .bottom))
            .frame(width: 120, height: 90)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(.black, lineWidth: 1)
            )
            .offset(altitudeOffset)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ value in
                        altitudeOffset.width = 0
                        altitudeOffset.height = value.translation.height
                        
                        if (value.translation.height <= -26) {
                            altitudeOffset.height = -26
                        } else if (value.translation.height >= 26) {
                            altitudeOffset.height = 26
                        }
                        
                        if (altitudeOffset.height < 0) { // ATAS
                            self.planeTranslation.y += (0.02)
                        } else if (altitudeOffset.height > 0) { // BAWAH
                            self.planeTranslation.y -= (0.02)
                            
                        }
                        
                    })
                    .onEnded({ value in
                        altitudeOffset = .zero
                    })
            )
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
        ControlView(vm: AppViewModel())
    }
}
