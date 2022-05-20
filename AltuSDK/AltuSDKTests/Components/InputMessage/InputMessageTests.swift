//
//  InputMessageTests.swift
//  AltuSDKTests
//
//  Created by Ricardo Caldeira on 28/04/22.
//

import XCTest
@testable import AltuSDK

class InputMessageTests: BaseComponentTests {
    private var InputMessage: InputMessageItem!
    private var title: NSMutableAttributedString!
    private var message: String = ""
    override func setUp() {
        super.setUp()
        
        self.title = NSMutableAttributedString(string: "Titulo", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black ])

        self.InputMessage = InputMessageItem(backgroundColor: UIColor.black, buttonColor: UIColor.cyan, buttonSendMessagePressed: { message in })

        self.addComponentToStackView(component: self.InputMessage)
    }

    override func tearDown() {
        super.tearDown()

        self.InputMessage = nil
    }
    
    func testPresenterNotNil() {
        XCTAssertNotNil(self.InputMessage.presenterView)
    }
    
    func testSendMessageEqual() {
        self.title = NSMutableAttributedString(string: "Titulo", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black ])

        self.InputMessage = InputMessageItem(backgroundColor: UIColor.black, buttonColor: UIColor.cyan, buttonSendMessagePressed: { message in
            self.message = message
        })

        self.addComponentToStackView(component: self.InputMessage)
        InputMessage.presenterView?.inputMessageTextField.text = "TESTE"
        InputMessage.presenterView?.sendMessage()
        
        XCTAssertEqual(self.message, "TESTE")
    }
    
    func testColorsEqual() {
        self.title = NSMutableAttributedString(string: "Titulo", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black ])

        self.InputMessage = InputMessageItem(backgroundColor: UIColor.black, buttonColor: UIColor.cyan, buttonSendMessagePressed: { message in })
        
        self.addComponentToStackView(component: self.InputMessage)
        
        XCTAssertEqual(InputMessage.presenterView?.contentView.backgroundColor, UIColor.black)
        XCTAssertEqual(InputMessage.presenterView?.buttonView.backgroundColor, UIColor.cyan)
    }
}
