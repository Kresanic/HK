//
//  NewItemsSheet.swift
//  HK
//
//  Created by Peter Kresanič on 23/12/2023.
//

import SwiftUI

struct NewItemsSheet: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        ScrollView {
            
            VStack {
                
                
                
            }.frame(maxWidth: .infinity)
            
        }.scrollIndicators(.hidden)
        .overlay(alignment: .topLeading) {
            Button { dismiss() } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 24, weight: .regular))
                    .foregroundStyle(.hkDarkGray)
                    .padding(20)
            }
        }
        .overlay(alignment: .bottom) {
            Button { dismiss() } label: {
                PrimaryButton(title: "Uložiť nové produkty", buttonRole: .confirmation)
            }
        }
        
    }
    
}

