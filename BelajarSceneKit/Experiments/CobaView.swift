//
//  CobaView.swift
//  BelajarSceneKit
//
//  Created by Daniel Bernard Sahala Simamora on 15/02/24.
//

import SwiftUI
import RealityKit
import Foundation

struct CobaView: View {
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("haha")
                
                NavigationLink {
                    DetailView()
                } label: {
                    Text("click me")
                }

            }
            .navigationTitle("hehe\(Int.random(in: 0...1000))")
        }
    }
}

struct DetailView: View {
    
    @State var isPresented = false
    
    var body: some View {
        VStack {
            Text("welcome")
            
            Button(action: {
                isPresented = true
            }, label: {
                Text("present")
            })
            .fullScreenCover(isPresented: $isPresented, content: {
                ZStack {
                    CobaView()
                }
            })
        }
        .onDisappear {
            print("ini hilang")
        }
        
    }
}

#Preview {
    CobaView()
}

//struct CobaView: View {
//    @State var knobOffset: CGSize = .zero
//
//    var body: some View {
//        ZStack {
//            MyARContainerView(model1Offset: $knobOffset)
//
//            ZStack {
//                Circle()
//                    .fill(.gray)
//                    .frame(width: 175, height: 175)
//
//                Circle()
//                    .fill(RadialGradient(gradient: Gradient(colors: [.black, .white]), center: .center, startRadius: 0, endRadius: 65))
//                    .frame(width: 75, height: 75)
//                    .overlay(
//                        Circle()
//                            .stroke(.black, lineWidth: 1)
//                    )
//                    .offset(self.knobOffset)
//                    .gesture(
//                        DragGesture()
//                            .onChanged({ value in
//                                let x = value.translation.width
//                                let y = value.translation.height
//                                let border = 65.0
//                                let radiusTemp = sqrt(pow(x, 2) + pow(y, 2))
//                                let tangen: Double = atan2(y, x)
//
//                                if radiusTemp <= border {
//                                    self.knobOffset = value.translation
//                                } else {
//                                    self.knobOffset = CGSize(width: border * cos(tangen), height: border * sin(tangen))
//                                }
//                                
//                                
//                            })
//                            .onEnded({ _ in
//                                self.knobOffset = .zero
//                            })
//                    )
//            }
//            .offset(y: 250)
//            
//        }
//        .ignoresSafeArea()
//    }
//}



