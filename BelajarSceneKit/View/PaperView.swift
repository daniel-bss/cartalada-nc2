//
//  PaperView.swift
//  BelajarSceneKit
//
//  Created by Daniel Bernard Sahala Simamora on 26/05/23.
//

import SwiftUI

struct PaperView: View {
    @ObservedObject var paperVm: PaperViewModel
    var paperColor: Color
    
    @State var words: String = ""
    
    var body: some View {
        VStack {
            ZStack {
                TextEditor(text: $words)
                    .scrollContentBackground(.hidden)
                    .padding()
                    .foregroundColor(.black)
                    .background(self.paperColor)
                    .frame(width: 350, height: 350)
                    .font(.system(size: 36))
                
            }
            
            NavigationLink {
                ContentView(paperVm: paperVm, paperColor: paperColor, words: words)
                    .navigationBarBackButtonHidden()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color(red: (136/255), green: 85/255, blue: 212/255))
                        .frame(width: 130, height: 48)
                    HStack {
                        Image(systemName: "paperplane.fill")
                        Text("CREATE!")
                    }
                    .foregroundColor(.white)
                }
            }
        }
        

    }
}

struct PaperView_Previews: PreviewProvider {
    static var previews: some View {
        PaperView(paperVm: PaperViewModel(), paperColor: .primaryBlue)
    }
}
