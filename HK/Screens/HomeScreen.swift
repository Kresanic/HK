//
//  HomeScreen.swift
//  HK
//
//  Created by Peter Kresanič on 13/12/2023.
//

import SwiftUI

struct HomeScreen: View {
    
    @EnvironmentObject var behaviours: Behaviours
    
    var body: some View {
        
        ScrollView {
            
            VStack {
                
                ForEach(0..<100) { num in
                    Text("Čoskoro...")
                        .foregroundStyle(.hkWhite)
                        .frame(height: 150)
                        .frame(maxWidth: .infinity)
                        .background(.hkGray)
                        .clipShape(.rect(cornerRadius: 30, style: .continuous))
//                        .shadow(color: Color.hkBlack.opacity(0.4),radius: 2)
                }
                
            }.headingAndTabPadding()
            
        }.scrollIndicators(.hidden)
        .padding(.horizontal, 15)
            .screenHeading(tabView: .home)
        
    }
    
}

#Preview {
    HomeScreen()
}
