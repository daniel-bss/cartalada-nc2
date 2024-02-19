//
//  PaperView.swift
//  BelajarSceneKit
//
//  Created by Daniel Bernard Sahala Simamora on 26/05/23.
//

import SwiftUI

enum FormTextField {
    case focus
}

struct WritePaperView: View {
    @Binding var isShowingSheet: Bool
    @FocusState var focusedTextField: FormTextField?
    
    @ObservedObject var vm: AppViewModel
    @State var words: String = ""
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
                .onAppear {
                    focusedTextField = .focus
                }
            
            VStack {
                HStack {
                    Text("✏️ Let's write!")
                        .font(.system(size: 28))
                        .fontWeight(.semibold)
                        .padding()
                    Spacer()
                }
                
                ZStack {
                    TextEditor(text: $words)
                        .autocorrectionDisabled()
                        .focused($focusedTextField, equals: .focus)
                        .scrollContentBackground(.hidden)
                        .padding()
                        .foregroundColor(.black)
                        .background(vm.paperColor)
                        .frame(width: 350, height: 350)
                        .font(.system(size: 36))
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Button("Done") {
                                    focusedTextField = nil
                                }
                            }
                        }
                }
                .shadow(radius: 10, y: 7)
                .padding(.bottom, 15)
                
                
                Button(action: {
                    self.updateViewModel()
                    focusedTextField = nil
                }, label: {
                    HStack {
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                        Text("CREATE!")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding(15)
                    .padding(.horizontal, 15)
                    .background(Color.customPurple)
                    .cornerRadius(22)
                    .shadow(radius: 5, y: 4)
                    .padding(.bottom, 20)
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
        WritePaperView(isShowingSheet: .constant(true), vm: AppViewModel())
    }
}
