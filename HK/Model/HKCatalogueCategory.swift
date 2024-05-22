//
//  HKCatalogueCategory.swift
//  HK
//
//  Created by Peter Kresanič on 03/02/2024.
//

import CloudKit
import UIKit

struct HKCatalogueCategory: Identifiable, Hashable {
    
    static let kName = "name"
    static let kPhoto = "photo"
    
    let id = UUID()
    let name: String?
    let photo: UIImage?
    let reference: CKRecord.Reference
    
    init(ckRecord: CKRecord) {
        name = ckRecord[Self.kName] as? String
        photo = (ckRecord[Self.kPhoto] as? CKAsset)?.uiImage
        reference = CKRecord.Reference(recordID: ckRecord.recordID, action: .none)
    }
    
}
