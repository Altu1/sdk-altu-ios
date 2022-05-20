//
//  ChatSessionModelDB.swift
//  AltuSDK
//
//  Created by Ricardo Caldeira on 12/04/22.
//

import Foundation

class ChatSessionModelDB: Identifiable {
    public var sessionId: Int64 = 0
    public var widgetId: String = ""
    public var sourceId: String = ""
    public var chatId: String = ""
    public var startDate: Date = Date()
    public var endDate: Date = Date()
    public var closed: Bool = true
    public var inactivity: Int64 = 0
    public var hasLiveChat: Bool = false
}
