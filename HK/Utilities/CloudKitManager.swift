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
    let publicDatabase = CKContainer(identifier: "iCloud.Kresanic.HK").publicCloudDatabase
    
    private init() {}
    
    func getClients() async throws -> [HKClient] {
        
        let sortDescriptor = NSSortDescriptor(key: HKClient.kBusinessID, ascending: true)
        let predicate = NSPredicate(format: "name != %@", "test")
        let query = CKQuery(recordType: RecordType.hkClient, predicate: predicate)
        query.sortDescriptors = [sortDescriptor]
        
        let (matchedResults, _) = try await publicDatabase.records(matching: query)
        
        var clients: [HKClient] = []
        
        matchedResults.forEach { _, result in
            let client = try? result.get()
            if let client { clients.append(HKClient(ckRecord: client)) }
        }
        
        return clients
        
    }
    
    func getItem(itemID: HKItemID) async throws -> HKItem {
        
        guard !itemID.isMockUpID else { throw ItemErrors.mockUpID }
        
        let sortDescriptor = NSSortDescriptor(key: HKItem.kSoldOn, ascending: true)
        let predicate = NSPredicate(format: "itemID == %@", itemID.id)
        let query = CKQuery(recordType: RecordType.hkItem, predicate: predicate)
        query.sortDescriptors = [sortDescriptor]
        
        guard let (matchedResults, _) = try? await container.publicCloudDatabase.records(matching: query, resultsLimit: 1) else { throw ItemErrors.failedFetching }
        guard matchedResults.count > 0 else { throw ItemErrors.notCreated }
        let records = matchedResults.compactMap { _, result in try? result.get() }
        guard let hkItemRecord = records.first else { throw ItemErrors.failedFetching }
        let hkItem = HKItem(ckRecord: hkItemRecord)
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
        
        try await assignHKUserToUser(employee: hkUserRecord.recordID)
        
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
    
    func getHKCategories() async throws -> [HKCatalogueCategory] {
        
        let sortDescriptor = NSSortDescriptor(key: HKCatalogueCategory.kName, ascending: true)
        let query = CKQuery(recordType: RecordType.hkCatalogueCategory, predicate: NSPredicate(format: "name != %@", "test"))
        query.sortDescriptors = [sortDescriptor]
        
        let (matchedResults, _) = try await container.publicCloudDatabase.records(matching: query)
        
        var categories: [HKCatalogueCategory] = []
        
        matchedResults.forEach { _, result in
            let category = try? result.get()
            if let category { categories.append(HKCatalogueCategory(ckRecord: category)) }
        }
        
        return categories
        
    }
    
    func getHKItems(in category: HKCatalogueCategory) async throws -> [HKCatalogueItem] {
        
        let sortDescriptor = NSSortDescriptor(key: HKCatalogueItem.kType, ascending: true)
        let reference = category.reference
        let query = CKQuery(recordType: RecordType.hkCatalogueItem, predicate: NSPredicate(format: "category == %@", reference))
        query.sortDescriptors = [sortDescriptor]
        
        let (matchedResults, _) = try await container.publicCloudDatabase.records(matching: query)
        
        var items: [HKCatalogueItem] = []
        
        matchedResults.forEach { _, result in
            let item = try? result.get()
            if let item { items.append(HKCatalogueItem(ckRecord: item)) }
        }
        
        return items
        
    }
    
    func addNewItems(catalogueItem: HKCatalogueItem, itemIDs: [HKItemID]) async throws {
        
        var ckRecords: [CKRecord] = []
        
        for itemID in itemIDs {
            
            let newRecord = CKRecord(recordType: RecordType.hkItem)

            newRecord[HKItem.kItemID] = itemID.id
            
            newRecord[HKItem.kCapacity] = catalogueItem.capacity
            newRecord[HKItem.kLength] = catalogueItem.length
            newRecord[HKItem.kWidth] = catalogueItem.width
            newRecord[HKItem.kType] = catalogueItem.type
            newRecord[HKItem.kSoldFor] = catalogueItem.price
            newRecord[HKItem.kSoldOn] = Date.now
            
            let photosAsCkAss = catalogueItem.photos?.compactMap { $0.convertToCKAsset() }
            
            newRecord[HKItem.kPhotos] = photosAsCkAss
            
            ckRecords.append(newRecord)
            
        }
        
        try await batchSave(records: ckRecords)
        
    }
    
    @discardableResult
    private func assignHKUserToUser(employee ckRecordID: CKRecord.ID?) async throws -> HKUser {
        
        guard let hkUserRecordID = ckRecordID else { throw EmployeeErrors.somethingWentWrong(4) }
        
        let recordID = try await container.userRecordID()
        
        let record = try await container.publicCloudDatabase.record(for: recordID)
        
        record["hkUser"] = CKRecord.Reference(recordID: hkUserRecordID, action: .none)
        
        guard let savedHKUser = try await batchSave(records: [record]).map(HKUser.init).first else { throw EmployeeErrors.somethingWentWrong(5) }
        
        return savedHKUser
        
    }
    
    func getItemsAssociatedToClient(_ client: HKClient) async throws -> [HKItem] {
        
        let reference = CKRecord.Reference(recordID: client.recordID, action: .none)
        let sortDescriptor = NSSortDescriptor(key: HKItem.kSoldOn, ascending: true)
        let predicate = NSPredicate(format: "hkClient == %@", reference)
        let query = CKQuery(recordType: RecordType.hkItem, predicate: predicate)
        query.sortDescriptors = [sortDescriptor]
        
        let (matchedResults, _) = try await container.publicCloudDatabase.records(matching: query)
        
        var items: [HKItem] = []
        
        matchedResults.forEach { _, result in
            let item = try? result.get()
            if let item { items.append(HKItem(ckRecord: item)) }
        }
        
        return items
        
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

enum ItemErrors: Error {
    case notCreated, mockUpID, failedFetching
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
