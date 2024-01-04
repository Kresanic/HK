//
//  ScreenHeadingView.swift
//  HK
//
//  Created by Peter Kresanič on 13/12/2023.
//

import SwiftUI

struct ScreenHeadingView: View {
    
    @EnvironmentObject var behaviours: Behaviours
    var tabView: TabViews
    var buttons: [ScreenHeadingButton] = []
    
    var body: some View {
        
        HStack(alignment: .center) {
            
            Text(tabView.readable)
                .font(.screenTitle)
                .foregroundStyle(.hkBlack)
            
            Spacer()
            
            ForEach(buttons) { button in
                ScreenHeadingButtonView(button: button)
            }
                
            if let employee = behaviours.employee {
                Text(employee.initials)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.hkBlack)
                    .padding(8)
                    .background(.hkGray)
                    .clipShape(.circle)
                    .padding(.leading, 4)
                    .onTapGesture { behaviours.toggleShowSettings(to: true) }
            }
            
        }
        .padding(.bottom, 3)
        .padding(.horizontal, 15)
        .padding(.top, 75)
            .background(Color.hkWhite.opacity(0.75))
            .background(.ultraThinMaterial)
        
    }
        
}

struct ScreenHeadingMod: ViewModifier {
    
    var tabView: TabViews
    var buttons: [ScreenHeadingButton] = []
    
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                ScreenHeadingView(tabView: tabView, buttons: buttons)
            }
    }
    
}

struct ScreenHeadingButton: Identifiable {
    
    let id = UUID()
    let sfSymbol: String
    let action: () -> ()
    
}

fileprivate struct ScreenHeadingButtonView: View {
    
    let button: ScreenHeadingButton
    
    var body: some View {
        
        Button {
            button.action()
        } label: {
            Image(systemName: button.sfSymbol)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.hkWhite)
                .padding(5)
                .background(.hkBlack)
                .clipShape(.circle)
                .frame(width: 28, height: 35)
        }
        
    }
    
}

#Preview {
    VStack {
        ScreenHeadingView(tabView: .home, buttons: [
            .init(sfSymbol: "trash", action: { print("trash") }),
            .init(sfSymbol: "plus", action: { print("skap") })
        ])
        Spacer()
    }.padding(.horizontal, 15)
}
