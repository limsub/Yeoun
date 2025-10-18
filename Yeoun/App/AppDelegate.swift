//
//  AppDelegate.swift
//  Yeoun
//
//  Created by 임승섭 on 1/25/25.
//

import UIKit
import FirebaseCore
import FirebaseAnalytics
import RealmSwift
import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Firebase Consol
        FirebaseApp.configure()
        Analytics.logEvent(AnalyticsEventAppOpen, parameters: nil)
        
        // Initialize the Google Mobile Ads SDK
        GADMobileAds.sharedInstance().start(completionHandler: nil)
//        UserDefaults.standard.set(true , forKey: "isMyDevice")
        
        // Realm
        let config = Realm.Configuration(
            schemaVersion: 2) { migration, oldSchemaVersion in
                if oldSchemaVersion < 2 {
                    migration.enumerateObjects(
                        ofType: DetailDBDTO.className()) { oldObject, newObject in
                            
                            guard let oldObject = oldObject, let newObject = newObject else { return }
                            
                            // 기존 content 값 가져옴
                            let content = oldObject["content"] as? String ?? ""
                            
                            // 첫 줄까지 추출
                            let firstLine = content.components(separatedBy: .newlines).first ?? ""
                            
                            // schema version 2에 새로 추가한 "title"에 값 설정
                            newObject["title"] = firstLine
                        }
                }
            }
        Realm.Configuration.defaultConfiguration = config

        return true
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


}

