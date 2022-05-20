//
//  NetworkService.swift
//  AltuSDK
//
//  Created by Ricardo Caldeira on 14/04/22.
//

import UIKit

public protocol NetworkServiceType {
    func request(method: HTTPMethod, host: String, body: Data, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}

class NetworkService: NetworkServiceType {
    
    public func request(method: HTTPMethod, host: String, body: Data, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let url = URL(string: host) else { return }
        
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60.0)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method.rawValue
        if method != .get {
            urlRequest.httpBody = body
        }
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            completion(data, response, error)
        }.resume()
    }
}
