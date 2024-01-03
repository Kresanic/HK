//
//  SecondaryButton.swift
//  HK
//
//  Created by Peter Kresanič on 17/12/2023.
//

import SwiftUI

struct SecondaryButton: View {
    
    var title: String
    var buttonRole: ButtonRoles = .confirmation
    
    var body: some View {
        
        Text(title)
            .font(.system(size: 15, weight: .semibold))
            .foregroundStyle(.hkBlack)
            .minimumScaleFactor(0.6)
            .lineLimit(1)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(Color.hkGray)
            .clipShape(.rect(cornerRadius: 16, style: .continuous))
            .padding(.horizontal, 30)
            
        
    }
}
