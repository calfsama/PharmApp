//
//  AppDelegate.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 01/09/22.
//

import UIKit
import CoreData
import FirebaseCore
import FirebaseMessaging
import KeychainAccess
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
        let BarButtonItemAppearance = UIBarButtonItem.appearance()
        BarButtonItemAppearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .normal)
        
        let backBarBtnItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    
//            navigationItem.backBarButtonItem = backBarBtnItem
        BarButtonItemAppearance.setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .highlighted)
        
        let tab = MainTabBarViewController()
//        let tab = LogoLaunchScreenViewController()
        tab.navigationItem.backBarButtonItem = backBarBtnItem
        self.window?.rootViewController = tab
        self.window?.makeKeyAndVisible()
        
        
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
       
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { success, _ in
            guard success else { return }
            print("Success in APNS registry")
        }
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        return true
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("DEBUG / PUSH NOTIFICATION / Firebase registration token: \(fcmToken ?? "")")
        let keychain = Keychain(service: "tj.info.Salomat")
        keychain["fcmToken"] = fcmToken
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([ .alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("received")
    }
    func applicationWillTerminate(_ application: UIApplication) {
        
        self.saveContext()
    }
    
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer (name: "Favorites")
        container.loadPersistentStores(completionHandler: {( storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unsolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do{
                try context.save()
            }catch{
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}



