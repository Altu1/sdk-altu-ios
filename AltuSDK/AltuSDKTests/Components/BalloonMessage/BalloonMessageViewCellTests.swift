//
//  BalloonMessageViewCellTests.swift
//  AltuSDKTests
//
//  Created by Ricardo Caldeira on 29/04/22.
//

import XCTest
@testable import AltuSDK

class BalloonMessageViewCellTests: BaseComponentTests {
    var chatTableView: ChatTableView!
    var balloonMessageViewCell: BalloonMessageViewCell!
    let dateFormatter = DateFormatter()
    
    override func setUp() {
        super.setUp()

        self.chatTableView = ChatTableView()
        let bundle = Bundle(for: ChatTableView.self)
        let balloonMessageViewCellNib = UINib(nibName:BalloonMessageViewCell.identifier, bundle: bundle)
        self.chatTableView.register(balloonMessageViewCellNib, forCellReuseIdentifier:BalloonMessageViewCell.identifier)
    }

    override func tearDown() {
        super.tearDown()

        self.chatTableView = nil
        self.balloonMessageViewCell = nil
    }
    
    func testTableViewNotNil() {
        XCTAssertNotNil(self.chatTableView)
    }
    
    func testTableViewCellWithTypeUserMessage() {
        super.setUp()

        self.chatTableView = ChatTableView()
        let bundle = Bundle(for: ChatTableView.self)
        let balloonMessageViewCellNib = UINib(nibName:BalloonMessageViewCell.identifier, bundle: bundle)
        self.chatTableView.register(balloonMessageViewCellNib, forCellReuseIdentifier:BalloonMessageViewCell.identifier)
        
        self.balloonMessageViewCell = self.chatTableView.dequeueReusableCell(withIdentifier: BalloonMessageViewCell.identifier, for: IndexPath(row: 0, section: 0)) as? BalloonMessageViewCell
        
        let message = ChatMessageModel(type: .userMessage, message: "User Message", date: Date(), showAvatar: false)
        let config = D1AltuSdkConfig()
        let messageFormated = message.message.convertHtmlToAttributedStringWithCSS(font: UIFont(name: "Helvetica Neue", size: 14), csscolor: UIColor.white.toHexString(), lineheight: 14, csstextalign: "left")
        
        self.balloonMessageViewCell.configure(chatMessage: message, nextMessageType: .userMessage, config: config)
        
        XCTAssertEqual(self.balloonMessageViewCell.config, config)
        XCTAssertEqual(self.balloonMessageViewCell.balloonMessageUserView.isHidden, false)
        XCTAssertEqual(self.balloonMessageViewCell.balloonMessageBotView.isHidden, true)
        XCTAssertEqual(self.balloonMessageViewCell.hourUserLabel.isHidden, true)
        XCTAssertEqual(self.balloonMessageViewCell.hourUserLabelHeight.constant, 0)
        XCTAssertEqual(self.balloonMessageViewCell.balloonUserView.layer.maskedCorners, [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner])
        XCTAssertEqual(self.balloonMessageViewCell.balloonUserView.backgroundColor, config.secundaryColor)
        XCTAssertEqual(self.balloonMessageViewCell.messageUserLabel.attributedText, messageFormated)
    }
    
