//
//  Behaviours.swift
//  HK
//
//  Created by Peter Kresanič on 08/12/2023.
//

import SwiftUI
import CodeScanner

@MainActor final class Behaviours: ObservableObject {
    
    // MARK: - GeneralBehaviour -
    @Published var activeTab: TabViews = .home
    @Published var isShowingSettings = false
    @Published var catalogueCategories: [HKCatalogueCategory] = []
    @Published var catalogueNavigation = NavigationPath()
    @Published var clientsNavigation = NavigationPath()

    func toggleShowSettings(to value: Bool?) {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
            if let value {
                isShowingSettings = value
            } else {
                isShowingSettings.toggle()
            }
        }
    }
    
    func loadHKCategories() async {
        
        do {
            let categories = try await CloudKitManager.shared.getHKCategories()
            withAnimation { catalogueCategories = categories }
        } catch {
            print(error)
        }
        
    }
    
    // MARK: - EmployeeManagement -
    @AppStorage("employeeID") var employeeID: String = ""
    @Published var employee: HKUser?
    @Published var isAskingForEmployeeID = false
    @Published var isGettingEmployee = false
    
    func employeeLoad() async throws {
        
        if employee == nil {
            
            if employeeID.isEmpty {
                isAskingForEmployeeID = true
            } else {
                do {
                    let employee = try await CloudKitManager.shared.getUser(employeeID: employeeID)
                    saveNewEmployee(employee: employee)
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        }
        
    }
    func saveNewEmployee(employee hkUser: HKUser?) {
        if let hkUser, hkUser.isFilled {
            withAnimation(.easeInOut(duration: 0.3)) {
                employeeID = hkUser.unwrappedEmployeeID
                employee = hkUser
                isAskingForEmployeeID = false
            }
            toggleIsGettingEmployee(to: false)
        }
    }
    func removeEmployee() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isAskingForEmployeeID = true
            employeeID = ""
            employee = nil
        }
    }
    func toggleIsGettingEmployee(to value: Bool? = nil) {
        withAnimation(.easeInOut(duration: 0.4)) {
            if let value {
                isGettingEmployee = value
            } else {
                isGettingEmployee.toggle()
            }
        }
    }
    
    
    // MARK: - Scanning -
    @Published var isScanning = false
    @Published var isCheckingExistence = false
    
    func checkForExistence(of itemID: HKItemID) async -> HKItem? {
        
        withAnimation { isCheckingExistence = true }
        
        let hkItem = try? await CloudKitManager.shared.getItem(itemID: itemID)
        
        withAnimation { isCheckingExistence = false }
        
        return hkItem
    }
    
//    func hideScanningAndOpenItem(of itemID: HKItemID) async {
//        
//        let hkItem = try? await CloudKitManager.shared.getItem(itemID: itemID)
//        
//        print(hkItem)
//        shownHKItem = hkItem
//    }
//    
//    func hideScanningAndOpenAdditionOfNewItems(of itemID: HKItemID) {
//        
//        isScanning = false
//        
//        itemIDsToBeRegistered.append(itemID)
//        
//        isAddingNewItems = true
//        
//    }
    
    // MARK: - Clients -
    @Published var isConnectingToClient = false
    @Published var clients: [HKClient] = []
    
    func populateClients() async {
        if clients.isEmpty {
            do {
                let hkClients = try await CloudKitManager.shared.getClients()
                withAnimation { clients = hkClients }
            } catch {
                print(error)
            }
        }
        
    }
    
    // MARK: - HKItemManagement -
//    @Published var isScanningQRCode = false
    @Published var isInputingHKItemID = false
    @Published var isFetchingHKItem = false
    @Published var failedMessage: String?
    
    @Published var previewedHKItem: HKItem? = nil
    @Published var isPreviewingHKItem = false
    
    @Published var itemIDsToBeRegistered: [HKItemID] = []
    @Published var isAddingNewItems = false
    
//    {
//        didSet {
//            if !itemIDsToBeRegistered.isEmpty { isAddingNewItems = true }
//        }
//    }
    
    private func retrievalOfHKItem(_ itemID: HKItemID) async {
        
        let impactMed = UIImpactFeedbackGenerator(style: .heavy)
        
        do {
            let hkItem = try await CloudKitManager.shared.getItem(itemID: itemID)
//            openHKItem(hkItem)
            impactMed.impactOccurred()
        } catch {
            
            if let itemError = error as? ItemErrors {
                switch itemError {
                case .notCreated:
//                    addItemIDToRegister(itemID)
                    impactMed.impactOccurred()
                case .mockUpID:
//                    failedToRetrieve(fetchFail: false)
                    impactMed.impactOccurred()
                case .failedFetching:
//                    failedToRetrieve(fetchFail: true)
                    impactMed.impactOccurred()
                }
            }
            
        }
        
    }
    
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
    
//    private func closeHKItemAllInputs() {
//        withAnimation {
//            isInputingHKItemID = false
//            isScanningQRCode = false
//            switchFetchingStatus(false)
//        }
//    }
    
    func handleIncomingDeepLink(_ url: URL) async {
//        switchFetchingStatus(true)
        let itemID = HKItemID(deepLink: url)
        await retrievalOfHKItem(itemID)
        if !itemIDsToBeRegistered.isEmpty {
            isAddingNewItems = true
        }
    }
    
//    func handleIncomingScan(
    
    func handleIncomingItemID(_ numberID: String) async {
//        switchFetchingStatus(true)
        let itemID = HKItemID(numberID: numberID)
        await retrievalOfHKItem(itemID)
    }
    
    
    
    
//    private func statusOfRetrievingItem(hasBegun value: Bool, hkItem: HKItem? = nil) {
//        if value {
//            withAnimation {
//                isGettingHKItem = true
//            }
//        } else if let hkItem, !value {
//            withAnimation {
//                isGettingHKItem = false
//                isScanningQRCode = false
//                isInputingHKItemID = false
//                isAddingNewItems = false
//                shownHKItem = hkItem
//            }
//        } else {
//            withAnimation {
//                isGettingHKItem = false
//                isScanningQRCode = false
//                isInputingHKItemID = false
//                isAddingNewItems = false
//                shownHKItem = nil
//            }
//        }
//    }
//    
//    private func openCreationOfNewItems() {
//        withAnimation {
//            isInputingHKItemID = false
//            isGettingHKItem = false
//            shownHKItem = nil
//        }
//        withAnimation { isAddingNewItems = true }
//    }
    
}
