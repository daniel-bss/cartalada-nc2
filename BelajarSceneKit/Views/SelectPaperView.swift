//
//  SelectPaperView.swift
//  BelajarSceneKit
//
//  Created by Daniel Bernard Sahala Simamora on 26/05/23.
//

import SwiftUI

struct SelectPaperView: View {
    
    @Binding var isShowingSheet: Bool
    
    @ObservedObject var vm: AppViewModel
    
    let size: Double = 95
    @State var listOfPapers = [
        ChoosePaper(color: .primaryBlue, isClicked: false),
        ChoosePaper(color: .primaryGreen, isClicked: false),
        ChoosePaper(color: .primaryPink, isClicked: false),
        ChoosePaper(color: .primaryLightGreen, isClicked: false),
        ChoosePaper(color: .primaryLightBlue, isClicked: false),
        ChoosePaper(color: .primaryYellow, isClicked: false)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()
                
                VStack(spacing: 25) {
                    Text("Choose your paper plane color!")
                        .foregroundStyle(.black)
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                    
                    VStack {
                        HStack {
                            ForEach((0...2), id: \.self) { i in
                                Rectangle()
                                    .fill(listOfPapers[i].color)
                                    .frame(width: size, height: size)
                                    .shadow(radius: listOfPapers[i].isClicked ? 25 : 0)
                                    .padding(.trailing, (i == 2 ? 0 : 10))
                                    .onTapGesture {
                                        self.listOfPapers[i].isClicked.toggle()
                                        
                                        DispatchQueue.main.async {
                                            vm.paperColor = listOfPapers[i].color
                                        }
                                        for j in 0...5 {
                                            if j != i {
                                                self.listOfPapers[j].isClicked = false
                                            }
                                        }
                                    }
                            }
                        }
                        
                        HStack {
                            ForEach((3...5), id: \.self) { i in
                                Rectangle()
                                    .fill(listOfPapers[i].color)
                                    .frame(width: size, height: size)
                                    .shadow(radius: listOfPapers[i].isClicked ? 25 : 0)
                                    .padding(.trailing, (i == 5 ? 0 : 10))
                                    .onTapGesture {
                                        self.listOfPapers[i].isClicked.toggle()
                                        
                                        DispatchQueue.main.async {
                                            vm.paperColor = listOfPapers[i].color
                                        }
                                        
                                        for j in 0...5 {
                                            if j != i {
                                                self.listOfPapers[j].isClicked = false
                                            }
                                        }
                                    }
                            }
                        }
                    }
                    .padding(.bottom, 65)
                }
                
                ForEach(listOfPapers) { paper in
                    if paper.isClicked {
                        NavigationLink {
                            SelectPaperSizeView(isShowingSheet: $isShowingSheet, vm: vm)
                        } label: {
                            HStack {
                                Text("NEXT")
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(.white)
                            .padding(10)
                            .padding(.horizontal, 20)
                            .background(Color.customPurple)
                            .cornerRadius(13)
                            .shadow(radius: 2, y: 4)
                        }
                    }
                }
                .offset(y: 145)
                
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        self.isShowingSheet = false
                    } label: {
                        Text("Cancel")
                    }
                }
            }
        }
    }
}


struct SelectPaperView_Previews: PreviewProvider {
    static var previews: some View {
        SelectPaperView(isShowingSheet: .constant(false), vm: AppViewModel())
    }
}