    func testTableViewCellWithTypeUserMessageWithNextDifferentType() {
        super.setUp()

        self.chatTableView = ChatTableView()
        let bundle = Bundle(for: ChatTableView.self)
        let balloonMessageViewCellNib = UINib(nibName:BalloonMessageViewCell.identifier, bundle: bundle)
        self.chatTableView.register(balloonMessageViewCellNib, forCellReuseIdentifier:BalloonMessageViewCell.identifier)
        
        self.balloonMessageViewCell = self.chatTableView.dequeueReusableCell(withIdentifier: BalloonMessageViewCell.identifier, for: IndexPath(row: 0, section: 0)) as? BalloonMessageViewCell
        
        let date = Date()
        dateFormatter.dateFormat = "HH:mm"
        let message = ChatMessageModel(type: .userMessage, message: "User Message", date: date, showAvatar: false)
        let config = D1AltuSdkConfig()
        let messageFormated = message.message.convertHtmlToAttributedStringWithCSS(font: UIFont(name: "Helvetica Neue", size: 14), csscolor: UIColor.white.toHexString(), lineheight: 14, csstextalign: "left")
        
        self.balloonMessageViewCell.configure(chatMessage: message, nextMessageType: .botMessage, config: config)
        
        XCTAssertEqual(self.balloonMessageViewCell.config, config)
        XCTAssertEqual(self.balloonMessageViewCell.balloonMessageUserView.isHidden, false)
        XCTAssertEqual(self.balloonMessageViewCell.balloonMessageBotView.isHidden, true)
        XCTAssertEqual(self.balloonMessageViewCell.hourUserLabel.isHidden, false)
        XCTAssertEqual(self.balloonMessageViewCell.hourUserLabelHeight.constant, 15)
        XCTAssertEqual(self.balloonMessageViewCell.balloonUserView.layer.maskedCorners, [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner])
        XCTAssertEqual(self.balloonMessageViewCell.balloonUserView.backgroundColor, config.secundaryColor)
        XCTAssertEqual(self.balloonMessageViewCell.messageUserLabel.attributedText, messageFormated)
        XCTAssertEqual(self.balloonMessageViewCell.hourUserLabel.text, "\(dateFormatter.string(from: date))")
        XCTAssertEqual(self.balloonMessageViewCell.hourUserLabel.textColor, config.mainTextColor)
    }
    
    func testTableViewCellWithTypeBotMessage() {
        super.setUp()

        self.chatTableView = ChatTableView()
        let bundle = Bundle(for: ChatTableView.self)
        let balloonMessageViewCellNib = UINib(nibName:BalloonMessageViewCell.identifier, bundle: bundle)
        self.chatTableView.register(balloonMessageViewCellNib, forCellReuseIdentifier:BalloonMessageViewCell.identifier)
        
        self.balloonMessageViewCell = self.chatTableView.dequeueReusableCell(withIdentifier: BalloonMessageViewCell.identifier, for: IndexPath(row: 0, section: 0)) as? BalloonMessageViewCell
        
        let message = ChatMessageModel(type: .botMessage, message: "Bot Message", date: Date(), showAvatar: false)
        let config = D1AltuSdkConfig()
        let messageFormated = message.message.convertHtmlToAttributedStringWithCSS(font: UIFont(name: "Helvetica Neue", size: 14), csscolor: config.mainTextColor.toHexString(), lineheight: 14, csstextalign: "left")
        
        self.balloonMessageViewCell.configure(chatMessage: message, nextMessageType: .botMessage, config: config)
        
        XCTAssertEqual(self.balloonMessageViewCell.config, config)
        XCTAssertEqual(self.balloonMessageViewCell.balloonMessageUserView.isHidden, true)
        XCTAssertEqual(self.balloonMessageViewCell.balloonMessageBotView.isHidden, false)
        XCTAssertEqual(self.balloonMessageViewCell.hourBotLabel.isHidden, true)
        XCTAssertEqual(self.balloonMessageViewCell.hourBotLabelHeight.constant, 0)
        XCTAssertEqual(self.balloonMessageViewCell.balloonBotView.layer.maskedCorners, [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner])
        XCTAssertEqual(self.balloonMessageViewCell.balloonBotView.backgroundColor, config.backgroundColor)
        XCTAssertEqual(self.balloonMessageViewCell.messageBotLabel.attributedText, messageFormated)
        XCTAssertEqual(self.balloonMessageViewCell.avatarBotImage.isHidden, true)
        XCTAssertEqual(self.balloonMessageViewCell.avatarBotImageWidth.constant, 0)
        XCTAssertEqual(self.balloonMessageViewCell.leadingSpacingBalloonBotView.constant, 0)
    }
    
