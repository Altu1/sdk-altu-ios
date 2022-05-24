//
//  ChatViewModel.swift
//  AltuSDK
//
//  Created by Ricardo Caldeira on 01/04/22.
//

import UIKit

protocol ChatViewModelType {
    
    // MARK: Inputs
    func setup()
    func sendMessage(chatMessage: ChatMessageModel)
    func setData(data: [String:String])
    func setExtraHash(extraHash: String)
    func setSourceId(sourceId: String)
    func setWidgetIdentifier(widgetIdentifier: String)
    func sendEndLiveChat()
    func reloadTableViewAndScrollToBottom()
    
    // MARK: Outputs
    var footerStackViewIsHidden: ((Bool) -> Void)? { get set }
    var snackViewIsHidden: ((Bool) -> Void)? { get set }
    var reloadTableView: ((Int) -> Void)? { get set }
    var hiddenLoading: ((Bool) -> Void)? { get set }
    var showAlertView: ((String) -> Void)? { get set }
    
    // MARK: properties
    var config: D1AltuSdkConfig { get }
    var dBManager: DBManager { get }
    var messages: [ChatMessageModel] { get }
    var data: [String:String]? { get }
    var extraHash: String? { get }
    var sourceId: String? { get }
    var widgetIdentifier: String? { get }
    var snackViewShowIsHidden: Bool { get }
    var footerStackViewShowIsHidden: Bool { get }
    var chatManager: ChatManagerType? { get }
}

class ChatViewModel: NSObject, ChatViewModelType {
    
    // MARK: Outputs
    var footerStackViewIsHidden: ((Bool) -> Void)?
    var snackViewIsHidden: ((Bool) -> Void)?
    var reloadTableView: ((Int) -> Void)?
    var hiddenLoading: ((Bool) -> Void)?
    var showAlertView: ((String) -> Void)?
    
    // MARK: Variable
    var messages: [ChatMessageModel] = []
    var config: D1AltuSdkConfig
    var chatManager: ChatManagerType?
    var data: [String:String]? = nil
    var sourceId: String? = nil
    var extraHash: String? = nil
    var widgetIdentifier: String? = nil
    var dBManager: DBManager
    
    var snackViewShowIsHidden = true {
        didSet {
            snackViewIsHidden?(snackViewShowIsHidden)
        }
    }
    
    var footerStackViewShowIsHidden = false {
        didSet {
            if snackViewShowIsHidden {
                footerStackViewIsHidden?(footerStackViewShowIsHidden)
            } else {
                footerStackViewIsHidden?(false)
            }
        }
    }
    
    init(config: D1AltuSdkConfig) {
        self.config = config
        self.dBManager = DBManager()
    }
    
    func setup() {
        
        self.chatManager = ChatFactory().makeChatManager(config: config,
                                                         output: self,
                                                         widgetIdentifier: widgetIdentifier ?? "",
                                                         sourceId: sourceId ?? "",
                                                         data: data,
                                                         extraHash: extraHash)
        
        footerStackViewShowIsHidden = true
        
        if let session = dBManager.getChatSessions().first(where: {$0.sourceId == self.sourceId}), session.closed == false { // conversa ainda em andamento
            loadBankMessages(widgetId: session.widgetId)
            chatManager?.connectSocket(identifier: session.chatId)
            snackViewShowIsHidden = session.hasLiveChat == false
        } else { // Nova conexão
            chatManager?.connectSocket(identifier: nil)
            snackViewShowIsHidden = true
        }
    }
    
    private func loadBankMessages(widgetId: String) {
        
        //Deletando mensagens e deixando só as 100 ultimas
        let messagesDB = dBManager.getChatMessages()
        
        var messagesWithWidgetIdEqual: [ChatMessageModelDB] = []
        for message in messagesDB {
            if message.widgetId == widgetId {
                messagesWithWidgetIdEqual.append(message)
            }
        }
        if messagesWithWidgetIdEqual.count > 100 {
            let amountToDelete = messagesWithWidgetIdEqual.count - 100
            for i in 0...amountToDelete {
                dBManager.deleteChatMessage(idValue: messagesWithWidgetIdEqual[i].id)
            }
        }
        
        //Load realmente
        let messagesDBAfterDelete = dBManager.getChatMessages()
        let sessionsDB = dBManager.getChatSessions()
        
        if let session = sessionsDB.first(where: {$0.sourceId == self.sourceId}), session.closed == false {
            for message in messagesDBAfterDelete {
                let showPreviousMessages: Bool = config.conversationHistory == .ALWAYS ? true : message.sessionId == session.sessionId
                if message.widgetId == session.widgetId && showPreviousMessages {
                    var type: MessageType?
                    switch message.type {
                    case "userMessage":
                        type = .userMessage
                    case "botMessage":
                        type = .botMessage
                    case "endChat":
                        type = .endChat
                    default:
                        break
                    }
                    
                    if type == .endChat {
                        messages.append(ChatMessageModel(type: .endChat, date: Date()))
                    } else if let type = type, type == .userMessage || type == .botMessage {
                        let eventDecoder = EventMessageModelDecoder()
                        if let event = eventDecoder.eventMessageModel(decodedFrom: message.eventData) {
                            for data in event.data {
                                if data.type == "text" {
                                    if messages.last?.date?.minorDate(dateMessageCurrent: message.date) == true || messages.count <= 1 {
                                        messages.append(ChatMessageModel(type: .dateMessage, message: message.date.dateInWriting(), date: message.date, showAvatar: false))
                                    }
                                    
                                    messages.append(ChatMessageModel(type: type, message: data.text, date: message.date, showAvatar: type == .botMessage ? true : false))
                                    
                                    if type == .userMessage {
                                        footerStackViewShowIsHidden = true
                                    }
                                } else if data.type == "text_input" {
                                    footerStackViewShowIsHidden = false
                                }
                                
                            }
                        }
                    }
                }
            }
        }
        reloadTableViewAndScrollToBottom()
    }
    
