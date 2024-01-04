//
//  HKUser.swift
//  HK
//
//  Created by Peter Kresanič on 02/01/2024.
//

import CloudKit

struct HKUser: Codable, Equatable {
    
    static func ==(lhs: HKUser, rhs: HKUser) -> Bool { lhs.employeeID == rhs.employeeID }

    static let kFirstName = "firstName"
    static let kMiddleName = "middleName"
    static let kLastName = "lastName"
    static let kEmployeeID = "employeeID"
    static let kAccessLevel = "accessLevel"
    
    var initials: String {
        if let firstInitial = self.firstName?.first, let lastInitial = self.lastName?.first {
            return "\(firstInitial)\(lastInitial)"
        } else {
            return "XY"
        }
    }
    
    var unwrappedEmployeeID: String { employeeID ?? "" }
    
    var wholeName: String {
        var finalName = ""
        
        if let firstName {
            finalName = finalName + " \(firstName)"
        }
        
        if let middleName {
            finalName = finalName + " \(middleName)"
        }
        
        if let lastName {
            finalName = finalName + " \(lastName)"
        }
        
        return finalName
    }
    
    var isFilled: Bool { firstName != nil && lastName != nil && employeeID != nil && accessLevel != nil }
    
    let firstName: String?
    let middleName: String?
    let lastName: String?
    let employeeID: String?
    let accessLevel: Int?
    
    init(ckRecord: CKRecord) {
        firstName = ckRecord[Self.kFirstName] as? String
        middleName = ckRecord[Self.kMiddleName] as? String
        lastName = ckRecord[Self.kLastName] as? String
        employeeID = ckRecord[Self.kEmployeeID] as? String
        accessLevel = ckRecord[Self.kAccessLevel] as? Int
    }
    
}
