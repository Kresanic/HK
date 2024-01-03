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
                
                if let employee = behaviours.employee, let employeeFirstName = employee.firstName {
                    Text(employeeFirstName)
                }
                ForEach(0..<100) { num in
                    Text("\(num) domov")
                }
                
            }.background(.pink)
            .headingAndTabPadding()
            
        }.scrollIndicators(.hidden)
        .padding(.horizontal, 15)
            .screenHeading(tabView: .home)
        
    }
    
}

#Preview {
    HomeScreen()
}
