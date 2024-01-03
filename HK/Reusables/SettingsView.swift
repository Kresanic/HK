//
//  SettingsView.swift
//  HK
//
//  Created by Peter Kresanič on 13/12/2023.
//

import SwiftUI

struct SettingsView: View {
    
    var body: some View {
        
        VStack {
            
            
            
            Text("HK")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.hkBlack)
                .padding(.top, 15)
            
            Text("v\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0")")
                .font(.system(size: 19, weight: .semibold))
                .foregroundColor(.hkBlack.opacity(0.7))
                .padding(.bottom, 5)
            
            Text("©Hydrokres, s.r.o. All rights reserved.")
                .font(.system(size: 12))
                .foregroundColor(.hkGray)
                .multilineTextAlignment(.center)
            
        }.padding(.horizontal, 15)
        
    }
    
}

fileprivate struct PerosnalInfoView: View {
    
    @EnvironmentObject var behaviours: Behaviours
    
    var body: some View {
        
        
        HStack {
            
//            Text(behaviours.initialOfCode(code: behaviours.userCode))
//                .font(.system(size: 20, weight: .semibold))
//                .foregroundStyle(.hkBlack)
//                .padding(8)
//                .background(.hkGray)
//                .clipShape(.circle)
//                .padding(.leading, 4)
            
            
            VStack {
                
                Text("Peter Kresanič")
                
                
            }
            
            
        }
        
    }
    
}
