//
//  LogInVC.swift
//  ICMA
//
//  Created by Dharmani Apps on 05/10/21.
//

import UIKit
import Foundation
import IQKeyboardManagerSwift

class LogInVC : BaseVC, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var btnRemember: ICRememberMeButton!
    @IBOutlet weak var txtPassword: ICPasswordTextField!
    @IBOutlet weak var txtEmail: ICEmailTextField!
    let rest = RestManager()
    var rememberMeSelected = false
//    var iconClick = true
    var returnKeyHandler: IQKeyboardReturnKeyHandler?
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    //------------------------------------------------------
    
    //MARK: Customs
    
    func setup() {
        
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        returnKeyHandler?.delegate = self
        
        txtEmail.delegate = self
        txtPassword.delegate = self

        
    }
    
    func validate() -> Bool {
        
        if ValidationManager.shared.isEmpty(text: txtEmail.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please enter email address", okButton: "OK", controller: self ){
            }
            return false
        }
        
        if ValidationManager.shared.isValid(text: txtEmail.text!, for: RegularExpressions.email) == false {
            showAlertMessage(title: kAppName.localized(), message: "Please enter valid email address", okButton: "OK", controller: self ){
                
            }
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: txtPassword.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please enter password", okButton: "OK", controller: self ){
                
            }
            return false
        }
        
        return true
    }
    open func signInApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title:"Loading...", view:self)
        }
    
        AFWrapperClass.requestPOSTURL(baseURL + WSMethods.signIn, params: generatingParameters(), headers: nil) { response in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            let message = response["message"] as? String ?? ""
            if let status = response["status"] as? Int {
                if status == 200{
                    if self.rememberMeSelected == true{
                        storeCredential(email: self.txtEmail.text!, password: self.txtPassword.text!)
                    }else{
                        removeCredential()
                    }
                    if let data = response["data"] as? [String:Any]{
                        let access_token = data["authtoken"] as? String ?? ""
                        print(access_token)
                        UserDefaults.standard.set(access_token, forKey: "token")
                        let userId = data["userid"] as? String ?? ""
                        UserDefaults.standard.set(userId, forKey: "id")

                    }
                    let controller = NavigationManager.shared.tabBarVC
                    self.push(controller: controller)
                }else{
                    alert(AppAlertTitle.appName.rawValue, message: message, view: self)
                }
            }

        } failure: { error in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
    }
    func generatingParameters() -> [String:AnyObject] {
        var parameters:[String:AnyObject] = [:]
        parameters["email"] = txtEmail.text  as AnyObject
        parameters["password"] = txtPassword.text  as AnyObject
        parameters["devicetype"] = "1"  as AnyObject
        var deviceToken  = getSAppDefault(key: "DeviceToken") as? String ?? ""
        if deviceToken == ""{
            deviceToken = "123"
        }
        parameters["devicetoken"] = deviceToken  as AnyObject
        print(parameters)
        return parameters
    }
//    open func resendEmailVerificationApi(){
//
//
//        guard let url = URL(string: kBASEURL + WSMethods.resentVerficationEmail) else { return }
//
//        rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
//        rest.httpBodyParameters.add(value:txtEmail.text ?? "", forKey:"email")
//
//        DispatchQueue.main.async {
//
////            AFWrapperClass.svprogressHudShow(title:"Loading...", view:self)
//        }
//
//        rest.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
//            DispatchQueue.main.async {
//
//                AFWrapperClass.svprogressHudDismiss(view: self)
//            }
//            guard let response = results.response else { return }
//            if response.httpStatusCode == 200 {
//                guard let data = results.data else { return }
//
//                let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyHashable] ?? [:]
//
//                let forgotResp = ForgotPasswordData.init(dict: jsonResult ?? [:])
//
//                if forgotResp?.status == 1{
//                    DispatchQueue.main.async {
//                        Alert.present(
//                            title: AppAlertTitle.appName.rawValue,
//                            message: forgotResp?.message ?? "",
//                            actions: .ok(handler: {
//                                self.navigationController?.popViewController(animated: true)
//                            }),
//                            from: self
//                        )
//                    }                }else{
//                        DispatchQueue.main.async {
//
//                            Alert.present(
//                                title: AppAlertTitle.appName.rawValue,
//                                message: forgotResp?.message ?? "",
//                                actions: .ok(handler: {
//                                }),
//                                from: self
//                            )
//                        }
//                    }
//
//
//            }else{
//                DispatchQueue.main.async {
//
//                    Alert.present(
//                        title: AppAlertTitle.appName.rawValue,
//                        message: AppAlertTitle.connectionError.rawValue,
//                        actions: .ok(handler: {
//                        }),
//                        from: self
//                    )
//                }
//            }
//        }
//    }
    
    
    //------------------------------------------------------
    
    //MARK: Action
    
    @IBAction func btnSignUp(_ sender: Any) {
        let controller = NavigationManager.shared.signUpVC
        push(controller: controller)
    }
    
    @IBAction func btnLogin(_ sender: Any) {
//        let isRemember  = getSAppDefault(key: "rememberMe") as? String ?? ""

        if validate() == false {
            return
        }

//        else if isRemember == "0"{
//            Alert.present(
//                title: AppAlertTitle.appName.rawValue,
//                message: AppRememberMeAlertMessage.rememberMe,
//                actions: .ok(handler: {
//                }),
//                from: self
//            )
//        }
        else{
         
            signInApi()
        }
//        let controller = NavigationManager.shared.tabBarVC
//        push(controller: controller)
    }
    @IBAction func rememberBtnAction(_ sender: UIButton) {
//        if sender.tag == 0{
//            sender.tag = 1
//            btnRemember.setImage(#imageLiteral(resourceName: "check"), for: .normal)
//            setAppDefaults("1", key: "rememberMe")
//        }else{
//            sender.tag = 0
//            btnRemember.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
//
//            setAppDefaults("0", key: "rememberMe")
//
//        }
        sender.isSelected = !sender.isSelected
        self.rememberMeSelected = sender.isSelected
        self.btnRemember.setImage(rememberMeSelected == true ? #imageLiteral(resourceName: "check") : #imageLiteral(resourceName: "uncheck"), for: .normal)
    }
    
    @IBAction func btnForgot(_ sender: Any) {
        let controller = NavigationManager.shared.forgotPasswordVC
        push(controller: controller)
    }
    
    func getEmail() -> String
       {
           if let email =  UserDefaults.standard.value(forKey:"userEmail")
           {
               rememberMeSelected = true
               return email as! String
           }
           else
           {
               rememberMeSelected = false
               return ""
           }
       }
       
       func getPassword() -> String
       {
           if let password =  UserDefaults.standard.value(forKey:"userPassword")
           {
               rememberMeSelected = true
               return password as! String
           }
           else
           {
               rememberMeSelected = false
               return ""

           }
       }
    
    //------------------------------------------------------
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case txtEmail:
            viewEmail.borderColor =  ICColor.appButton
        case txtPassword:
            viewPassword.borderColor =  ICColor.appButton
        default:break
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case txtEmail:
            viewEmail.borderColor =  ICColor.appBorder
        case txtPassword:
            viewPassword.borderColor = ICColor.appBorder
        default:break
        }
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        txtEmail.text = self.getEmail()
        txtPassword.text = self.getPassword()
        btnRemember.isSelected = rememberMeSelected
        
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
}