    func setData(data: [String : String]) {
        self.data = data
    }
    
    func setSourceId(sourceId: String) {
        self.sourceId = sourceId
    }
    
    func setExtraHash(extraHash: String) {
        self.extraHash = extraHash
    }
    
    func setWidgetIdentifier(widgetIdentifier: String) {
        self.widgetIdentifier = widgetIdentifier
    }
    
    func sendEndLiveChat() {
        snackViewShowIsHidden = true
        chatManager?.sendMessageEndLiveChat()
    }
    
    func reloadTableViewAndScrollToBottom() {
        if self.messages.count > 1 {
            reloadTableView?(self.messages.count-1)
        } else {
            reloadTableView?(0)
        }
    }
}

// MARK: - chatTableView DataSource and Delegate
extension ChatViewModel: UITableViewDataSource, UITableViewDelegate {
    
    func sendMessage(chatMessage: ChatMessageModel) {
        footerStackViewShowIsHidden = true
        
        if let date = chatMessage.date, messages.last?.date?.minorDate(dateMessageCurrent: date) == true {
            messages.append(ChatMessageModel(type: .dateMessage, message: date.dateInWriting(), date: date, showAvatar: false))
        }
        
        messages.append(chatMessage)
        chatManager?.sendMessage(message: chatMessage.message)
        reloadTableViewAndScrollToBottom()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let typeMessage = messages[indexPath.row].type
        
        switch typeMessage {
        case .simpleMessage, .dateMessage:
            if let cell = tableView.dequeueReusableCell(withIdentifier: SimpleTextViewCell.identifier, for: indexPath) as? SimpleTextViewCell {
                
                let myString = messages[indexPath.row].message
                let myAttribute = [ NSAttributedString.Key.foregroundColor: config.secundaryTextColor ]
                let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
                
                cell.configure(type: typeMessage, message: myAttrString, textAlignment: .center)
                return cell
            }
        case .botMessage, .userMessage:
            if let cell = tableView.dequeueReusableCell(withIdentifier: BalloonMessageViewCell.identifier, for: indexPath) as? BalloonMessageViewCell {
                
                if messages.count - 1 > indexPath.row {
                    cell.configure(chatMessage: messages[indexPath.row], nextMessageType: messages[indexPath.row + 1].type, config: config)
                } else {
                    cell.configure(chatMessage: messages[indexPath.row], nextMessageType: nil, config: config)
                }
                
                if snackViewShowIsHidden {
                    footerStackViewIsHidden?(footerStackViewShowIsHidden)
                } else {
                    footerStackViewIsHidden?(false)
                }
                
                return cell
            }
        case .endChat:
            if let cell = tableView.dequeueReusableCell(withIdentifier: SeparatorViewCell.identifier, for: indexPath) as? SeparatorViewCell {
                
                if indexPath.row == messages.count-1 {
                    cell.configure(height: 1, radius: 1, backgroundColor: UIColor.white, marginTop: 1, marginBottom: 1, marginLeft: 1, marginRight: 1)
                } else {
                    cell.configure(height: 1, radius: 1, backgroundColor: UIColor.gray, marginTop: 8, marginBottom: 20, marginLeft: 16, marginRight: 16)
                }
                return cell
            }
        }
        
        return UITableViewCell()
    }
}

// MARK: Manager Output
extension ChatViewModel: ChatManagerOutput {
    func connected(isNewConnection: Bool, widgetId: String) {
        if isNewConnection {
            loadBankMessages(widgetId: widgetId)
            chatManager?.sendMessage(message: "")
        } else {
            hiddenLoading?(true)
            if messages.count > 1 {
                reloadTableViewAndScrollToBottom()
            }
        }
    }
    
    func connectionError() {
        showAlertView?("Ocorreu um erro ao tentar se conectar ao atendimento. Tente novamente mais tarde.")
    }
    
    func didReceiveMessage(event: EventMessageModel) {
        for data in event.data {
            if data.type == "text" {
                if messages.count <= 1 || messages.last?.date?.minorDate(dateMessageCurrent: Date()) == true {
                    messages.append(ChatMessageModel(type: .dateMessage, message: Date().dateInWriting(), date: Date(), showAvatar: false))
                }
                messages.append(ChatMessageModel(type: .botMessage, message: data.text, date: Date(), showAvatar: true))
            } else if data.type == "text_input" {
                footerStackViewShowIsHidden = false
            }
        }
        hiddenLoading?(true)
        reloadTableViewAndScrollToBottom()
    }
    
    func didReceiveEndChat() {
        messages.append(ChatMessageModel(type: .endChat, date: Date()))
        reloadTableViewAndScrollToBottom()
    }
    
    func didReceiveEndLiveChat() {
        snackViewShowIsHidden = true
    }
    
    func didReceiveStartLiveChat() {
        snackViewShowIsHidden = false
    }
}
