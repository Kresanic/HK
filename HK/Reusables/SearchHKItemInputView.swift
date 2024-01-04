//
//  SearchHKItemInputView.swift
//  HK
//
//  Created by Peter Kresanič on 04/01/2024.
//

import SwiftUI

struct SearchHKItemInputView: View {
    
    @FocusState var focusedTextField: Bool
    @State var inputedCode = ""
    @EnvironmentObject var behaviours: Behaviours
    
    var body: some View {
        
        VStack {
            
            Text("Zadajte kód")
                .font(.system(size: 30, weight: .semibold))
                .foregroundStyle(.hkBlack)
                .padding(.bottom, 10)
            
            Text("Kód vedľa QR kódu. Na nálepke je HK0000X, stačí zadať X. Napríklad, ak je tam HK00004, stačí zadať 4.")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.hkBlack)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 15)
                .padding(.bottom, 15)
            
            TextField("4", text: $inputedCode)
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(.hkBlack)
                .focused($focusedTextField)
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .padding(.vertical, 15)
                .background(Color.hkWhite)
                .clipShape(.rect(cornerRadius: 20, style: .continuous))
                .shadow(color: .hkBlack.opacity(0.15), radius: 5)
                .padding(.horizontal, 15)
                .task { focusedTextField = true }
                
            Button {
                withAnimation { behaviours.isGettingHKItem = true }
                Task {
                    do {
                        try await behaviours.handleIncomingHKItemID(inputedCode)
                    } catch {
                        behaviours.isInputingHKItemID = false
                        behaviours.isGettingHKItem = false
                        print(error.localizedDescription)
                    }
                }
            } label: {
                PrimaryButton(title: "Nájsť!", isLoading: behaviours.isGettingHKItem)
                    .padding(.top, 15)
            }
            
        }.padding(15)
            .padding(.bottom, 10)
            .frame(maxWidth: .infinity)
                .background { Color.hkWhite.clipShape(.rect(cornerRadius: 40, style: .continuous)).padding(.horizontal, 15) }
                .ignoresSafeArea()
                .presentationDetents([.height(325)])
                .presentationCornerRadius(0)
                .presentationBackground(.clear)
                .presentationBackgroundInteraction(.disabled)
    }
    
}

