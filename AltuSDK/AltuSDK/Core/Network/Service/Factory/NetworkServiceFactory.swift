//
//  NetworkServiceFactory.swift
//  AltuSDK
//
//  Created by Ricardo Caldeira on 14/04/22.
//

import Foundation

class NetworkServiceFactory {
    func makeNetworkService() -> NetworkServiceType {
        return NetworkService()
    }
}
