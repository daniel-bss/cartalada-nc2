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
                    VStack {
                        Image("cartaladaicon")
                            .resizable()
                            .frame(width: 130.0, height: 130.0)
                            .cornerRadius(10)
                            .padding(.bottom, 20)
                        
                        Text("What would you like to post today?")
                        
                        Button(action: {
                            self.isShowingSheet = true
                        }, label: {
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
                        })
                    }
                    .sheet(isPresented: $isShowingSheet, content: {
                        SelectPaperView(isShowingSheet: $isShowingSheet, vm: vm)
                    })
                }
            } else {
                ARViewContainer(vm: vm)
//                Rectangle()
//                    .foregroundColor(.black.opacity(0.2))
                
                if !vm.didFinishPosting {
                    ControlView(vm: vm)
                } else {
                    VStack {
                        Spacer()
                        
                        VStack {
                            Text("DONE!")
                                .font(.system(size: 45))
                                .fontWeight(.bold)
                            
                            Text("Your paper plane has been posted")
                            
                            Button(action: {
                                vm.isShowingWelcomeView = true
                                vm.didFinishPosting = false
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
