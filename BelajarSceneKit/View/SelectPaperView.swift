//
//  SelectPaperView.swift
//  BelajarSceneKit
//
//  Created by Daniel Bernard Sahala Simamora on 26/05/23.
//

import SwiftUI

struct ChoosePapers: Identifiable {
    var id: UUID = UUID()
    
    var color: Color
    var isClicked: Bool
}

struct SelectPaperView: View {
    @ObservedObject var paperVm: PaperViewModel
    let size: Double = 95
    
    @State var listOfPapers = [
        ChoosePapers(color: .primaryBlue, isClicked: false),
        ChoosePapers(color: .primaryGreen, isClicked: false),
        ChoosePapers(color: .primaryPink, isClicked: false),
        ChoosePapers(color: .primaryLightGreen, isClicked: false),
        ChoosePapers(color: .primaryLightBlue, isClicked: false),
        ChoosePapers(color: .primaryYellow, isClicked: false)
    ]
    
    @State var selectedColor: Color = .black
    
    var body: some View {
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
                                self.selectedColor = listOfPapers[i].color
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
                                self.selectedColor = listOfPapers[i].color

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
            
            ForEach(listOfPapers) { paper in
                if paper.isClicked {
                    NavigationLink {
                        PaperView(paperVm: paperVm, paperColor: self.selectedColor)
                            .navigationBarBackButtonHidden()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color(red: (136/255), green: 85/255, blue: 212/255))
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
            
            
            
//            NavigationLink {
//                ZStack {
//                    ARViewContainer(translationY: $translationY, rotation: $rotation, planeTranslation: $planeTranslation, cilorVm: cilorVm)
//                    ControlView(translationY: $translationY, rotation: $rotation, planeTranslation: $planeTranslation)
//                }
//                .ignoresSafeArea()
//                .navigationBarBackButtonHidden(true)
//            } label: {
//                HStack {
//                    Image(systemName: "computermouse")
//                    Text("Click Me!")
//                }
//            }
            
        }
    }
}
//
//struct SelectPaperView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectPaperView()
//    }
//}
