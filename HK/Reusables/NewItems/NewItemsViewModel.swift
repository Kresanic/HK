//
//  NewItemsViewModel.swift
//  HK
//
//  Created by Peter Kresanič on 01/02/2024.
//

import SwiftUI

@MainActor final class NewItemsViewModel: ObservableObject {
  
    @Published var isScanningQRCode = false
    @Published var selectedType: HKCatalogueItem? {
        didSet {
            if selectedType != nil {
                isSelectingType = false
            }
        }
    }
    @Published var isSelectingType = false
    
    
    func saveAllCodes(itemIDs: [HKItemID]) async throws {
        
        print("went to ratata")
        if let selectedType {
            print("went to saveAll")
            try await CloudKitManager.shared.addNewItems(catalogueItem: selectedType, itemIDs: itemIDs)
        }
        
    }
    
    
//    @Published var isInputingHKItemID = false
//    @Published var isFetchingHKItem = false
//    @Published var shownHKItem: HKItem? = nil
//    @Published var failedMessage: String?
//    @Published var isAddingNewItems = false
    
    
//    private func retrievalOfHKItem(_ itemID: HKItemID) async {
//        
//        let impactMed = UIImpactFeedbackGenerator(style: .heavy)
//        
//        do {
//            let hkItem = try await CloudKitManager.shared.getItem(itemID: itemID)
//            openHKItem(hkItem)
//            impactMed.impactOccurred()
//        } catch {
//            
//            if let itemError = error as? ItemErrors {
//                switch itemError {
//                case .notCreated:
////                    addItemIDToRegister(itemID)
//                    impactMed.impactOccurred()
//                case .mockUpID:
//                    failedToRetrieve(fetchFail: false)
//                    impactMed.impactOccurred()
//                case .failedFetching:
//                    failedToRetrieve(fetchFail: true)
//                    impactMed.impactOccurred()
//                }
//            }
//            
//        }
//        
//    }
//    
//    private func openHKItem(_ retrievedHKItem: HKItem) {
//        closeHKItemAllInputs()
//        shownHKItem = retrievedHKItem
//    }
//    
//    private func switchFetchingStatus(_ value: Bool) {
//        withAnimation {
//            isFetchingHKItem = value
//        }
//    }
    
//    private func addItemIDToRegister(_ hkItemID: HKItemID) {
//        closeHKItemAllInputs()
//        withAnimation(.default.delay(0.3)) {
//            itemIDsToBeRegistered.append(hkItemID)
//        }
//    }
//    
//    private func failedToRetrieve(fetchFail: Bool) {
//        withAnimation {
//            switchFetchingStatus(false)
//            if fetchFail {
//                failedMessage = "Niečo sa pokazilo."
//            } else {
//                failedMessage = "Nesprávny kód."
//            }
//        }
//    }
//    
//    private func closeHKItemAllInputs() {
//        withAnimation {
//            isInputingHKItemID = false
//            isScanningQRCode = false
//            switchFetchingStatus(false)
//        }
//    }
//    
//    func handleIncomingDeepLink(_ url: URL) async {
//        switchFetchingStatus(true)
//        let itemID = HKItemID(deepLink: url)
//        await retrievalOfHKItem(itemID)
//        if !itemIDsToBeRegistered.isEmpty {
//            isAddingNewItems = true
//        }
//    }
//    
//    func handleIncomingScan(
//    
//    func handleIncomingItemID(_ numberID: String) async {
//        switchFetchingStatus(true)
//        let itemID = HKItemID(numberID: numberID)
//        await retrievalOfHKItem(itemID)
//    }
//    
    
    
    
}
