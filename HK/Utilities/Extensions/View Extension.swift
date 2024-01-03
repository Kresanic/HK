//
//  View Extension.swift
//  HK
//
//  Created by Peter Kresanič on 17/12/2023.
//

import SwiftUI

extension View {
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func screenHeading(tabView: TabViews, buttons: [ScreenHeadingButton] = []) -> some View {
        return modifier(ScreenHeadingMod(tabView: tabView, buttons: buttons))
    }
    
    func headingAndTabPadding() -> some View {
        return modifier(HeadingAndTabPadding())
    }
    
}

struct HeadingAndTabPadding: ViewModifier {
    
    @EnvironmentObject var behaviours: Behaviours
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding(.top, 130)
            .padding(.bottom, behaviours.activeTab == .home ? 155 : 105)
    }
    
}
