//
//  AppDelegate.swift
//  RestauranteUniversitario
//
//  Created by Felipe Podolan Oliveira on 29/03/17.
//  Copyright © 2017 Felipe Podolan Oliveira. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications

/**
 This is a default delegate class of iOS apps. It provides methods to configure the app states (launch, resign, enter background and so on). It is also used to handle Firebase connection with the Firebase messaging server and to handle the received push notifications, tokens, etc.
 */
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {

    
    /// The instance of the app window object
    var window: UIWindow?

    /**
     Tells the delegate that the launch process is almost done and the app is almost ready to run.
     Use this method (and the corresponding application(_:willFinishLaunchingWithOptions:) method) to complete your app’s initialization and make any final tweaks. This method is called after state restoration has occurred but before your app’s window and other UI have been presented. At some point after this method returns, the system calls another of your app delegate’s methods to move the app to the active (foreground) state or the background state.
     This method represents your last chance to process any keys in the launchOptions dictionary. If you did not evaluate the keys in your application(_:willFinishLaunchingWithOptions:) method, you should look at them in this method and provide an appropriate response.
     Objects that are not the app delegate can access the same launchOptions dictionary values by observing the notification named UIApplicationDidFinishLaunching and accessing the notification’s userInfo dictionary. That notification is sent shortly after this method returns.
     - Important:
     For app initialization, it is highly recommended that you use this method and the application(_:willFinishLaunchingWithOptions:) method and do not use the applicationDidFinishLaunching(_:) method, which is intended only for apps that run on older versions of iOS.
     The return result from this method is combined with the return result from the application(_:willFinishLaunchingWithOptions:) method to determine if a URL should be handled. If either method returns false, the URL is not handled. If you do not implement one of the methods, only the return value of the implemented method is considered.
     - Parameters:
        - application: Your singleton app object.
        - launchOptions: A dictionary indicating the reason the app was launched (if any). The contents of this dictionary may be empty in situations where the user launched the app directly. For information about the possible keys in this dictionary and how to handle them, see Launch Options Keys.
     - Returns:
        false if the app cannot handle the URL resource or continue a user activity, otherwise return true. The return value is ignored if the app is launched as a result of a remote notification.
    */
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().shouldEstablishDirectChannel = true
        
        return true
    }

    /**
     Tells the delegate that the app is about to become inactive.
     This method is called to let your app know that it is about to move from the active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the app and it begins the transition to the background state. An app in the inactive state continues to run but does not dispatch incoming events to responders.
     You should use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game. An app in the inactive state should do minimal work while it waits to transition to either the active or background state.
     If your app has unsaved user data, you can save it here to ensure that it is not lost. However, it is recommended that you save user data at appropriate points throughout the execution of your app, usually in response to specific actions. For example, save data when the user dismisses a data entry screen. Do not rely on specific app state transitions to save all of your app’s critical data.
     After calling this method, the app also posts a UIApplicationWillResignActive notification to give interested objects a chance to respond to the transition.
     - Parameters:
        - application: Your singleton app object.
    */
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    /**
     Tells the delegate that the app is now in the background.
     Use this method to release shared resources, invalidate timers, and store enough app state information to restore your app to its current state in case it is terminated later. You should also disable updates to your app’s user interface and avoid using some types of shared system resources (such as the user’s contacts database). It is also imperative that you avoid using OpenGL ES in the background.
     Your implementation of this method has approximately five seconds to perform any tasks and return. If you need additional time to perform any final tasks, you can request additional execution time from the system by calling beginBackgroundTask(expirationHandler:). In practice, you should return from applicationDidEnterBackground(_:) as quickly as possible. If the method does not return before time runs out your app is terminated and purged from memory.
     You should perform any tasks relating to adjusting your user interface before this method exits but other tasks (such as saving state) should be moved to a concurrent dispatch queue or secondary thread as needed. Because it's likely any background tasks you start in applicationDidEnterBackground(_:) will not run until after that method exits, you should request additional background execution time before starting those tasks. In other words, first call beginBackgroundTask(expirationHandler:) and then run the task on a dispatch queue or secondary thread.
     The app also posts a UIApplicationDidEnterBackground notification around the same time it calls this method to give interested objects a chance to respond to the transition.
     - Parameters:
        - application: Your singleton app object.
     */
    func applicationDidEnterBackground(_ application: UIApplication) {
        Messaging.messaging().shouldEstablishDirectChannel = false
        print("Disconnected from FCM.")
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    /**
     Tells the delegate that the app is about to enter the foreground.
     In iOS 4.0 and later, this method is called as part of the transition from the background to the active state. You can use this method to undo many of the changes you made to your app upon entering the background. The call to this method is invariably followed by a call to the applicationDidBecomeActive(_:) method, which then moves the app from the inactive to the active state.
     The app also posts a UIApplicationWillEnterForeground notification shortly before calling this method to give interested objects a chance to respond to the transition.
     - Parameters:
        - application: Your singleton app object.
    */
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    /**
     Tells the delegate that the app has become active.
     This method is called to let your app know that it moved from the inactive to active state. This can occur because your app was launched by the user or the system. Apps can also return to the active state if the user chooses to ignore an interruption (such as an incoming phone call or SMS message) that sent the app temporarily to the inactive state.
     You should use this method to restart any tasks that were paused (or not yet started) while the app was inactive. For example, you could use it to restart timers or throttle up OpenGL ES frame rates. If your app was previously in the background, you could also use it to refresh your app’s user interface.
     After calling this method, the app also posts a UIApplicationDidBecomeActive notification to give interested objects a chance to respond to the transition.
     - Parameters:
        - application: Your singleton app object.
     */
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        connectToFcm()
        if let refreshedToken = InstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
            UserDefaults.standard.set(refreshedToken, forKey: "Firebase Token".localized)
        }
    }

    /**
     Tells the delegate when the app is about to terminate.
     This method lets your app know that it is about to be terminated and purged from memory entirely. You should use this method to perform any final clean-up tasks for your app, such as freeing shared resources, saving user data, and invalidating timers. Your implementation of this method has approximately five seconds to perform any tasks and return. If the method does not return before time expires, the system may kill the process altogether.
     For apps that do not support background execution or are linked against iOS 3.x or earlier, this method is always called when the user quits the app. For apps that support background execution, this method is generally not called when the user quits the app because the app simply moves to the background in that case. However, this method may be called in situations where the app is running in the background (not suspended) and the system needs to terminate it for some reason.
     After calling this method, the app also posts a UIApplicationWillTerminate notification to give interested objects a chance to respond to the transition.
     - Parameters:
        - application: Your singleton app object.
     */
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    /**
     Tells the delegate that the fcm_token has just been refreshed.
     - Parameters:
        - notification: the notification received
     */
    func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = InstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
            UserDefaults.standard.set(refreshedToken, forKey: "Firebase Token".localized)
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    
    /**
     Tells the delegate that the app is connected to the firebase server.
     */
    func connectToFcm() {
        //Messaging.messaging().shouldEstablishDirectChannel = true
        Messaging.messaging().connect { (error) in
            if (error != nil) {
                print("Unable to connect with FCM.")
                print(error!)
            } else {
                print("Connected to FCM.")
                Messaging.messaging().subscribe(toTopic: "/topics/all")
            }
        }
    }
    
    /**
     Tells the app that a remote notification arrived that indicates there is data to be fetched.
     Use this method to process incoming remote notifications for your app. Unlike the application(_:didReceiveRemoteNotification:) method, which is called only when your app is running in the foreground, the system calls this method when your app is running in the foreground or background. In addition, if you enabled the remote notifications background mode, the system launches your app (or wakes it from the suspended state) and puts it in the background state when a remote notification arrives. However, the system does not automatically launch your app if the user has force-quit it. In that situation, the user must relaunch your app or restart the device before the system attempts to launch your app automatically again.
     Note
     If the user opens your app from the system-displayed alert, the system may call this method again when your app is about to enter the foreground so that you can update your user interface and display information pertaining to the notification.
     When a remote notification arrives, the system displays the notification to the user and launches the app in the background (if needed) so that it can call this method. Launching your app in the background gives you time to process the notification and download any data associated with it, minimizing the amount of time that elapses between the arrival of the notification and displaying that data to the user.
     As soon as you finish processing the notification, you must call the block in the handler parameter or your app will be terminated. Your app has up to 30 seconds of wall-clock time to process the notification and call the specified completion handler block. In practice, you should call the handler block as soon as you are done processing the notification. The system tracks the elapsed time, power usage, and data costs for your app’s background downloads. Apps that use significant amounts of power when processing remote notifications may not always be woken up early to process future notifications.
     - Parameters:
        - application: Your singleton app object.
        - userInfo: A dictionary that contains information related to the remote notification, potentially including a badge number for the app icon, an alert sound, an alert message to display to the user, a notification identifier, and custom data. The provider originates it as a JSON-defined dictionary that iOS converts to an NSDictionary object; the dictionary may contain only property-list objects plus NSNull. For more information about the contents of the remote notification dictionary, see Local and Remote Notification Programming Guide.
        - handler: The block to execute when the download operation is complete. When calling this block, pass in the fetch result value that best describes the results of your download operation. You must call this handler and should do so as soon as possible. For a list of possible values, see the UIBackgroundFetchResult type.
     */
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        print("Message ID: \(userInfo["gcm.message_id"]!)")
        
        // Print full message.
        print("%@", userInfo)
    }
    
    /**
     This method is called whenever a push notification is received
     */
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // Let FCM know about the message for analytics etc.
        Messaging.messaging().appDidReceiveMessage(userInfo)
        // handle the message
        print(userInfo)
    }
    
    /**
     This method is called whenever a push message is received
     - Parameters:
        - messaging: singleton of the messaging class
        - remoteMessage: the message received
     */
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        let json = remoteMessage.appData  as! [String: Any]
        print(json)
        let type = json["type"] as! String
        let base_url = "API URL".localized;
        let environment = json["environment"] as! String
        if(base_url.range(of: environment)) != nil {
            if(type == "jwt_token") {
                let jwtToken = json["token"] as! String
                UserDefaults.standard.set(jwtToken, forKey: "JWT Token".localized)
                print("================JWT PUSH MESSAGE=====================")
                print("JWT Token received: " + jwtToken)
            }
        }
    }
    
    /**
     This method is called whenever the registration token is refreshed
     - Parameters:
        - messaging: singleton of the messaging class
        - fcmToken: the token refreshed
     */
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        UserDefaults.standard.set(fcmToken, forKey: "Firebase Token".localized)
        debugPrint("--->messaging:\(messaging)")
        debugPrint("--->didRefreshRegistrationToken:\(fcmToken)")
    }
    
}

