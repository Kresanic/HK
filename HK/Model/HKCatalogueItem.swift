//
//  HKCatalogueItem.swift
//  HK
//
//  Created by Peter Kresanič on 03/02/2024.
//

import CloudKit
import UIKit

struct HKCatalogueItem: Identifiable {
    
    static let kCapacity = "capacity"
    static let kLength = "length"
    static let kPhotos = "photos"
    static let kPrice = "price"
    static let kType = "type"
    static let kWidth = "width"
    
    let id = UUID()
    let capacity: Int?
    let length: Int?
    let photos: [UIImage]?
    let price: Double?
    let type: String?
    let width: Int?
    
    init(ckRecord: CKRecord) {
        capacity = ckRecord[Self.kCapacity] as? Int
        length = ckRecord[Self.kLength] as? Int
        photos = (ckRecord[Self.kPhotos] as? [CKAsset])?.compactMap { $0.uiImage }
        price = ckRecord[Self.kPrice] as? Double
        type = ckRecord[Self.kType] as? String
        width = ckRecord[Self.kWidth] as? Int
    }
    
    var firstPhoto: UIImage? {
        photos?.first
    }
    
}
