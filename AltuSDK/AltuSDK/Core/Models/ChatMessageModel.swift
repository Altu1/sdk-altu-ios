//
//  ChatMessageModel.swift
//  AltuSDK
//
//  Created by Ricardo Caldeira on 01/04/22.
//

import Foundation

enum MessageType {
    case userMessage
    case botMessage
    case simpleMessage
    case dateMessage
    case endChat
}

struct ChatMessageModel {
    var type: MessageType
    var message: String
    var date: Date?
    var showAvatar: Bool
    
    init(type: MessageType,
         message: String = "",
         date: Date? = nil,
         showAvatar: Bool = false) {
        self.type = type
        self.message = message
        self.date = date
        self.showAvatar = showAvatar
    }
}
