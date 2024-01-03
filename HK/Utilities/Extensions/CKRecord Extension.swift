//
//  CKRecord Extension.swift
//  HK
//
//  Created by Peter Kresanič on 02/01/2024.
//

import CloudKit

extension CKRecord {
    
    func convertToHKUser() -> HKUser { HKUser(ckRecord: self) }
    
}
