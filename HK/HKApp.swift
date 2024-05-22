//
//  HKApp.swift
//  HK
//
//  Created by Peter Kresanič on 01/12/2023.
//

import SwiftUI
import Sentry


@main
struct HKApp: App {
    init() {
        SentrySDK.start { options in
            options.dsn = "https://66dd3a41241ff08c27f67cf41e5f8b63@o4507211110875136.ingest.de.sentry.io/4507211147182160"
            options.debug = true // Enabled debug when first installing is always helpful
            options.enableTracing = true 

            // Uncomment the following lines to add more data to your events
            // options.attachScreenshot = true // This adds a screenshot to the error events
            // options.attachViewHierarchy = true // This adds the view hierarchy to the error events
        }
        // Remove the next line after confirming that your Sentry integration is working.
        SentrySDK.capture(message: "This app uses Sentry! :)")
    }
    
    @StateObject var behaviours = Behaviours()
    @StateObject var scanning = Scanning()
    
    var body: some Scene {
        
        WindowGroup {
            RootView()
                .environmentObject(behaviours)
                .environmentObject(scanning)
                .onOpenURL { incomingURL in
                    //hydrokresItem://find-item?HKItemID=HK00001
                    Task { await behaviours.handleIncomingDeepLink(incomingURL) }
                }
                .task { await behaviours.loadHKCategories() }
        }
        
    }
    
}
