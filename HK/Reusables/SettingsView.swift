//
//  SettingsView.swift
//  HK
//
//  Created by Peter Kresanič on 13/12/2023.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var behaviours: Behaviours
    
    var body: some View {
        
        VStack {
            
            HStack(alignment: .center) {
                
                Text("Nastavenia")
                    .font(.screenTitle)
                    .foregroundStyle(.hkBlack)
                
                Spacer()
                
                Button { behaviours.toggleShowSettings(to: false) } label: {
                    Image(systemName: "chevron.up")
                        .font(.system(size: 25))
                        .foregroundStyle(.hkBlack)
                        .frame(width: 45, height: 45)
                }
            }
            
            if let employee = behaviours.employee {
                Text(employee.initials)
                    .font(.system(size: 55, weight: .semibold))
                    .foregroundStyle(.hkBlack)
                    .padding(25)
                    .background(.hkGray)
                    .clipShape(.circle)
                
                Text(employee.wholeName)
                    .font(.system(size: 23, weight: .semibold))
                    .foregroundStyle(.hkBlack)
                    .padding(.top, 5)
                
                Text(employee.unwrappedEmployeeID)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.hkBlack)
                
                Button {
                    behaviours.toggleShowSettings(to: false)
                    behaviours.removeEmployee()
                } label: {
                    Text("Zmeniť používateľa")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.hkBlack)
                        .underline()
                        .padding(.top, 3)
                }
                
            }
            
            Spacer()
            
            Text("Čoskoro...")
            
            Spacer()
            
            Text("HK")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.hkBlack)
                .padding(.top, 15)
            
            Text("v\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0")")
                .font(.system(size: 19, weight: .semibold))
                .foregroundColor(.hkDarkGray)
                .padding(.bottom, 5)
            
            Text("©Hydrokres, s.r.o. All rights reserved.")
                .font(.system(size: 12))
                .foregroundColor(.hkDarkGray)
                .multilineTextAlignment(.center)
                .padding(.bottom, 15)
            
        }.padding(.horizontal, 15)
            .frame(maxWidth: .infinity)
            .background(.hkWhite)
            .offset(y: behaviours.isShowingSettings ? 0 : -50)
            
        
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
