//
//  CloudKitManager.swift
//  HK
//
//  Created by Peter Kresanič on 02/01/2024.
//

import CloudKit

final class CloudKitManager {
    
    static let shared = CloudKitManager()
    
    let container = CKContainer(identifier: "iCloud.Kresanic.HK")
    
    private init() {}
    
    func getItem(itemID: String) async throws -> HKItem {
        
        let sortDescriptor = NSSortDescriptor(key: HKItem.kSoldOn, ascending: true)
        let predicate = NSPredicate(format: "itemID == %@", itemID)
        let query = CKQuery(recordType: RecordType.hkItem, predicate: predicate)
        query.sortDescriptors = [sortDescriptor]
        
        print("1", itemID)
        let (matchedResults, _) = try await container.publicCloudDatabase.records(matching: query, resultsLimit: 1)
        print("2", matchedResults.count)
        let records = matchedResults.compactMap { _, result in try? result.get() }
        print("3", records.first)
        guard let hkItemRecord = records.first else { throw RuntimeError("1") }
        print("4", hkItemRecord.recordID)
        let hkItem = HKItem(ckRecord: hkItemRecord)
        print("5", hkItem.itemID)
        return hkItem
        
    }
    
    func getUser(employeeID: String) async throws -> HKUser {
        
        let sortDescriptor = NSSortDescriptor(key: HKUser.kAccessLevel, ascending: true)
        let predicate = NSPredicate(format: "employeeID == %@", employeeID)
        let query = CKQuery(recordType: RecordType.hkUser, predicate: predicate)
        query.sortDescriptors = [sortDescriptor]
        
        let (matchedResults, _) = try await container.publicCloudDatabase.records(matching: query, resultsLimit: 1)
        
        let records = matchedResults.compactMap { _, result in try? result.get() }
        
        guard let hkUserRecord = records.first else { throw EmployeeErrors.couldNotFindEmployee }
        
        let hkUser = HKUser(ckRecord: hkUserRecord)
        
        try await assingHKUserToUser(employee: hkUserRecord.recordID)
        
        let assignedHKUserToUser = try await getAssignedHKUserToUser()
        
        guard assignedHKUserToUser == hkUser else { throw EmployeeErrors.somethingWentWrong(1) }
    
        return hkUser
        
    }
    
    private func getAssignedHKUserToUser() async throws -> HKUser {
        
        let recordID = try await container.userRecordID()
        
        let record = try await container.publicCloudDatabase.record(for: recordID)
        
        guard let hkUserReference = record["hkUser"] as? CKRecord.Reference else { throw EmployeeErrors.somethingWentWrong(2) }
        
        let hkUserRecords = try await container.publicCloudDatabase.records(for: [hkUserReference.recordID])
        
        let hkUserRecord = try hkUserRecords[hkUserReference.recordID]?.get()
        
        guard let hkUser = hkUserRecord.map(HKUser.init) else { throw EmployeeErrors.somethingWentWrong(3) }
        
        return hkUser
        
    }
    
    @discardableResult
    private func assingHKUserToUser(employee ckRecordID: CKRecord.ID?) async throws -> HKUser {
        
        guard let hkUserRecordID = ckRecordID else { throw EmployeeErrors.somethingWentWrong(4) }
        
        let recordID = try await container.userRecordID()
        
        let record = try await container.publicCloudDatabase.record(for: recordID)
        
        record["hkUser"] = CKRecord.Reference(recordID: hkUserRecordID, action: .none)
        
        guard let savedHKUser = try await batchSave(records: [record]).map(HKUser.init).first else { throw EmployeeErrors.somethingWentWrong(5)}
        
        return savedHKUser
        
    }
    
    @discardableResult
    func batchSave(records: [CKRecord]) async throws -> [CKRecord] {
        
        let (savedResults, _) = try await container.publicCloudDatabase.modifyRecords(saving: records, deleting: [])
        
        let savedRecords = savedResults.compactMap { _, result in try? result.get() }
        
        return savedRecords
        
    }
    
    
}

struct RuntimeError: LocalizedError {
    let description: String

    init(_ description: String) {
        self.description = description
    }

    var errorDescription: String? {
        description
    }
}

enum EmployeeErrors: Error {
    
    case invalidCode
    case couldNotFindEmployee
    case somethingWentWrong(Int)
    
    var message: String {
        switch self {
        case .invalidCode:
            "Nesprávny kód."
        case .couldNotFindEmployee:
            "Nepodarilo sa nájsť nikoho s daným kódom."
        case .somethingWentWrong(let code):
            "Niečo sa pokazilo (\(code)). Skontrolujte internet alebo vyskúšajte neskôr."
        }
    }
    
}
