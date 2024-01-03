//
//  Behaviours.swift
//  HK
//
//  Created by Peter Kresanič on 08/12/2023.
//

import SwiftUI

@MainActor final class Behaviours: ObservableObject {
    
    @Published var activeTab: TabViews = .home
    @Published var isScanningQRCode = false
    @Published var isShowingProductOfCode: String? = nil
    @Published var isAddingNewItems = false
    @Published var isAskingForEmployeeID = false
    @AppStorage("employeeID") var employeeID: String = ""
    @Published var employee: HKUser?
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
    
    func handleIncomingDeepLink(_ url: URL) {
        
        //hydrokresItem://find-item?itemCode=HK00004
        
        guard url.scheme == "hydrokresItem" else { return }
        
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }
        
        guard let action = components.host, action == "find-item" else { return }
        
        guard let itemCode = components.queryItems?.first(where: { $0.name == "itemCode" })?.value else { return }
        
        isShowingProductOfCode = itemCode
        
    }
    
}
