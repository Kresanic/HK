//
//  TabView.swift
//  HK
//
//  Created by Peter Kresanič on 08/12/2023.
//
import SwiftUI

enum TabViews {
    
    case home, clients, catalogue
    
    var readable: String {
        switch self {
        case .home:
            return "Domov"
        case .clients:
            return "Klienti"
        case .catalogue:
            return "Katalóg"
        }
    }
    
    var sfSymbol: (String, String) {
        switch self {
        case .home:
            return ("house", "house.fill")
        case .clients:
            return ("person.2", "person.2.fill")
        case .catalogue:
            return ("list.bullet.rectangle", "list.bullet.rectangle.fill")
        }
    }
    
}

struct RootView: View {
    
    @EnvironmentObject var behaviours: Behaviours
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            switch behaviours.activeTab {
            case .home:
                HomeScreen()
            case .clients:
                ClientsScreen()
            case .catalogue:
                CatalogueScreen()
            }
            
            CustomTabView()
            
        }
        .ignoresSafeArea()
        .overlay {
            if behaviours.isGettingHKItem {
                Color.hkBlack.opacity(0.4)
                    .blur(radius: 7)
                    .ignoresSafeArea()
            }
        }
        .overlay {
            if behaviours.isShowingSettings {
                SettingsView().transition(.move(edge: .top))
            }
        }
            .fullScreenCover(isPresented: $behaviours.isAskingForEmployeeID) { InsertEmployeeIdView() }
            .task {
                try? await behaviours.employeeLoad()
                print("ID:", behaviours.employeeID)
            }
    }
    
}


