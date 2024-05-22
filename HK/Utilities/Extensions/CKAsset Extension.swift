//
//  CKAsset Extension.swift
//  HK
//
//  Created by Peter Kresanič on 03/02/2024.
//

import CloudKit
import UIKit

extension CKAsset {
        
    var uiImage: UIImage? {
        if let url = self.fileURL {
            if let data = NSData(contentsOf: url) {
                return UIImage(data: data as Data)
            }
        }
        return nil
    }
    
}
