//
//  D1AltuSdkConfig.swift
//  AltuSDK
//
//  Created by Ricardo Caldeira on 24/03/22.
//

import Foundation
import UIKit

@objcMembers public class D1AltuSdkConfig: NSObject {
    
    //MARK: Config settings
    public var webSocketEnvironment: Environment = .DEV
    public var environment: Environment = .DEV
    public var conversationHistory: ConversationHistory = .ALWAYS
    public var slug: String = ""
    public var secret: String = ""
    public var deviceToken: Data = Data()
    
    //MARK: Config colors
    public var mainColor: UIColor = UIColor(hexString: "#00284C")
    public var secundaryColor: UIColor = UIColor(hexString: "#098CFE")
    public var mainTextColor: UIColor = UIColor(hexString: "#1D1D1D")
    public var secundaryTextColor: UIColor = UIColor(hexString: "#A3A3A3")
    public var backgroundColor: UIColor = UIColor(hexString: "#EDEDED")
    
    //MARK: Title and menssage
    public var titleChat: String = ""
    
    //MARK: Avatar
    public var smallAvatar: UIImage?
    public var bigAvatar: UIImage?
    
    public func defineEnvironment(objcEnv: Int) {
        switch objcEnv {
        case 1:
            webSocketEnvironment = .PRD
        case 2:
            webSocketEnvironment = .STG
        case 3:
            webSocketEnvironment = .DEV
        default:
            webSocketEnvironment = .DEV
        }
    }
    
    public func defineAuthEnvironment(objcEnv: Int) {
        switch objcEnv {
        case 1:
            environment = .PRD
        case 2:
            environment = .STG
        case 3:
            environment = .DEV
        default:
            environment = .DEV
        }
    }
    
    public func customEnviromment(url: String) {
        webSocketEnvironment = .CUSTOM(environmentUrl: url)
    }
    
    public func customAuthEnviromment(url: String) {
        environment = .CUSTOM(environmentUrl: url)
    }
}

public enum Environment {
    case DEV
    case STG
    case PRD
    case CUSTOM(environmentUrl: String)
}

public enum ConversationHistory {
    case ONGOING
    case ALWAYS
}
