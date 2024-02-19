//
//  MainAppView.swift
//  BelajarSceneKit
//
//  Created by Daniel Bernard Sahala Simamora on 18/02/24.
//

import SwiftUI

struct MainAppView: View {
    
    @StateObject var vm = AppViewModel()
    @State private var isShowingSheet = false
    
    var body: some View {
        ZStack {
            if vm.isShowingWelcomeView {
                NavigationView {
                    ZStack {
                        Color.white.ignoresSafeArea()
                        
                        VStack {
                            Image("cartaladaicon")
                                .resizable()
                                .frame(width: 160.0, height: 160.0)
                                .padding(18)
                                .background(Color.iconBackground)
                                .cornerRadius(15)
                                .padding(.bottom, 20)
                                .padding(.top, -50)
                            
                            Text("What would you like\n to post today?")
                                .foregroundStyle(.black)
                                .font(.system(size: 23))
                                .fontWeight(.medium)
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 20)
                            
                            Button(action: {
                                self.isShowingSheet = true
                            }, label: {
                                HStack {
                                    Image(systemName: "paperplane.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 23, height: 23)
                                    Text("CHOOSE YOUR PAPER!")
                                        .font(.system(size: 18))
                                        .fontWeight(.semibold)
                                }
                                .foregroundColor(.white)
                                .padding(15)
                                .background(Color.customPurple)
                                .cornerRadius(20)
                                .shadow(radius: 5, y: 4)
                            })
                        }
                    }
                    .sheet(isPresented: $isShowingSheet, content: {
                        SelectPaperView(isShowingSheet: $isShowingSheet, vm: vm)
                    })
                }
            } else {
                ARViewContainer(vm: vm)
                
                if !vm.didFinishPosting {
                    ControlView(vm: vm)
                } else {
                    VStack {
                        Spacer()
                        
                        VStack {
                            Text("DONE!")
                                .foregroundStyle(.black)
                                .font(.system(size: 45))
                                .fontWeight(.bold)
                            
                            Text("Your paper plane has been posted")
                                .foregroundStyle(.black)
                            
                            Button(action: {
                                vm.isShowingWelcomeView = true
                                vm.didFinishPosting = false
                                vm.paperSize = .small
                                vm.paperSizes[0].isClicked = true
                                vm.paperSizes[1].isClicked = false
                                vm.paperSizes[2].isClicked = false
                                
                            }, label: {
                                Label("Create Again", systemImage: "repeat")
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color.customPurple)
                                    .cornerRadius(10)
                            })
                            .padding(.top, 20)
                        }
                        .frame(width: 310, height: 200)
                        .background(Color.primaryPink.opacity(0.7))
                        .cornerRadius(20)
                        .padding(.bottom, 50)
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct MainAppView_Previews: PreviewProvider {
    static var previews: some View {
        MainAppView()
    }
}
