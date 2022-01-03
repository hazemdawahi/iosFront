//
//  AppDelegate.swift
//  ELearningProjectAbderrahmen&hazem
//
//  Created by Mac2021 on 6/11/2021.
//

import UIKit
import CoreData
import GoogleSignIn
import Braintree
import Parse
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes


@main
class AppDelegate: UIResponder, UIApplicationDelegate/*, GIDSignInDelegate*/ {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppCenter.start(withAppSecret: "1b6c1eec-896c-456d-8d9f-805f8aac7774", services:[
          Analytics.self,
          Crashes.self
        ])

        let configuration = ParseClientConfiguration {
            $0.applicationId = "ESPRIT.TN.ELearningProjectAbderrahmen-hazem.payments"
            //$0.clientKey = "73453057160-hlt2jkm1chiq7bo35t1h73fdbbgmts4n.apps.googleusercontent.com"
            $0.server = "mongodb+srv://ilearn:123@ilearn.qsvum.mongodb.net/ilearn?retryWrites=true&w=majority"
        }
        Parse.initialize(with: configuration)
        // Override point for customization after application launch.
        
        //GIDSignIn.sharedInstance().delegate = self
        
        BTAppSwitch.setReturnURLScheme("ESPRIT.TN.ELearningProjectAbderrahmen-hazem.payments")
        
        return true
        
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        /*return GIDSignIn.sharedInstance().handle(url as URL?,
                                                 sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication]as? String,
                                                 annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        */
        var handled: Bool



                 handled = GIDSignIn.sharedInstance.handle(url)

               if handled {

                 return true

               }


        if url.scheme?.localizedCaseInsensitiveCompare("ESPRIT.TN.ELearningProjectAbderrahmen-hazem.payments") == .orderedSame {
            //return BTAppSwitch.handleOpen(url, options: options)
        }
        return false
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error{
            print("\(error.localizedDescription)")
        }
        else{
            _ = user.userID
            let emailAddress = user.profile?.email
            
            let fullName = user.profile?.name
            _ = user.profile?.givenName
            _ = user.profile?.familyName
            
            _ = user.profile?.imageURL(withDimension: 320)
            print (fullName!)
            print(emailAddress!)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print ("User has disconnected")
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "ELearningProjectAbderrahmen_hazem")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

