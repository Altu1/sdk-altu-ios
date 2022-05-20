//
//  ChatViewModelTests.swift
//  AltuSDKTests
//
//  Created by Ricardo Caldeira on 12/05/22.
//

import UIKit
import XCTest
@testable import AltuSDK

class ChatViewModelTests: XCTestCase {
    
    var viewModel: ChatViewModelType? = nil
    var config: D1AltuSdkConfig? = nil
    let eventMessageModel = EventMessageModelMock()
    
    override func setUp() {
        
        //criar o arquivo de configuração do SDK passando como parametro o appID
        let config = D1AltuSdkConfig()
        
        //Titulo do ChatBot
        config.titleChat = "D1 Jornadas Digitais"
        
        //Cor principal
        config.mainColor = UIColor(hexString: "#00284C")
        
        //Cor Secundaria
        config.secundaryColor = UIColor(hexString: "#098CFE")
        
        //Cor principal do texto
        config.mainTextColor = UIColor(hexString: "#1D1D1D")
        
        //Cor secundaria do texto
        config.secundaryTextColor = UIColor(hexString: "#B1B1B1")
        
        //Cor do background
        config.backgroundColor = UIColor(hexString: "#F5F5F5")
        
        //Configuração da imagem do avatar menor, ideal 32x32
        config.smallAvatar = UIImage()
        
        //Configuração da imagem do avatar maior, ideal 40x40
        config.bigAvatar = UIImage()
        
        ///Configurando qual ambiente o SDK deve usar, o ambiente default dentro do SDK é DEV, temos também o STG e PRD
        config.webSocketEnvironment = .DEV
        
        //Configurando qual ambiente de Autenticação o SDK deve usar, o ambiente default dentro do SDK é DEV, temos também o STG e PRD
        config.environment = .DEV
        
        config.slug = "XX"
        config.secret = "XXX"
        
        //DeviceToken para integração do chat com o push
        config.deviceToken = UserDefaults.standard.data(forKey: "deviceToken") ?? Data()
        
        //Configurando o histórico de conversas
        //Se ConversationHistory for ONGOING então vamos manter o histórico apenas das conversas em andamento.
        //Se ConversationHistory for ALWAYS então vamos manter o histórico das mensagens até o limite das 100 últimas.
        config.conversationHistory = .ALWAYS
        
        viewModel = ChatFactory().makeChatViewModel(config: config)
    }
    
    func testSetup() {
        let saveMessageInBank: String = """
        {
        "event": "chat_message",
        "connection_id": "",
        "data": [
            {
                "text": "Mensagem de teste",
                "type": "text"
            }
                ]
        }
        """
        guard let data = saveMessageInBank.data(using: .utf8) else { return }
        
        viewModel?.dBManager.addChatMessage(sessionIdValue: 1, widgetIdValue:"1", eventDataValue: data, typeValue: "userMessage", dateValue: Date())
        
        viewModel?.setup()
        
        XCTAssertNotNil(viewModel?.config)
        XCTAssertNotNil(viewModel?.dBManager)
        XCTAssertEqual(viewModel?.footerStackViewShowIsHidden, true)
    }
    
    func testSendMessage() {
        let date = Date()
        let chatMessage = ChatMessageModel(type: .userMessage, message: "Teste", date: date, showAvatar: false)
        viewModel?.sendMessage(chatMessage: chatMessage)
        
        XCTAssertEqual(viewModel?.messages[0].type, .userMessage)
        XCTAssertEqual(viewModel?.messages[0].message, "Teste")
        XCTAssertEqual(viewModel?.messages[0].date, date)
        XCTAssertEqual(viewModel?.messages[0].showAvatar, false)
    }
    
    func testSendMessageWithOtherDay() {
        let noon: Date = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!
        let dateYesterday = Calendar.current.date(byAdding: .day, value: -1, to: noon)!
        let chatMessageUser = ChatMessageModel(type: .userMessage, message: "Teste", date: dateYesterday, showAvatar: false)
        viewModel?.sendMessage(chatMessage: chatMessageUser)
        
        let dateToday = Date()
        let chatMessageBot = ChatMessageModel(type: .botMessage, message: "Teste", date: dateToday, showAvatar: false)
        viewModel?.sendMessage(chatMessage: chatMessageBot)
        
        XCTAssertEqual(viewModel?.messages.count, 3)
        XCTAssertEqual(viewModel?.messages[1].type, .dateMessage)
        XCTAssertEqual(viewModel?.messages[1].date, dateToday)
        XCTAssertEqual(viewModel?.messages[1].message, dateToday.dateInWriting())
        XCTAssertEqual(viewModel?.messages[1].showAvatar, false)
    }
    
