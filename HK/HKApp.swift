//
//  HKApp.swift
//  HK
//
//  Created by Peter Kresanič on 01/12/2023.
//

import SwiftUI

@main
struct HKApp: App {
    
    @StateObject var behaviours = Behaviours()
    
    var body: some Scene {
        
        WindowGroup {
            RootView()
                .environmentObject(behaviours)
                .onOpenURL { incomingURL in
                    Task {
                        behaviours.toggleIsisGettingHKItem(to: true)
                        do {
                            try await behaviours.handleIncomingDeepLink(incomingURL)
                            behaviours.toggleIsisGettingHKItem(to: false)
                        } catch {
                            behaviours.toggleIsisGettingHKItem(to: false)
                            print(error.localizedDescription)
                        }
                    }
                }
        }
        
    }
    
}
