//
//  D1AltuSdkTests.swift
//  AltuSDKTests
//
//  Created by Ricardo Caldeira on 27/04/22.
//

import UIKit
import XCTest
@testable import AltuSDK

class D1PushSDKTests: XCTestCase {
    
    let config = D1AltuSdkConfig()
    
    override func setUp() {
        config.webSocketEnvironment = .DEV
    }

    override func tearDown() {
    }
    
    //Testando o setup com config
    func testSetup() throws {
        XCTAssertNoThrow(D1AltuSdk.sharedInstance.setup(config: config))
    }
    
    //Testando a abertura do chat sem Data e sem extraHash
    func testOpenChatWithoutDataWithoutExtrahash() throws {
        let viewController = UIViewController()
        
        XCTAssertNoThrow(D1AltuSdk.sharedInstance.openChat(viewController: viewController, widgetIdentifier: "1", sourceId: "1"))
    }
    
    //Testando a abertura do chat com Data e sem extraHash
    func testOpenChatWithDataWithoutExtrahash() throws {
        let viewController = UIViewController()
        let data: [String:String] = ["cpf":"00000000000",
                                     "rg": "00000000",
                                     "celular": "999999999"]
        
        XCTAssertNoThrow(D1AltuSdk.sharedInstance.openChat(viewController: viewController, widgetIdentifier: "1", sourceId: "1", data: data))
    }
    
    //Testando a abertura do chat sem Data e com extraHash
    func testOpenChatWithoutDataWithExtrahash() throws {
        let viewController = UIViewController()
        let extraHash: String =  "919e7a508ac036e138dd53205ca35c50dcb87530e9ce6b1af00e424a27094b73f344544e11b44a00f8fdd11b19cf688d"
        
        XCTAssertNoThrow(D1AltuSdk.sharedInstance.openChat(viewController: viewController, widgetIdentifier: "1", sourceId: "1", extraHash: extraHash))
    }
    
    //Testando a abertura do chat com Data e com extraHash
    func testOpenChatWithDataWithExtrahash() throws {
        let viewController = UIViewController()
        let data: [String:String] = ["cpf":"00000000000",
                                     "rg": "00000000",
                                     "celular": "999999999"]
        let extraHash: String =  "919e7a508ac036e138dd53205ca35c50dcb87530e9ce6b1af00e424a27094b73f344544e11b44a00f8fdd11b19cf688d"
        
        XCTAssertNoThrow(D1AltuSdk.sharedInstance.openChat(viewController: viewController, widgetIdentifier: "1", sourceId: "1", data: data, extraHash: extraHash))
    }
}
