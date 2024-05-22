//
//  PrimaryButton.swift
//  HK
//
//  Created by Peter Kresanič on 13/12/2023.
//

import SwiftUI

enum ButtonRoles { case confirmation, option }

struct PrimaryButton: View {
    
    var title: String
    var buttonRole: ButtonRoles = .confirmation
    var isLoading: Bool?
    
    var body: some View {
        
        let opacity = isLoading ?? false ? 0.5 : 1.0
        
        Text(isLoading == true ? "Načítava sa..." : title)
            .font(.system(size: 20, weight: .semibold))
            .foregroundStyle(buttonRole == .confirmation ? .hkWhite : .hkBlack)
            .lineLimit(1)
            .padding(.vertical, 15)
            .frame(maxWidth: .infinity)
            .background(buttonRole == .confirmation ? Color.hkPurple.opacity(opacity) : Color.hkGray.opacity(opacity))
            .clipShape(.rect(cornerRadius: 20, style: .continuous))
            .padding(.horizontal, 15)
            
    }
    
}

