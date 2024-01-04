//
//  CatalogueScreen.swift
//  HK
//
//  Created by Peter Kresanič on 19/12/2023.
//

import SwiftUI

struct CatalogueScreen: View {
    
    var body: some View {
        
        ScrollView {
            
            VStack {
                
                ForEach(0..<100) { num in
                    Text("Čoskoro...")
                }
                
            }.headingAndTabPadding()
            
        }.scrollIndicators(.hidden)
            .padding(.horizontal, 15)
            .screenHeading(tabView: .catalogue)
        
    }
    
}

