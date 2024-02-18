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
                Image("cartaladaicon")
                    .resizable()
                    .frame(width: 130.0, height: 130.0)
                    .padding(.bottom, 20)
                    .cornerRadius(10)
                
                Text("What would you like to say today?")

                NavigationLink {
                    ZStack {
//                        SelectPaperView(paperVm: paperVm)
//                        ContentView()
                    }
                    .ignoresSafeArea()
                    .navigationBarBackButtonHidden(true)
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color(red: (136/255), green: 85/255, blue: 212/255))
                            .frame(width: 250, height: 48)
                        HStack {
                            Image(systemName: "paperplane")
                            Text("CHOOSE YOUR PAPER!")
                        }
                        .foregroundColor(.white)
                    }
                }

            }
//            .onAppear {
//                self.paperVm.isPosted = false
//            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
