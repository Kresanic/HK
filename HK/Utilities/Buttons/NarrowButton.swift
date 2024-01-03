//
//  NarrowButton.swift
//  HK
//
//  Created by Peter Kresanič on 19/12/2023.
//

import SwiftUI

struct NarrowButton: View {
    
    var title: String
    var sfSymbol: String? = nil
    var buttonRole: ButtonRoles
    
    var body: some View {
        
        HStack(spacing: 5) {
            
            Text(title)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(buttonRole == .confirmation ? Color.hkWhite : Color.hkBlack)
                .padding(.vertical, 12)
            
            if let sfSymbol {
                Image(systemName: sfSymbol)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(buttonRole == .confirmation ? Color.hkWhite : Color.hkBlack)
                    
            }
            
        }.padding(.horizontal, 15)
            .frame(maxWidth: .infinity)
            .background(buttonRole == .confirmation ? Color.hkPurple : Color.hkGray)
            .clipShape(.rect(cornerRadius: 14, style: .continuous))
    }
    
}

