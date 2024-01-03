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
        
        Text(isLoading == true ? "Načítava sa..." : title)
            .font(.system(size: 20, weight: .semibold))
            .foregroundStyle(.hkWhite)
            .minimumScaleFactor(0.6)
            .lineLimit(1)
            .padding(.vertical, 15)
            .frame(maxWidth: .infinity)
            .background(isLoading == true ? Color.hkPurple.opacity(0.5) : Color.hkPurple)
            .clipShape(.rect(cornerRadius: 20, style: .continuous))
            .padding(.horizontal, 15)
            
        
    }
}

