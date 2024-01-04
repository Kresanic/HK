//
//  HKItem.swift
//  HK
//
//  Created by Peter Kresanič on 04/01/2024.
//

import CloudKit

struct HKItem: Identifiable {
    
    static let kItemID = "itemID"
    static let kType = "type"
    static let kSoldOn = "soldOn"
    
    var unwrappedItemID: String {
        itemID ?? "N/A"
    }
    
    var unwrappedType: String {
        type ?? "N/A"
    }
    
    var unwrappedSoldOn: Date {
        soldOn ?? Date.now
    }
    
    let id: String?
    let itemID: String?
    let type: String?
    let soldOn: Date?
    
    init(ckRecord: CKRecord) {
        id = ckRecord[Self.kItemID] as? String
        itemID = ckRecord[Self.kItemID] as? String
        type = ckRecord[Self.kType] as? String
        soldOn = ckRecord[Self.kSoldOn] as? Date
    }
    
}
