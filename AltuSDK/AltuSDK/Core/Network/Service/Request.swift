//
//  Request.swift
//  AltuSDK
//
//  Created by Ricardo Caldeira on 07/04/22.
//

import Foundation

/// HTTP method definitions.
public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

/// A dictionary of parameters to apply to a `URLRequest`.
public typealias Parameters = [String: Any]

/// A dictionary of headers to apply to a `URLRequest`.
public typealias HTTPHeaders = [String: String]
