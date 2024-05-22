//
//  HKClient.swift
//  HK
//
//  Created by Peter Kresanič on 09/02/2024.
//

import CloudKit

struct HKClient: Identifiable, Hashable {
    
    static let kName = "name"
    static let kEmail = "email"
    static let kBusinessID = "businessID"
    
    let id = UUID()
    let name: String?
    let email: String?
    let businessID: String?
    let recordID: CKRecord.ID
    
    init(ckRecord: CKRecord) {
        name = ckRecord[Self.kName] as? String
        email = ckRecord[Self.kEmail] as? String
        businessID = ckRecord[Self.kBusinessID] as? String
        recordID = ckRecord.recordID
    }
    
    
}
