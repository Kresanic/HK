//
//  Scanning.swift
//  HK
//
//  Created by Peter Kresanič on 07/02/2024.
//

import Foundation
import CodeScanner

@MainActor final class Scanning: ObservableObject {
    
    @Published var isScanning = false
    @Published var scanMode: ScanMode = .once
    @Published var isRegisteringNew = false
    @Published var itemsToRegister: [HKItemID] = []
    
    func isItemRegistered(_ itemID: HKItemID) async -> HKItem? {
        
        let hkItem = try? await CloudKitManager.shared.getItem(itemID: itemID)
        
        return hkItem
        
    }
    
}
