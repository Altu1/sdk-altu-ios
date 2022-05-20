//
//  SeparatorViewCellTests.swift
//  AltuSDKTests
//
//  Created by Ricardo Caldeira on 29/04/22.
//

import XCTest
@testable import AltuSDK

class SeparatorViewCellTests: BaseComponentTests {
    var chatTableView: ChatTableView!
    var separatorViewCell: SeparatorViewCell!
    
    override func setUp() {
        super.setUp()

        self.chatTableView = ChatTableView()
        
        let bundle = Bundle(for: ChatTableView.self)
        let separatorViewCellNib = UINib(nibName:SeparatorViewCell.identifier, bundle: bundle)
        self.chatTableView.register(separatorViewCellNib, forCellReuseIdentifier:SeparatorViewCell.identifier)
    }

    override func tearDown() {
        super.tearDown()

        self.chatTableView = nil
        self.separatorViewCell = nil
    }
    
    func testTableViewNotNil() {
        XCTAssertNotNil(self.chatTableView)
    }
    
    func testTableViewCellWithSizes() {
        super.setUp()

        self.chatTableView = ChatTableView()
        let bundle = Bundle(for: ChatTableView.self)
        let separatorViewCellNib = UINib(nibName:SeparatorViewCell.identifier, bundle: bundle)
        self.chatTableView.register(separatorViewCellNib, forCellReuseIdentifier:SeparatorViewCell.identifier)
        
        self.separatorViewCell = self.chatTableView.dequeueReusableCell(withIdentifier: SeparatorViewCell.identifier, for: IndexPath(row: 0, section: 0)) as? SeparatorViewCell
        
        self.separatorViewCell.configure(height: 1, radius: 1, backgroundColor: UIColor.white, marginTop: 1, marginBottom: 1, marginLeft: 1, marginRight: 1)
        
        XCTAssertEqual(self.separatorViewCell.separatorViewHeight.constant, 1)
        XCTAssertEqual(self.separatorViewCell.separatorView.layer.cornerRadius, 1)
        XCTAssertEqual(self.separatorViewCell.marginTop.constant, 1)
        XCTAssertEqual(self.separatorViewCell.marginBottom.constant, 1)
        XCTAssertEqual(self.separatorViewCell.marginLeft.constant, 1)
        XCTAssertEqual(self.separatorViewCell.marginRight.constant, 1)
        XCTAssertEqual(self.separatorViewCell.separatorView.backgroundColor, UIColor.white)
    }
}

