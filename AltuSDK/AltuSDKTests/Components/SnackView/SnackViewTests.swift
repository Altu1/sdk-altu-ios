//
//  SnackViewTests.swift
//  AltuSDKTests
//
//  Created by Ricardo Caldeira on 01/05/22.
//

import XCTest
@testable import AltuSDK

class SnackViewTests: BaseComponentTests {
    private var snack: SnackItem!
    private var descriptionText: NSMutableAttributedString!
    private var actionText: NSMutableAttributedString!
    
    override func setUp() {
        super.setUp()
        
        self.descriptionText = NSMutableAttributedString(string: "Descricao", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white ])
        self.actionText = NSMutableAttributedString(string: "Sair", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white ])

        self.snack = SnackItem(descriptionText: descriptionText, actionText: actionText, backgroundColor: UIColor.black, descriptionTextColor: UIColor.black, actionTextColor: UIColor.black, buttonPressed: {})

        self.addComponentToStackView(component: self.snack)
    }

    override func tearDown() {
        super.tearDown()

        self.snack = nil
    }
    
    func testPresenterNotNil() {
        XCTAssertNotNil(self.snack.presenterView)
    }
    
    func testChatHeaderWithAllParameters() {
        self.descriptionText = NSMutableAttributedString(string: "Descricao", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white ])
        self.actionText = NSMutableAttributedString(string: "Sair", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white ])

        self.snack = SnackItem(descriptionText: descriptionText, actionText: actionText, backgroundColor: UIColor.black, descriptionTextColor: UIColor.black, actionTextColor: UIColor.black)

        self.addComponentToStackView(component: self.snack)
        XCTAssertEqual(snack.presenterView?.containerView.backgroundColor, UIColor.black)
        XCTAssertEqual(snack.presenterView?.descriptionLabel.textColor, UIColor.black)
        XCTAssertEqual(snack.presenterView?.actionLabel.textColor, UIColor.black)
        XCTAssertEqual(snack.presenterView?.actionLabel.text, "Sair")
        XCTAssertEqual(snack.presenterView?.descriptionLabel.text, "Descricao")
    }
}
