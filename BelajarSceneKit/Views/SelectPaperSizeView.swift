//
//  SelectPaperSizeView.swift
//  BelajarSceneKit
//
//  Created by Daniel Bernard Sahala Simamora on 19/02/24.
//

import SwiftUI

struct SelectPaperSizeView: View {
    
    @Binding var isShowingSheet: Bool
    
    @ObservedObject var vm: AppViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()
                    .onAppear {
                        for idx in 0..<vm.paperSizes.count {
                            vm.paperSizes[idx].color = vm.paperColor
                        }
                    }
                
                VStack {
                    HStack {
                        Text("Choose Paper Size")
                            .font(.system(size: 32))
                            .fontWeight(.semibold)
                            .padding(20)
                        Spacer()
                    }
                    .padding(.bottom, 30)
                    .padding(.top, -100)
                    
                    HStack(alignment: .bottom, spacing: 25) {
                        ForEach(0..<vm.paperSizes.count, id: \.self) { idx in
                            VStack(spacing: 3) {
                                Rectangle()
                                    .foregroundColor(vm.paperSizes[idx].color)
                                    .frame(width: vm.paperSizes[idx].frameSize, height: vm.paperSizes[idx].frameSize)
                                    .padding(.bottom, 10)
                                
                                    if vm.paperSizes[idx].frameSize == 75 {
                                        Text("Small")
                                            .font(.system(size: 18))
                                    } else if vm.paperSizes[idx].frameSize == 90 {
                                        Text("Medium")
                                            .font(.system(size: 18))
                                    } else {
                                        Text("Large")
                                            .font(.system(size: 18))
                                    }
                                
                                
                                HStack(spacing: 3) {
                                    Text("(\(vm.paperSizes[idx].realDimension)x\(vm.paperSizes[idx].realDimension) **cm**)")
                                        .font(.system(size: 18))
                                }
                            }
                            .shadow(
                                color: vm.paperSizes[idx].isClicked ? Color.customLightGray : Color.clear,
                                radius: 42,
                                y: 35
                            )
                            .onTapGesture {
                                for paperIdx in 0..<vm.paperSizes.count {
                                    if paperIdx == idx {
                                        vm.paperSizes[paperIdx].isClicked = true
                                        
                                        let paper = vm.paperSizes[paperIdx]
                                        if paper.frameSize == 75 {
                                            vm.paperSize = .small
                                        } else if paper.frameSize == 90 {
                                            vm.paperSize = .medium
                                        } else {
                                            vm.paperSize = .large
                                        }
                                        
                                    } else {
                                        vm.paperSizes[paperIdx].isClicked = false
                                    }
                                }
                            }
                        }
                        
                    }
                    .padding(.bottom, 35)
                    
                    NavigationLink {
                        WritePaperView(isShowingSheet: $isShowingSheet, vm: vm)
                    } label: {
                        HStack {
                            Image(systemName: "pencil.and.outline")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                            Text("WRITE!")
                                .font(.system(size: 20))
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .padding(15)
                        .padding(.horizontal, 15)
                        .background(Color.customPurple)
                        .cornerRadius(20)
                        .shadow(radius: 5, y: 4)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
        
    }
}

#Preview {
    SelectPaperSizeView(isShowingSheet: .constant(true), vm: AppViewModel())
}
