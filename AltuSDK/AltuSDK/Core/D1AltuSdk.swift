//
//  D1AltuSdk.swift
//  AltuSDK
//
//  Created by Ricardo Caldeira on 24/03/22.
//
import UIKit

@objcMembers public class D1AltuSdk: NSObject {
    
    static public private(set) var sharedInstance = D1AltuSdk()
    
    private var config: D1AltuSdkConfig?
    private var constants: ConstantsAltu
    
    private override init() {
        self.constants = ConstantsAltu.init()
    }
    
    public func setup(config: D1AltuSdkConfig) {
        self.config = config
    }
    
    public func openChat(viewController: UIViewController,
                         widgetIdentifier: String,
                         sourceId: String,
                         data: [String:String]? = nil,
                         extraHash: String? = nil) {
        guard let chatViewController = UIStoryboard(name: "ChatViewController", bundle: Bundle(for: ChatViewController.self)).instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController else { return }
    
        chatViewController.config = config
        chatViewController.widgetIdentifier = widgetIdentifier
        chatViewController.sourceId = sourceId
        chatViewController.data = data
        chatViewController.extraHash = extraHash
        chatViewController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        
        viewController.present(chatViewController, animated: true, completion: nil)
    }
}
