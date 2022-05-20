//
//  ChatManagerTests.swift
//  AltuSDKTests
//
//  Created by Ricardo Caldeira on 29/04/22.
//

import UIKit
import XCTest
@testable import AltuSDK

class ChatManagerTests: XCTestCase {
    let eventMessageModel = EventMessageModelMock()
    let widgetIdentifier = "XXX"
    let data: [String:String] = ["":""]
    let sourceid = "XXX"
    let extraHash: String =  "XXX"
    var chatManager: ChatManagerType?
    var hasConnected = false
    var hasDidReceiveMessage = false
    var hasDidReceiveEndChat = false
    var hasDidReceiveEndLiveChat = false
    var hasDidReceiveStartLiveChat = false
    var hasConnectionError = false
    
    override func setUp() {
        let config = D1AltuSdkConfig()
        config.webSocketEnvironment = .DEV
        
        self.chatManager = ChatFactory().makeChatManager(config: config,
                                                         output: self,
                                                         widgetIdentifier: widgetIdentifier,
                                                         sourceId: sourceid,
                                                         data: data,
                                                         extraHash: extraHash)
    }

    override func tearDown() {
    }
    
    func testChatMenagerNotNil() throws {
        XCTAssertNotNil(chatManager)
    }
    
    func testConnectSocket() throws {
        XCTAssertNoThrow(chatManager?.connectSocket(identifier: "XXX"))
    }
    
    func testSendMessage() throws {
        XCTAssertNoThrow(chatManager?.sendMessage(message: "XXX"))
    }
    
    func testsendMessageEndLiveChat() throws {
        XCTAssertNoThrow(chatManager?.sendMessageEndLiveChat())
    }
    
    func testDidReceiveMessageeConnected() {
        hasConnected = false
        let userInfo = ["message": eventMessageModel.connectedString]
        let notificationName = NSNotification.Name(rawValue: "didReceiveMessage")
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: userInfo)
        
        XCTAssertEqual(hasConnected, true)
    }
    
    func testDidReceiveMessageeChatMessage() {
        hasDidReceiveMessage = false
        let userInfo = ["message": eventMessageModel.chatMessageString]
        let notificationName = NSNotification.Name(rawValue: "didReceiveMessage")
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: userInfo)
        
        XCTAssertEqual(hasDidReceiveMessage, true)
    }
    
    func testDidReceiveMessageeEndChat() {
        hasDidReceiveEndChat = false
        let userInfo = ["message": eventMessageModel.endChatString]
        let notificationName = NSNotification.Name(rawValue: "didReceiveMessage")
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: userInfo)
        
        XCTAssertEqual(hasDidReceiveEndChat, true)
    }
    
    func testDidReceiveEndLiveChat() {
        hasDidReceiveEndLiveChat = false
        let userInfo = ["message": eventMessageModel.endLiveChatString]
        let notificationName = NSNotification.Name(rawValue: "didReceiveMessage")
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: userInfo)
        
        XCTAssertEqual(hasDidReceiveEndLiveChat, true)
    }
    
    func testDidReceiveStartLiveChat() {
        hasDidReceiveStartLiveChat = false
        let userInfo = ["message": eventMessageModel.startLiveChatString]
        let notificationName = NSNotification.Name(rawValue: "didReceiveMessage")
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: userInfo)
        
        XCTAssertEqual(hasDidReceiveStartLiveChat, true)
    }
}

extension ChatManagerTests: ChatManagerOutput {
    func connectionError() {
        hasConnected = true
    }
    
    func didReceiveEndLiveChat() {
        hasDidReceiveEndLiveChat = true
    }
    
    func didReceiveStartLiveChat() {
        hasDidReceiveStartLiveChat = true
    }
    
    func connected(isNewConnection: Bool, widgetId: String) {
        hasConnected = true
    }
    
    func didReceiveMessage(event: EventMessageModel) {
        hasDidReceiveMessage = true
    }
    
    func didReceiveEndChat() {
        hasDidReceiveEndChat = true
    }
}
