//
//  PaperView.swift
//  BelajarSceneKit
//
//  Created by Daniel Bernard Sahala Simamora on 26/05/23.
//

import SwiftUI
import Combine

enum FormTextField {
    case focus
}

struct WritePaperView: View {
    @Binding var isShowingSheet: Bool
    @FocusState var focusedTextField: FormTextField?
    
    @ObservedObject var vm: AppViewModel
    @State var words: String = ""
    @State var isCharLimitReached = false
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
                .onAppear {
                    focusedTextField = .focus
                }
            
            VStack {
                HStack {
                    Text("✏️ Let's write!")
                        .foregroundStyle(.black)
                        .font(.system(size: 28))
                        .fontWeight(.semibold)
                        .padding()
                    Spacer()
                }
                .padding(.bottom, -25)
                
                Text("Maximum characters limit reached!")
                    .foregroundStyle(isCharLimitReached ? .red : .clear)
                    .font(.system(size: 13))
                    .padding(.bottom, -5)
                
                ZStack {
                    TextEditor(text: $words)
                        .autocorrectionDisabled()
                        .focused($focusedTextField, equals: .focus)
                        .scrollContentBackground(.hidden)
                        .padding()
                        .foregroundColor(.black)
                        .background(vm.paperColor)
                        .frame(width: 350, height: 350)
                        .font(.system(size: getFontSize())) // b ke 8
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Button("Done") {
                                    focusedTextField = nil
                                }
                            }
                        }
                        .shadow(color: .clear, radius: 0)
                        .onReceive(Just(words)) { words in
                            limitText(words)
                        }
                }
                .shadow(radius: 10, y: 7)
                .padding(.bottom, 15)
                
                
                Button(action: {
                    self.updateViewModel()
                    focusedTextField = nil
                    print(words.count)
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
        
        // NOW CHANGE TO ARVIEW (HIDE WELCOME VIEW)
        vm.isShowingWelcomeView = false
    }
    
    private func getFontSize() -> CGFloat {
        switch vm.paperSize {
        case .small:
            return 34 // b 4
        case .medium:
            return 26 // b 8
        case .large:
            return 22 // a 2
        }
    }
    
    private func limitText(_ words: String) {
        var charLimit: Int = 0
        
        switch vm.paperSize {
        case .small:
            charLimit = 125
        case .medium:
            charLimit = 195
        case .large:
            charLimit = 305
        }
        
        if words.count < charLimit {
            isCharLimitReached = false
        } else {
            isCharLimitReached = true
            self.words = String(words.prefix(charLimit))
        }
    }
    
}

struct PaperView_Previews: PreviewProvider {
    static var previews: some View {
        WritePaperView(isShowingSheet: .constant(true), vm: AppViewModel())
    }
}
