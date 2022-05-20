//
//  AppDelegate.swift
//  D1 AltuSDK Sample
//
//  Created by Ricardo Caldeira on 24/03/22.
//

import UIKit
import UserNotifications
import AltuSDK
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        registerForPushNotifications(application: application)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func registerForPushNotifications(application: UIApplication) {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.badge, .sound, .alert]) {
            [weak self] success, _ in
            guard success else { return }
            
            center.delegate = self
            
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        UserDefaults.standard.set(deviceToken, forKey: "deviceToken")
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void) {
            
            if #available(iOS 14.0, *) {
                completionHandler([[.banner, .list, .sound, .badge]])
            } else {
                completionHandler([[.alert, .sound]])
            }
        }
    
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {
            
            if isD1PushChat(userInfo: response.notification.request.content.userInfo) {
                
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                      let rootViewController = appDelegate.window!.rootViewController else { return }
                
                if let cid = response.notification.request.content.userInfo["_d1_cid"] as? [AnyHashable : Any], let vc = rootViewController as? ViewController {
                    
                    let sourceID: String = cid["sourceId"] as? String ?? ""
                    let widgetIdentifier: String = cid["widgetIdentifier"] as? String ?? ""
                    
                    vc.openChat(widgetIdentifier: widgetIdentifier, sourceId: sourceID)
                }
                
                completionHandler()
            } else {
                completionHandler()
            }
        }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    }
    
    public func isD1PushChat(userInfo: [AnyHashable : Any]) -> Bool {
        if userInfo["_d1_cid"] != nil {
            return true
        } else {
            return false
        }
    }
}
