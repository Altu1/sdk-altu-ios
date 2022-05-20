//
//  ChatMessageModelDB.swift
//  AltuSDK
//
//  Created by Ricardo Caldeira on 12/04/22.
//

import Foundation

class ChatMessageModelDB: Identifiable {
    public var id: Int64 = 0
    public var sessionId: Int64 = 0
    public var widgetId: String = ""
    public var eventData: Data = Data()
    public var type: String = ""
    public var date: Date = Date()
}
