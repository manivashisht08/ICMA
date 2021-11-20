//
//  AppDelegate.swift
//  ICMA
//
//  Created by Dharmani Apps on 05/10/21.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    /// keyboard configutation
    private func configureKeboard() {
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        //        IQKeyboardManager.shared.toolbarTintColor = SSColor.appBlack
        IQKeyboardManager.shared.enableAutoToolbar = true
        //        IQKeyboardManager.shared.disabledDistanceHandlingClasses = [ChatDetailsVC.self, ChatViewController.self]
        IQKeyboardManager.shared.toolbarPreviousNextAllowedClasses = [UIScrollView.self,UIView.self,UITextField.self,UITextView.self,UIStackView.self]
        
    }
    /// to get custom added font names
    private func getCustomFontDetails() {
        
        #if DEBUG
        for family in UIFont.familyNames {
            let sName: String = family as String
            debugPrint("family: \(sName)")
            for name in UIFont.fontNames(forFamilyName: sName) {
                debugPrint("name: \(name as String)")
            }
        }
        #endif
    }
    
    //    func logout() {
    //        UserDefaults.standard.removeObject(forKey: "id")
    //        UserDefaults.standard.removeObject(forKey: "authToken")
    //        UserDefaults.standard.removeObject(forKey: "deviceToken")
    //
    //        let homeViewController = LogInVC.instantiate(fromAppStoryboard: .Auth)
    //        let nav = UINavigationController.init(rootViewController: homeViewController)
    //        nav.isNavigationBarHidden = true
    //        AppDel().window?.rootViewController = nav
    //    }
    
    public func configureNavigationBar() {
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            //            appearance.backgroundColor = SSColor.appBlack
            //            appearance.titleTextAttributes = [.foregroundColor:SSColor.appBlack, .font: ICFont.PoppinsRegular(size: SSFont.defaultRegularFontSize)]
            //            appearance.largeTitleTextAttributes = [.foregroundColor: SSColor.appBlack, .font: SSFont.PoppinsRegular(size: SSFont.defaultRegularFontSize)]
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 133.0/255.0, green: 38.0/255.0, blue:120.0/255.0, alpha: 1.0)], for: .selected)
            //            UINavigationBar.appearance().barTintColor = SSColor.appBlack
            //            UINavigationBar.appearance().tintColor = SSColor.appBlack
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        } else {
            //            UINavigationBar.appearance().barTintColor = SSColor.appBlack
            //            UINavigationBar.appearance().tintColor = SSColor.appBlack
            UINavigationBar.appearance().isTranslucent = false
        }
    }
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions) { (bloo, error) in
                
            }
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        configureKeboard()
        getCustomFontDetails()
        configureNavigationBar()
        setRootVC()
//        setInitialLanding()
        //        logInDefaults()
        //         navigationApi()
        sleep(2)
        //        window?.tintColor = SSColor.appBlack
        UITabBar.appearance().tintColor = #colorLiteral(red: 0.391271323, green: 0.1100022718, blue: 0.353789866, alpha: 1)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Poppins-Medium", size: 12)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Poppins-Medium", size: 12)], for: .selected)
        UITabBar.appearance().unselectedItemTintColor = #colorLiteral(red: 0.2668271065, green: 0.2587364316, blue: 0.2627768517, alpha: 1)
        // Override point for customization after application launch.
        return true
    }
    
    func setRootVC(){
        if AFWrapperClass.getAuthToken().isEmpty{
            print("empty token")
            let vc = LogInVC.instantiate(fromAppStoryboard: .Main)
            let nav = UINavigationController(rootViewController: vc)
            nav.isNavigationBarHidden = true
            self.window?.rootViewController = nav
            self.window?.makeKeyAndVisible()
        }else{
            print("non empty token")
            let vc = TabBarVC.instantiate(fromAppStoryboard: .Main)
            let nav = UINavigationController(rootViewController: vc)
            nav.isNavigationBarHidden = true
            self.window?.rootViewController = nav
            self.window?.makeKeyAndVisible()
        }
    }
//    func setInitialLanding(){
//        let vc = SplashScreenVC.instantiate(fromAppStoryboard: .Main)
//        let nav = UINavigationController(rootViewController: vc)
//        nav.isNavigationBarHidden = true
//        AppDelegate().window?.rootViewController = nav
//    }
    
    func logInDefaults(){
        if let userId = UserDefaults.standard.value(forKey: "Uid") as? String{
            if userId != ""{
                let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                let rootVc = storyBoard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
                let nav = UINavigationController(rootViewController: rootVc)
                nav.isNavigationBarHidden = true
                self.window?.rootViewController = nav
                self.window?.makeKeyAndVisible()
            }else{
                let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                let rootVc = storyBoard.instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
                let nav = UINavigationController(rootViewController: rootVc)
                nav.isNavigationBarHidden = true
                self.window?.rootViewController = nav
                self.window?.makeKeyAndVisible()
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        print("device token is \(deviceTokenString)")
        setAppDefaults(deviceTokenString, key: "deviceToken")
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
    
    
}
extension AppDelegate {
    func navigationApi(){
        let id = UserDefaults.standard.value(forKey: "id")
        if id != nil{
            let Tabbar = TabBarVC.instantiate(fromAppStoryboard: .Main)
            let nav = UINavigationController(rootViewController: Tabbar)
            nav.setNavigationBarHidden(true, animated: true)
            AppDel().window?.rootViewController = nav
        }else{
            let login = LogInVC.instantiate(fromAppStoryboard: .Main)
            let nav = UINavigationController(rootViewController: login)
            nav.setNavigationBarHidden(true, animated: true)
            AppDel().window?.rootViewController = nav
        }
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "id")
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "deviceToken")
        let homeViewController = LogInVC.instantiate(fromAppStoryboard: .Main)
        let nav = UINavigationController.init(rootViewController: homeViewController)
        nav.isNavigationBarHidden = true
        AppDel().window?.rootViewController = nav
    }
}

@available(iOS 12.0, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
 
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if let userInfo = notification.request.content.userInfo as? [String:Any]{
            print(userInfo)
            if let apnsData = userInfo["aps"] as? [String:Any]{
                if let dataObj = apnsData["data"] as? [String:Any]{
                    let notificationType = dataObj["notification_type"] as? String
                    let state = UIApplication.shared.applicationState
                }
            }
        }
        
        
        
        
        // Print full message.
        // print("user info is \(userInfo)")
        
        // Change this to your preferred presentation option
        // completionHandler([])
        //Show Push notification in foreground
        // completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if let userInfo = response.notification.request.content.userInfo as? [String:Any]{
            print(userInfo)
            if let apnsData = userInfo["aps"] as? [String:Any]{
                if let dataObj = apnsData["data"] as? [String:Any]{
                    let notificationType = dataObj["notification_type"] as? String
                    let childId = dataObj["child_id"] as? String
                    
                    let state = UIApplication.shared.applicationState
                    if state != .active{
                        
                    }
                }
            }
        }
        completionHandler()
    }
    
    func convertStringToDictionary(json: String) -> [String: AnyObject]? {
        if let data = json.data(using: String.Encoding.utf8) {
            let json = try? JSONSerialization.jsonObject(with: data, options:.mutableContainers) as? [String: AnyObject]
            // if let error = error {
            // print(error!)
            //}
            return json!
        }
        return nil
    }
    
}
