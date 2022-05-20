//
//  ChatHeaderTests.swift
//  AltuSDKTests
//
//  Created by Ricardo Caldeira on 28/04/22.
//

import XCTest
@testable import AltuSDK

class ChatHeaderTests: BaseComponentTests {
    private var chatHeader: ChatHeaderItem!
    private var title: NSMutableAttributedString!
    override func setUp() {
        super.setUp()
        
        self.title = NSMutableAttributedString(string: "Titulo", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black ])

        self.chatHeader = ChatHeaderItem(title: self.title)

        self.addComponentToStackView(component: self.chatHeader)
    }

    override func tearDown() {
        super.tearDown()

        self.chatHeader = nil
    }
    
    func testPresenterNotNil() {
        XCTAssertNotNil(self.chatHeader.presenterView)
    }
    
    func testChatHeaderWithAllParameters() {
        
        self.title = NSMutableAttributedString(string: "Titulo", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black ])

        self.chatHeader = ChatHeaderItem(title: self.title, backgroundColor: UIColor.black, imageButton: UIImage(), imageLogo: UIImage(), buttonPressed: {})

        self.addComponentToStackView(component: self.chatHeader)
        XCTAssertNotNil(chatHeader.presenterView?.backgroundColor)
        XCTAssertNotNil(chatHeader.presenterView?.titleLabel)
        XCTAssertNotNil(chatHeader.presenterView?.avatarImage)
    }
}
