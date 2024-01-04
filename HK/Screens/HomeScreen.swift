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
