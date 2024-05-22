//
//  HKItem.swift
//  HK
//
//  Created by Peter Kresanič on 04/01/2024.
//

import CloudKit
import UIKit

struct HKItem: Identifiable {
    
    static let kItemID = "itemID"
    static let kSoldOn = "soldOn"
    static let kCapacity = "capacity"
    static let kLength = "length"
    static let kSoldFor = "soldFor"
    static let kType = "type"
    static let kWidth = "width"
    static let kPhotos = "photos"
    static let kHKClient = "hkClient"
    
    var unwrappedItemID: String {
        itemID ?? "N/A"
    }
    
    var unwrappedType: String {
        type ?? "N/A"
    }
    
    var unwrappedSoldOn: Date {
        soldOn ?? Date.now
    }
    
    var unwrappedFirstPhoto: UIImage {
        photos?.first ?? UIImage(resource: .placeholderPalette)
    }
    
    //category
    let id: String?
    let itemID: String?
    let type: String?
    let soldOn: Date?
    let capacity: Int?
    let length: Int?
    let soldFor: Double?
    let width: Int?
    let photos: [UIImage]?
    let hkClient: CKRecord.Reference?
    
    init(ckRecord: CKRecord) {
        id = ckRecord[Self.kItemID] as? String
        itemID = ckRecord[Self.kItemID] as? String
        type = ckRecord[Self.kType] as? String
        soldOn = ckRecord[Self.kSoldOn] as? Date
        capacity = ckRecord[Self.kCapacity] as? Int
        length = ckRecord[Self.kLength] as? Int
        soldFor = ckRecord[Self.kSoldFor] as? Double
        width = ckRecord[Self.kWidth] as? Int
        photos = (ckRecord[Self.kPhotos] as? [CKAsset])?.compactMap { $0.uiImage }
        hkClient = ckRecord[Self.kHKClient] as? CKRecord.Reference
    }
    
    var firstPhoto: UIImage? {
        photos?.first
    }
    
}

struct HKItemID: Identifiable, Equatable {
    
    let id: String
    
    init(_ id: String) {
        self.id = id
    }
    
    init(deepLink: URL) {
        
        guard deepLink.scheme == "hydrokresItem" else { self.id = "HK00000"; return }
        
        guard let components = URLComponents(url: deepLink, resolvingAgainstBaseURL: true) else { self.id = "HK00000"; return }
        
        guard let action = components.host, action == "find-item" else { self.id = "HK00000"; return }
        
        guard let itemCode = components.queryItems?.first(where: { $0.name == "HKItemID" })?.value else { self.id = "HK00000"; return }
        
        self.id = itemCode
        
    }
    
    init(numberID: String) {
        
        let formatter = NumberFormatter()
        
        formatter.minimumIntegerDigits = 5
        
        guard let intItemID = Int(numberID) else { self.id = "HK00000"; return }
        
        let numberItemId = intItemID as NSNumber
        
        guard let zeroedItemID = formatter.string(from: numberItemId) else { self.id = "HK00000"; return }
        
        self.id = "HK\(zeroedItemID)"
        
    }
    
    var isMockUpID: Bool { id == "HK00000" }
    
}
