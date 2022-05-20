//
//  SimpleTextViewCellTests.swift
//  AltuSDKTests
//
//  Created by Ricardo Caldeira on 29/04/22.
//

import XCTest
@testable import AltuSDK

class SimpleTextViewCellTests: BaseComponentTests {
    var chatTableView: ChatTableView!
    var simpleTextViewCell: SimpleTextViewCell!
    
    override func setUp() {
        super.setUp()

        self.chatTableView = ChatTableView()
        
        let bundle = Bundle(for: ChatTableView.self)
        let simpleCellNib = UINib(nibName:SimpleTextViewCell.identifier, bundle: bundle)
        self.chatTableView.register(simpleCellNib, forCellReuseIdentifier:SimpleTextViewCell.identifier)
    }

    override func tearDown() {
        super.tearDown()

        self.chatTableView = nil
        self.simpleTextViewCell = nil
    }
    
    func testTableViewNotNil() {
        XCTAssertNotNil(self.chatTableView)
    }
    
    func testTableViewCellWithTypeSimpleMessage() {
        super.setUp()

        self.chatTableView = ChatTableView()
        let bundle = Bundle(for: ChatTableView.self)
        let simpleCellNib = UINib(nibName:SimpleTextViewCell.identifier, bundle: bundle)
        self.chatTableView.register(simpleCellNib, forCellReuseIdentifier:SimpleTextViewCell.identifier)
        
        self.simpleTextViewCell = self.chatTableView.dequeueReusableCell(withIdentifier: SimpleTextViewCell.identifier, for: IndexPath(row: 0, section: 0)) as? SimpleTextViewCell
        
        let myString = "Teste Simple Message"
        let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.black ]
        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
        
        self.simpleTextViewCell.configure(type: .simpleMessage, message: myAttrString)
        
        XCTAssertEqual(self.simpleTextViewCell.spacingBottom.constant, 8)
        XCTAssertEqual(self.simpleTextViewCell.spacingTop.constant, 16)
        XCTAssertEqual(self.simpleTextViewCell.descriptionLabel.text, myString)
        XCTAssertEqual(self.simpleTextViewCell.descriptionLabel.textAlignment, .left)
    }
    
    func testTableViewCellWithTypeDataMesage() {
        super.setUp()

        self.chatTableView = ChatTableView()
        let bundle = Bundle(for: ChatTableView.self)
        let simpleCellNib = UINib(nibName:SimpleTextViewCell.identifier, bundle: bundle)
        self.chatTableView.register(simpleCellNib, forCellReuseIdentifier:SimpleTextViewCell.identifier)
        
        self.simpleTextViewCell = self.chatTableView.dequeueReusableCell(withIdentifier: SimpleTextViewCell.identifier, for: IndexPath(row: 0, section: 0)) as? SimpleTextViewCell
        
        let myString = "Teste Data Message"
        let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.black ]
        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
        
        self.simpleTextViewCell.configure(type: .dateMessage, message: myAttrString)
        
        XCTAssertEqual(self.simpleTextViewCell.spacingBottom.constant, 0)
        XCTAssertEqual(self.simpleTextViewCell.spacingTop.constant, 0)
        XCTAssertEqual(self.simpleTextViewCell.descriptionLabel.text, myString)
        XCTAssertEqual(self.simpleTextViewCell.descriptionLabel.textAlignment, .left)
    }
    
    func testTableViewCellWithWrongType() {
        super.setUp()

        self.chatTableView = ChatTableView()
        let bundle = Bundle(for: ChatTableView.self)
        let simpleCellNib = UINib(nibName:SimpleTextViewCell.identifier, bundle: bundle)
        self.chatTableView.register(simpleCellNib, forCellReuseIdentifier:SimpleTextViewCell.identifier)

        self.simpleTextViewCell = self.chatTableView.dequeueReusableCell(withIdentifier: SimpleTextViewCell.identifier, for: IndexPath(row: 0, section: 0)) as? SimpleTextViewCell

        let myString = "Teste Tipo errado"
        let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.black ]
        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)

        self.simpleTextViewCell.configure(type: .botMessage, message: myAttrString)

        XCTAssertEqual(self.simpleTextViewCell.spacingBottom.constant, 16)
        XCTAssertEqual(self.simpleTextViewCell.spacingTop.constant, 16)
        XCTAssertEqual(self.simpleTextViewCell.descriptionLabel.text, myString)
        XCTAssertEqual(self.simpleTextViewCell.descriptionLabel.textAlignment, .left)
    }
    
    func testTableViewCellWithTextAlignment() {
        super.setUp()

        self.chatTableView = ChatTableView()
        let bundle = Bundle(for: ChatTableView.self)
        let simpleCellNib = UINib(nibName:SimpleTextViewCell.identifier, bundle: bundle)
        self.chatTableView.register(simpleCellNib, forCellReuseIdentifier:SimpleTextViewCell.identifier)

        self.simpleTextViewCell = self.chatTableView.dequeueReusableCell(withIdentifier: SimpleTextViewCell.identifier, for: IndexPath(row: 0, section: 0)) as? SimpleTextViewCell

        let myString = "Teste Text Alignment"
        let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.black ]
        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)

        self.simpleTextViewCell.configure(type: .dateMessage, message: myAttrString, textAlignment: .center)

        XCTAssertEqual(self.simpleTextViewCell.spacingBottom.constant, 0)
        XCTAssertEqual(self.simpleTextViewCell.spacingTop.constant, 0)
        XCTAssertEqual(self.simpleTextViewCell.descriptionLabel.text, myString)
        XCTAssertEqual(self.simpleTextViewCell.descriptionLabel.textAlignment, .center)
    }
}
