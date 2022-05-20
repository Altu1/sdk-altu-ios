//
//  BundleExtensions.swift
//  AltuSDK
//
//  Created by Ricardo Caldeira on 10/05/22.
//

import UIKit

public extension Bundle {
    
    var bundleID: String {
        return Bundle.main.bundleIdentifier?.description ?? ""
    }
}