    func testSetData() {
        let dataString: [String:String] = ["String":"String"]
        viewModel?.setData(data: dataString)
        
        XCTAssertEqual(viewModel?.data, dataString)
    }
    
    func testSetExtraHash() {
        let extraHash = "extraHash XXX 000"
        viewModel?.setExtraHash(extraHash: extraHash)
        
        XCTAssertEqual(viewModel?.extraHash, extraHash)
    }
    
    func testSetSourceId() {
        let sourceId = "sourceId XXX 111"
        viewModel?.setSourceId(sourceId: sourceId)
        
        XCTAssertEqual(viewModel?.sourceId, sourceId)
    }
    
    func testSetWidgetIdentifier() {
        let widgetIdentifier = "widgetIdentifier XXX 222"
        viewModel?.setWidgetIdentifier(widgetIdentifier: widgetIdentifier)
        
        XCTAssertEqual(viewModel?.widgetIdentifier, widgetIdentifier)
    }
    
    func testSendEndLiveChat() {
        viewModel?.sendEndLiveChat()
        
        XCTAssertEqual(viewModel?.snackViewShowIsHidden, true)
    }
    
    func testLoadMessages() {
        let saveMessageInBank: String = """
        {
        "event": "chat_message",
        "connection_id": "",
        "data": [
            {
                "text": "Mensagem de teste",
                "type": "text"
            }
                ]
        }
        """
        guard let data = saveMessageInBank.data(using: .utf8) else { return }
        
        viewModel?.dBManager.addChatMessage(sessionIdValue: 1, widgetIdValue:"1", eventDataValue: data, typeValue: "userMessage", dateValue: Date())
        viewModel?.dBManager.addChatMessage(sessionIdValue: 1, widgetIdValue:"1", eventDataValue: data, typeValue: "botMessage", dateValue: Date())
        viewModel?.dBManager.addChatMessage(sessionIdValue: 1, widgetIdValue:"1", eventDataValue: data, typeValue: "endChat", dateValue: Date())
        
        
        
        XCTAssertNoThrow(viewModel?.setup())
    }
    
    func testDidReceiveStartLiveChat() {
        viewModel?.setup()
        
        let userInfo = ["message": eventMessageModel.startLiveChatString]
        let notificationName = NSNotification.Name(rawValue: "didReceiveMessage")
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: userInfo)
        
        XCTAssertEqual(viewModel?.snackViewShowIsHidden, false)
    }
    
    func testDidReceiveEndLiveChat() {
        viewModel?.setup()
        
        let userInfo = ["message": eventMessageModel.endLiveChatString]
        let notificationName = NSNotification.Name(rawValue: "didReceiveMessage")
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: userInfo)
        
        XCTAssertEqual(viewModel?.snackViewShowIsHidden, true)
    }
    
    func testDidReceiveEndChat() {
        viewModel?.setup()
        
        let userInfo = ["message": eventMessageModel.endChatString]
        let notificationName = NSNotification.Name(rawValue: "didReceiveMessage")
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: userInfo)
        
        XCTAssertEqual(viewModel?.messages.last?.type, .endChat)
    }
    
    func testDidReceiveMessage() {
        viewModel?.setup()
        
        let userInfo = ["message": eventMessageModel.chatMessageString]
        let notificationName = NSNotification.Name(rawValue: "didReceiveMessage")
        
        XCTAssertNoThrow(NotificationCenter.default.post(name: notificationName, object: nil, userInfo: userInfo))
    }
    
    func testConnected() {
        viewModel?.setup()
        
        let userInfo = ["message": eventMessageModel.connectedString]
        let notificationName = NSNotification.Name(rawValue: "didReceiveMessage")
        
        XCTAssertNoThrow(NotificationCenter.default.post(name: notificationName, object: nil, userInfo: userInfo))
    }

}
