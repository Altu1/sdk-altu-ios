//
//  ChatService.swift
//  AltuSDK
//
//  Created by Ricardo Caldeira on 07/04/22.
//

import Foundation

protocol ChatManagerType {
    func connectSocket(identifier: String?)
    func sendMessage(message: String)
    func sendMessageEndLiveChat()
}

protocol ChatManagerOutput: AnyObject {
    func connected(isNewConnection: Bool, widgetId: String)
    func connectionError()
    func didReceiveMessage(event: EventMessageModel)
    func didReceiveEndChat()
    func didReceiveEndLiveChat()
    func didReceiveStartLiveChat()
}

class ChatManager: ChatManagerType {
    
    weak var output: ChatManagerOutput?
    let config: D1AltuSdkConfig
    let socket =  SocketManager.sharedInstance
    var constants: ConstantsAltu
    private var data: [String:String]? = nil
    private var extraHash: String? = nil
    private var sourceId: String = ""
    private var identifier: String = ""
    private var widgetIdentifier: String = ""
    private var assistantId: String = ""
    private var widgetId: String = ""
    private var dBManager: DBManager
    private var networkService: NetworkServiceType
    
    init(config: D1AltuSdkConfig,
         output: ChatManagerOutput,
         widgetIdentifier: String,
         sourceId: String,
         data: [String:String]? = nil,
         extraHash: String? = nil) {
        
        self.config = config
        self.data = data
        self.extraHash = extraHash
        self.sourceId = sourceId
        self.widgetIdentifier = widgetIdentifier
        self.constants = ConstantsAltu.init()
        self.output = output
        self.dBManager = AltuSDK.DBManager()
        self.networkService = NetworkServiceFactory().makeNetworkService()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveMessage), name: NSNotification.Name(rawValue: "didReceiveMessage"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.connectionSocketError), name: NSNotification.Name(rawValue: "connectionSocketError"), object: nil)
    }
    
    // MARK: BASE URL
    private var baseSocketUrl: String {
        switch config.webSocketEnvironment {
        case .DEV:
            return "wss://socket.altubots-local.com"
        case .STG:
            return "wss://socket.altubots-local.com"
        case .PRD:
            return "wss://socket.altubots.com"
        case .CUSTOM(let envirommentUrl):
            return envirommentUrl
        }
    }
    
    private var AuthUrl: String {
        switch config.environment {
        case .DEV:
            return "https://api.altubots-local.com/sdk/authenticate"
        case .STG:
            return "https://api.altubots-local.com/sdk/authenticate"
        case .PRD:
            return "https://api.altubots.com/sdk/authenticate"
        case .CUSTOM(let authEnvirommentUrl):
            return authEnvirommentUrl
        }
    }
    
    private var homol: String {
        switch config.webSocketEnvironment {
        case .PRD:
            return "0"
        default :
            return "1"
        }
    }
    
    func connectSocket(identifier: String?) {
        let AuthHost = AuthUrl
        let parameters: [String:Any] = ["slug": config.slug,
                                        "secret": config.secret]
        
        guard let body = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        
        self.networkService.request(method: .post, host: AuthHost, body: body, completion: { [self] data, response, error in
            
            if error != nil {
                output?.connectionError()
                return
            } else {
                guard let data = data, let httpResponse = response as? HTTPURLResponse else { return }
                
                do {
                    if (200..<300).contains(httpResponse.statusCode) {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        let result = json as? [String: Any]
                        if let token = result?["token"] as? String {
                            self.identifier = identifier ?? UUID().uuidString
                            let host = baseSocketUrl + "/sdk/?source=\(constants.source)&source_id=\(self.sourceId)&slug=\(config.slug)&channel=\(constants.channel)&widget_identifier=\(self.widgetIdentifier)&homol=\(homol)&identifier=\(self.identifier)"
                            
                            let pushToken = config.deviceToken.reduce("", { $0 + String(format: "%02x", $1) })
                            
                            socket.connectSocket(host: host, token: token, pushToken: pushToken)
                        }
                    }
                } catch {
                    print("\(error.localizedDescription)")
                }
            }
        })
    }
    
    func sendMessage(message: String) {
        let dictionary = ["[": "", "]": ""]
        let data: String = self.data?.debugDescription.replace(dictionary) ?? ""
        let extraHash: String = self.extraHash?.debugDescription ?? ""
        let extraInfo: String = """
                                ,
                                "extra_info": \(extraHash)
                                """
        
        let sendMessage: String = """
        {
        "source": "mobile", "event": "chat_message", "params": {
        "slug": "\(config.slug)",
        "identifier": "\(self.identifier)",
        "assistant_id": \(self.assistantId),
        "widget_id": \(self.widgetId),
        "homol": true,
        "url_params":{\(data)}\(self.extraHash != nil ? extraInfo : "")
        }, "data": {
        "message": "\(message)",
        "cognitive": false }
        }
        """
        
        //Save message in bank
        if message.trimmingCharacters(in: NSCharacterSet.whitespaces) != "" {
            let saveMessageInBank: String = """
            {
            "event": "chat_message",
            "connection_id": "",
            "data": [
                {
                    "text": "\(message)",
                    "type": "text"
                }
                    ]
            }
            """
            guard let data = saveMessageInBank.data(using: .utf8) else { return }
            
            if let session = dBManager.getChatSessions().first(where: {$0.chatId == self.identifier}) {
                dBManager.addChatMessage(sessionIdValue: session.sessionId, widgetIdValue: session.widgetId, eventDataValue: data, typeValue: "userMessage", dateValue: Date())
            }
        }
        
        socket.sendMessage(message: sendMessage)
    }
    
    func sendMessageEndLiveChat() {
        
        let sendMessage: String = """
        {
        "source": "\(constants.source)", "event": "end_livechat", "params": {
        "slug": "\(config.slug)",
        "identifier": "\(self.identifier)",
        "assistant_id": \(self.assistantId),
        "widget_id": \(self.widgetId),
        "homol": true,
        "url_params": {}
        }
        }
        """
        
        socket.sendMessage(message: sendMessage)
    }
    
    @objc func didReceiveMessage(notification: NSNotification) {
        if let message = notification.userInfo?["message"] as? String {
            guard let data = message.data(using: .utf8) else { return }
            
            if message.contains("connected") {
                let eventDecoder = EventConnectionModelDecoder()
                if let event = eventDecoder.eventConnectionModel(decodedFrom: data) {
                    let sessionDB = dBManager.getChatSessions().first(where: {$0.sourceId == self.sourceId})
                    let newConnection = sessionDB?.chatId == self.identifier ? false : true
                    
                    config.slug = event.data.slug
                    self.assistantId = event.data.assistantId
                    self.widgetId = event.data.widgetId
                    
                    if sessionDB?.chatId != event.data.identifier {
                        dBManager.addChatSession(widgetIdValue: event.data.widgetId, sourceIdValue: self.sourceId, chatIdValue: event.data.identifier, startDateValue: Date(), endDateValue: Date(), closedValue: false, inactivityValue: 10, hasLiveChatValue: false)
                    }
                    
                    output?.connected(isNewConnection: newConnection, widgetId: event.data.widgetId)
                }
            } else if message.contains("chat_message")  {
                let eventDecoder = EventMessageModelDecoder()
                if let event = eventDecoder.eventMessageModel(decodedFrom: data) {
                    if let session = dBManager.getChatSessions().first(where: {$0.chatId == self.identifier}) {
                        dBManager.addChatMessage(sessionIdValue: session.sessionId, widgetIdValue: session.widgetId, eventDataValue: data, typeValue: "botMessage", dateValue: Date())
                    }
                    output?.didReceiveMessage(event: event)
                }
            } else if message.contains("end_chat") {
                let sessionID = dBManager.getChatSessions().first(where: {$0.sourceId == self.sourceId})?.sessionId ?? 0
                dBManager.updateChatSession(sessionIdValue: sessionID, closedValue: true, hasLiveChatValue: false)
                
                if let session = dBManager.getChatSessions().first(where: {$0.chatId == self.identifier}) {
                    dBManager.addChatMessage(sessionIdValue: session.sessionId, widgetIdValue: session.widgetId, eventDataValue: data, typeValue: "endChat", dateValue: Date())
                }
                output?.didReceiveEndChat()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.socket.disconnect()
                }
            } else if message.contains("start_livechat") {
                let sessionID = dBManager.getChatSessions().first(where: {$0.sourceId == self.sourceId})?.sessionId ?? 0
                dBManager.updateChatSession(sessionIdValue: sessionID, closedValue: false, hasLiveChatValue: true)
                
                output?.didReceiveStartLiveChat()
            } else if message.contains("end_livechat") {
                let sessionID = dBManager.getChatSessions().first(where: {$0.sourceId == self.sourceId})?.sessionId ?? 0
                
                dBManager.updateChatSession(sessionIdValue: sessionID, closedValue: false, hasLiveChatValue: false)
                output?.didReceiveEndLiveChat()
            }
        }
    }
    
    @objc func connectionSocketError(notification: NSNotification) {
        output?.connectionError()
    }
}