    func testTableViewCellWithTypeBotMessageWithAvatarNextMessageEqual() {
        super.setUp()

        self.chatTableView = ChatTableView()
        let bundle = Bundle(for: ChatTableView.self)
        let balloonMessageViewCellNib = UINib(nibName:BalloonMessageViewCell.identifier, bundle: bundle)
        self.chatTableView.register(balloonMessageViewCellNib, forCellReuseIdentifier:BalloonMessageViewCell.identifier)
        
        self.balloonMessageViewCell = self.chatTableView.dequeueReusableCell(withIdentifier: BalloonMessageViewCell.identifier, for: IndexPath(row: 0, section: 0)) as? BalloonMessageViewCell
        
        let message = ChatMessageModel(type: .botMessage, message: "Bot Message", date: Date(), showAvatar: true)
        let config = D1AltuSdkConfig()
        config.smallAvatar = UIImage()
        let messageFormated = message.message.convertHtmlToAttributedStringWithCSS(font: UIFont(name: "Helvetica Neue", size: 14), csscolor: config.mainTextColor.toHexString(), lineheight: 14, csstextalign: "left")
        
        self.balloonMessageViewCell.configure(chatMessage: message, nextMessageType: .botMessage, config: config)
        
        XCTAssertEqual(self.balloonMessageViewCell.config, config)
        XCTAssertEqual(self.balloonMessageViewCell.balloonMessageUserView.isHidden, true)
        XCTAssertEqual(self.balloonMessageViewCell.balloonMessageBotView.isHidden, false)
        XCTAssertEqual(self.balloonMessageViewCell.hourBotLabel.isHidden, true)
        XCTAssertEqual(self.balloonMessageViewCell.hourBotLabelHeight.constant, 0)
        XCTAssertEqual(self.balloonMessageViewCell.balloonBotView.layer.maskedCorners, [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner])
        XCTAssertEqual(self.balloonMessageViewCell.balloonBotView.backgroundColor, config.backgroundColor)
        XCTAssertEqual(self.balloonMessageViewCell.messageBotLabel.attributedText, messageFormated)
        XCTAssertEqual(self.balloonMessageViewCell.avatarBotImage.isHidden, true)
        XCTAssertEqual(self.balloonMessageViewCell.avatarBotImageWidth.constant, 32)
        XCTAssertEqual(self.balloonMessageViewCell.leadingSpacingBalloonBotView.constant, 8)
    }
    
    func testTableViewCellWithTypeBotMessageWithAvatarAndNextMessageDifferentType() {
        super.setUp()

        self.chatTableView = ChatTableView()
        let bundle = Bundle(for: ChatTableView.self)
        let balloonMessageViewCellNib = UINib(nibName:BalloonMessageViewCell.identifier, bundle: bundle)
        self.chatTableView.register(balloonMessageViewCellNib, forCellReuseIdentifier:BalloonMessageViewCell.identifier)
        
        self.balloonMessageViewCell = self.chatTableView.dequeueReusableCell(withIdentifier: BalloonMessageViewCell.identifier, for: IndexPath(row: 0, section: 0)) as? BalloonMessageViewCell
        
        let message = ChatMessageModel(type: .botMessage, message: "Bot Message", date: Date(), showAvatar: true)
        let config = D1AltuSdkConfig()
        config.smallAvatar = UIImage()
        let messageFormated = message.message.convertHtmlToAttributedStringWithCSS(font: UIFont(name: "Helvetica Neue", size: 14), csscolor: config.mainTextColor.toHexString(), lineheight: 14, csstextalign: "left")
        
        self.balloonMessageViewCell.configure(chatMessage: message, nextMessageType: .userMessage, config: config)
        
        XCTAssertEqual(self.balloonMessageViewCell.config, config)
        XCTAssertEqual(self.balloonMessageViewCell.balloonMessageUserView.isHidden, true)
        XCTAssertEqual(self.balloonMessageViewCell.balloonMessageBotView.isHidden, false)
        XCTAssertEqual(self.balloonMessageViewCell.hourBotLabel.isHidden, false)
        XCTAssertEqual(self.balloonMessageViewCell.hourBotLabelHeight.constant, 15)
        XCTAssertEqual(self.balloonMessageViewCell.balloonBotView.layer.maskedCorners, [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner])
        XCTAssertEqual(self.balloonMessageViewCell.balloonBotView.backgroundColor, config.backgroundColor)
        XCTAssertEqual(self.balloonMessageViewCell.messageBotLabel.attributedText, messageFormated)
        XCTAssertEqual(self.balloonMessageViewCell.avatarBotImage.isHidden, false)
        XCTAssertEqual(self.balloonMessageViewCell.avatarBotImageWidth.constant, 32)
        XCTAssertEqual(self.balloonMessageViewCell.leadingSpacingBalloonBotView.constant, 8)
    }
}
