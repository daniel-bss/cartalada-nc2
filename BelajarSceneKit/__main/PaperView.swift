//
//  PaperView.swift
//  BelajarSceneKit
//
//  Created by Daniel Bernard Sahala Simamora on 26/05/23.
//

import SwiftUI

struct PaperView: View {
    @Binding var isShowingSheet: Bool
    
    @ObservedObject var vm: AppViewModel
    @State var words: String = ""
    
    var body: some View {
        VStack {
            ZStack {
                TextEditor(text: $words)
                    .scrollContentBackground(.hidden)
                    .padding()
                    .foregroundColor(.black)
                    .background(vm.paperColor)
                    .frame(width: 350, height: 350)
                    .font(.system(size: 36))
            }
            Button(action: {
                self.updateViewModel()
            }, label: {
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
            })
            
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    self.isShowingSheet = false
                } label: {
                    Text("Cancel")
                }
            }
        }
    }
    
    private func updateViewModel() {
        vm.words = words
        self.isShowingSheet = false
        
        // NOW CHANGE TO ARVIEW
        vm.isShowingWelcomeView = false
    }
    
}

struct PaperView_Previews: PreviewProvider {
    static var previews: some View {
        PaperView(isShowingSheet: .constant(true), vm: AppViewModel())
    }
}
