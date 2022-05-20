//
//  ChatFactory.swift
//  AltuSDK
//
//  Created by Ricardo Caldeira on 01/04/22.
//

import Foundation

class ChatFactory {
    
    func makeChatViewModel(config: D1AltuSdkConfig) -> ChatViewModelType {
        return ChatViewModel(config: config)
    }
    
    func makeChatManager(config: D1AltuSdkConfig,
                         output: ChatManagerOutput,
                         widgetIdentifier: String,
                         sourceId: String,
                         data: [String:String]? = nil,
                         extraHash: String? = nil) -> ChatManagerType {
        
        return ChatManager(config: config,
                           output: output,
                           widgetIdentifier: widgetIdentifier,
                           sourceId: sourceId,
                           data: data,
                           extraHash: extraHash)
    }
}
