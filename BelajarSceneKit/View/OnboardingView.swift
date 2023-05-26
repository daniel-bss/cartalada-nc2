//
//  OnboardingView.swift
//  BelajarSceneKit
//
//  Created by Daniel Bernard Sahala Simamora on 25/05/23.
//

import SwiftUI
import RealityKit

struct OnboardingView: View {
//    @ObservedObject var paperVm: PaperViewModel
    @StateObject var paperVm = PaperViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("WELCOME")

                NavigationLink {
                    ZStack {
                        SelectPaperView(paperVm: paperVm) // INI YA
//                        ContentView()
                    }
                    .ignoresSafeArea()
                    .navigationBarBackButtonHidden(true)
                } label: {
                    HStack {
                        Image(systemName: "door.right.hand.open")
                        Text("Select Paper >>>")
                    }
                }

            }
            .onAppear {
                self.paperVm.isPosted = false
            }
        }
    }
}

//struct OnboardingView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingView(
//            translationY: .constant(0),
//            rotation: .constant(simd_quatf(angle: Float(0 * Double.pi / 180.0), axis: SIMD3<Float>(0, 1, 0))),
//            planeTranslation: .constant(SIMD3<Float>(0, -0.5, -0.5))
//        )
//    }
//}
