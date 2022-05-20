//
//  Socket.swift
//  AltuSDK
//
//  Created by Ricardo Caldeira on 06/04/22.
//

import UIKit
import Starscream

class SocketManager: WebSocketDelegate {
    
    static public private(set) var sharedInstance = SocketManager()
    
    var socket: WebSocket?
    var isConnected = false
    let server = WebSocketServer()
    
    func connectSocket(host: String, token: String, pushToken: String) {
        guard let url = URL(string: host) else { return }
        
        var request = URLRequest(url: url, timeoutInterval: 5.0)
        request.setValue(token, forHTTPHeaderField: "Auth")
        request.setValue(ConstantsAltu().platform, forHTTPHeaderField: "platform")
        request.setValue(Bundle.main.bundleID, forHTTPHeaderField: "bundleId")
        request.setValue(pushToken, forHTTPHeaderField: "pushToken")
        
        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
    }
    
    // MARK: - WebSocketDelegate
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            isConnected = true
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            let messageDataDict:[String: Any] = ["message": string]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didReceiveMessage"), object: nil, userInfo: messageDataDict)
        case .binary(let data):
            print("websocket Received data: \(data.count)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(let isChanged):
            print ("websocket is viabilityChanged = \(isChanged)")
        case .reconnectSuggested(_):
            break
        case .cancelled:
            isConnected = false
        case .error(let error):
            isConnected = false
            handleError(error)
        }
    }
    
    func handleError(_ error: Error?) {
        if let e = error as? WSError {
            print("websocket encountered an error: \(e.message)")
        } else if let e = error {
            print("websocket encountered an error: \(e.localizedDescription)")
        } else {
            print("websocket encountered an error")
        }
    }
    
    func sendMessage(message: String) {
        if isConnected == false {
            socket?.connect()
            hasMessageForSend(message: message)
        } else {
            socket?.write(string: message)
        }
    }
    
    private func hasMessageForSend(message: String) {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if self.isConnected == true {
                self.socket?.write(string: message)
                timer.invalidate()
            }
        }
    }
    
    func disconnect() {
        if isConnected {
            socket?.disconnect()
        } else {
            socket?.connect()
        }
    }
}
