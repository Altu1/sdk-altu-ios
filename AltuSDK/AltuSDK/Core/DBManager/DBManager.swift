//
//  DBManager.swift
//  AltuSDK
//
//  Created by Ricardo Caldeira on 24/03/22.
//

import Foundation

class DBManager {
     
    // sqlite instance
    private var db: ConnectionSQL!
     
    // table instance
    private var chatSessions: Table!
    private var chatMessages: Table!
 
    // columns instances of table
    private var id: Expression<Int64>!
    private var sessionId: Expression<Int64>!
    private var widgetId: Expression<String>!
    private var sourceId: Expression<String>!
    private var chatId: Expression<String>!
    private var date: Expression<Date>!
    private var startDate: Expression<Date>!
    private var endDate: Expression<Date>!
    private var closed: Expression<Bool>!
    private var inactivity: Expression<Int64>!
    private var eventData: Expression<Data>!
    private var type: Expression<String>!
    private var hasLiveChat: Expression<Bool>!
     
    // constructor of this class
    init () {
         
        // exception handling
        do {
             
            // path of document directory
            let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
 
            // creating database connection
            db = try ConnectionSQL("\(path)/d1_altu_sdk.sqlite3")
             
            // creating table object
            chatSessions = Table("chatSessions")
            chatMessages = Table("chatMessages")
             
            // create instances of each column
            id = Expression<Int64>("id")
            sessionId = Expression<Int64>("sessionId")
            widgetId = Expression<String>("widgetId")
            sourceId = Expression<String>("sourceId")
            chatId = Expression<String>("chatId")
            date = Expression<Date>("date")
            startDate = Expression<Date>("startDate")
            endDate = Expression<Date>("endDate")
            closed = Expression<Bool>("closed")
            inactivity = Expression<Int64>("inactivity")
            eventData = Expression<Data>("eventData")
            type = Expression<String>("type")
            hasLiveChat = Expression<Bool>("hasLiveChat")
             
            // check if the user's table is already created
            if (!UserDefaults.standard.bool(forKey: "is_db_chat_d1_created")) {
 
                // if not, then create the table
                try db.run(chatSessions.create { (t) in
                    t.column(sessionId, primaryKey: true)
                    t.column(widgetId)
                    t.column(sourceId)
                    t.column(chatId)
                    t.column(startDate)
                    t.column(endDate)
                    t.column(closed)
                    t.column(inactivity)
                    t.column(hasLiveChat)
                })
                
                // if not, then create the table
                try db.run(chatMessages.create { (t) in
                    t.column(id, primaryKey: true)
                    t.column(sessionId)
                    t.column(widgetId)
                    t.column(eventData)
                    t.column(type)
                    t.column(date)
                })
                 
                // set the value to true, so it will not attempt to create the table again
                UserDefaults.standard.set(true, forKey: "is_db_chat_d1_created")
            }
             
        } catch {
            // show error message if any
            print(error.localizedDescription)
        }
         
    }
}

//MARK: CRUD ChatSessionModelDB
extension DBManager {
    public func addChatSession(widgetIdValue: String,
                               sourceIdValue: String,
                               chatIdValue: String,
                               startDateValue: Date,
                               endDateValue: Date,
                               closedValue: Bool,
                               inactivityValue: Int64,
                               hasLiveChatValue: Bool) {
        do {
            try db.run(chatSessions.insert(widgetId <- widgetIdValue,
                                           sourceId <- sourceIdValue,
                                           chatId <- chatIdValue,
                                           startDate <- startDateValue,
                                           endDate <- endDateValue,
                                           closed <- closedValue,
                                           inactivity <- inactivityValue,
                                           hasLiveChat <- hasLiveChatValue))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // return array of ChatSessions model
    public func getChatSessions() -> [ChatSessionModelDB] {
         
        // create empty array
        var chatSessionsModel: [ChatSessionModelDB] = []
     
        // get all users in descending order
        chatSessions = chatSessions.order(sessionId.desc)
     
        // exception handling
        do {
     
            // loop through all users
            for row in try db.prepare(chatSessions) {
     
                // create new model in each loop iteration
                let chatSessionModel: ChatSessionModelDB = ChatSessionModelDB()
     
                // set values in model from database
                chatSessionModel.sessionId = row[sessionId]
                chatSessionModel.widgetId = row[widgetId]
                chatSessionModel.sourceId = row[sourceId]
                chatSessionModel.chatId = row[chatId]
                chatSessionModel.startDate = row[startDate]
                chatSessionModel.endDate = row[endDate]
                chatSessionModel.closed = row[closed]
                chatSessionModel.inactivity = row[inactivity]
                chatSessionModel.hasLiveChat = row[hasLiveChat]
     
                // append in new array
                chatSessionsModel.append(chatSessionModel)
            }
        } catch {
            print(error.localizedDescription)
        }
     
        // return array
        return chatSessionsModel
    }
    
    // function to delete session
    public func deleteChatSession(sessionIdValue: Int64) {
        do {
            try db.execute("DELETE FROM \"chatSessions\" WHERE sessionId = \(sessionIdValue);")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // function to update user
    public func updateChatSession(sessionIdValue: Int64, closedValue: Bool, hasLiveChatValue: Bool) {
        do {
            // get user using ID
            let session: Table = chatSessions.filter(sessionId == sessionIdValue).limit(1)
             
            // run the update query
            try db.run(session.update(closed <- closedValue, endDate <- Date(), hasLiveChat <- hasLiveChatValue))
        } catch {
            print(error.localizedDescription)
        }
    }
}

//MARK: CRUD ChatMessageModelDB
extension DBManager {
    public func addChatMessage(sessionIdValue: Int64,
                               widgetIdValue: String,
                                eventDataValue: Data,
                                typeValue: String,
                                dateValue: Date) {
        do {
            try db.run(chatMessages.insert(sessionId <- sessionIdValue,
                                           widgetId <- widgetIdValue,
                                           eventData <- eventDataValue,
                                          type <- typeValue,
                                          date <- dateValue))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // return array of ChatMessages model
    public func getChatMessages() -> [ChatMessageModelDB] {
         
        // create empty array
        var chatMessagesModel: [ChatMessageModelDB] = []
     
        // get all users in descending order
        chatMessages = chatMessages.order(id.asc)
     
        // exception handling
        do {
     
            // loop through all users
            for row in try db.prepare(chatMessages) {
     
                // create new model in each loop iteration
                let chatMessageModel: ChatMessageModelDB = ChatMessageModelDB()
     
                // set values in model from database
                chatMessageModel.id = row[id]
                chatMessageModel.sessionId = row[sessionId]
                chatMessageModel.widgetId = row[widgetId]
                chatMessageModel.eventData = row[eventData]
                chatMessageModel.type = row[type]
                chatMessageModel.date = row[date]
     
                // append in new array
                chatMessagesModel.append(chatMessageModel)
            }
        } catch {
            print(error.localizedDescription)
        }
     
        // return array
        return chatMessagesModel
    }
    
    // function to delete chatMessage
    public func deleteChatMessage(idValue: Int64) {
        do {
            try db.execute("DELETE FROM \"chatMessages\" WHERE id = \(idValue);")
        } catch {
            print(error.localizedDescription)
        }
    }
}
