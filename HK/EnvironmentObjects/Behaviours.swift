//
//  Behaviours.swift
//  HK
//
//  Created by Peter Kresanič on 08/12/2023.
//

import SwiftUI

@MainActor final class Behaviours: ObservableObject {
    
    @AppStorage("employeeID") var employeeID: String = ""
    
    @Published var activeTab: TabViews = .home
    @Published var isScanningQRCode = false
    @Published var isInputingHKItemID = false
    @Published var isShowingHKItem: HKItem? = nil
    @Published var isAddingNewItems = false
    @Published var isAskingForEmployeeID = false
    @Published var employee: HKUser?
    @Published var isGettingEmployee = false
    @Published var isShowingSettings = false
    @Published var isGettingHKItem = false
    
    func toggleShowSettings(to value: Bool?) {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
            if let value {
                isShowingSettings = value
            } else {
                isShowingSettings.toggle()
            }
        }
    }
    
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
    
    func toggleIsisGettingHKItem(to value: Bool? = nil) {
        withAnimation(.easeInOut(duration: 0.4)) {
            if let value {
                isGettingHKItem = value
            } else {
                isGettingHKItem.toggle()
            }
        }
    }
    
    func handleIncomingDeepLink(_ url: URL) async throws {
        
        //hydrokresItem://find-item?itemCode=HK00004
        
        let impactMed = UIImpactFeedbackGenerator(style: .heavy)
        
        guard let itemID = retrieveItemID(url)?.uppercased() else { throw RuntimeError("T")}
        
        let hkItem = try await CloudKitManager.shared.getItem(itemID: itemID)
        
        impactMed.impactOccurred()
        
        isShowingHKItem = hkItem
        
    }
    
    func handleIncomingHKItemID(_ itemID: String) async throws {
        
        //hydrokresItem://find-item?itemCode=HK00004
        
        let impactMed = UIImpactFeedbackGenerator(style: .heavy)
        
        let formatter = NumberFormatter()
        
        formatter.minimumIntegerDigits = 5
        
        guard let intItemID = Int(itemID) else { throw RuntimeError("int chyba")}
        
        let numberItemId = intItemID as NSNumber
        
        guard let zeroedItemID = formatter.string(from: numberItemId) else {
            throw RuntimeError("nepodarilo sa dorobiť nuly")
        }
        
        print(zeroedItemID)
        
        let hkedItemID = "HK\(zeroedItemID)"
        
        print(hkedItemID)
                                
        let hkItem = try await CloudKitManager.shared.getItem(itemID: hkedItemID)
        
        impactMed.impactOccurred()
        
        withAnimation {
            isInputingHKItemID = false
            isGettingHKItem = false
            isShowingHKItem = hkItem
        }

        
    }

    
    func retrieveItemID(_ url: URL) -> String? {
        
        guard url.scheme == "hydrokresItem" else { return nil }
        
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return nil }
        
        guard let action = components.host, action == "find-item" else { return nil }
        
        guard let itemCode = components.queryItems?.first(where: { $0.name == "itemCode" })?.value else { return nil }
        
        return itemCode
        
    }
    
}
