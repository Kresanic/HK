//
//  TabView.swift
//  HK
//
//  Created by Peter Kresanič on 08/12/2023.
//
import SwiftUI
import CodeScanner
import SentrySwiftUI

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
    @EnvironmentObject var scanning: Scanning
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            switch behaviours.activeTab {
            case .home:
                HomeScreen().sentryTrace("Home Screen")
            case .clients:
                ClientsScreen().sentryTrace("Clients Screen")
            case .catalogue:
                CatalogueScreen().sentryTrace("Catalogue Screen")
            }
            
            CustomTabView()
            
        }
        .ignoresSafeArea()
        .overlay {
            if behaviours.isFetchingHKItem {
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
//            .fullScreenCover(isPresented: $behaviours.isConnectingToClient) { ConnectClientToProductsView() }
            .fullScreenCover(isPresented: $behaviours.isAddingNewItems) {
                NewItemsSheet()
                    .statusBarHidden()
                    .onDisappear { behaviours.itemIDsToBeRegistered = []; behaviours.isAddingNewItems = false }
            }
            .sheet(isPresented: $behaviours.isScanning) {
                ScanView()
                    .onDisappear {
                        if behaviours.previewedHKItem != nil {
                            behaviours.isPreviewingHKItem = true
                        } else if !behaviours.itemIDsToBeRegistered.isEmpty {
                            behaviours.isAddingNewItems = true
                        }
                    }
            }
            .sheet(isPresented: $behaviours.isPreviewingHKItem) {
                if let hkItem = behaviours.previewedHKItem {
                    ItemPreview(hkItem: hkItem)
                        .presentationCornerRadius(25)
                        .onDisappear { behaviours.previewedHKItem = nil; behaviours.isPreviewingHKItem = false }
                }
            }
            .task {
                try? await behaviours.employeeLoad()
                print("ID:", behaviours.employeeID)
            }
        
    }
    
//    func handleIncomingScan(result: Result<ScanResult, ScanError>) {
//        behaviours.isScanning = false
//        switch result {
//        case .success(let data):
//            Task {
//                if let itemURL = URL(string: data.string) {
//                    await behaviours.handleIncomingDeepLink(itemURL)
//                }
//            }
//        case .failure(_):
//            print("Could not scan successfully.")
//        }
//    }
    
}


