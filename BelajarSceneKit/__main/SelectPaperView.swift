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
                VStack {
                    Text("Choose your paper plane color!")
                        .font(.headline)
                        .fontWeight(.heavy)
                    
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
                    .padding(.bottom, 25)
                }
                
                ForEach(listOfPapers) { paper in
                    if paper.isClicked {
                        NavigationLink {
                            PaperView(isShowingSheet: $isShowingSheet, vm: vm)
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(Color.customPurple)
                                    .frame(width: 130, height: 48)
                                HStack {
                                    Image(systemName: "pencil.and.outline")
                                    Text("WRITE!")
                                }
                                .foregroundColor(.white)
                            }
                        }
                    }
                }
                .offset(y: 160)
                
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
