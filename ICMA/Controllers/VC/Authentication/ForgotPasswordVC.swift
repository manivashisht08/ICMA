//
//  ForgotPasswordVC.swift
//  ICMA
//
//  Created by Dharmani Apps on 05/10/21.
//

import UIKit
import Foundation
import IQKeyboardManagerSwift

class ForgotPasswordVC : BaseVC, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var txtEmail: ICEmailTextField!
    let restF = RestManager()
    
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
    }
    
    
    func validate() -> Bool {
        
        if ValidationManager.shared.isEmpty(text: txtEmail.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please enter email address", okButton: "OK", controller: self ){
                
            }
            return false
        }
        return true
    }
    
    func prm() -> [String:Any]{
        let prm = ["email":txtEmail.text!]
        return prm
    }
    
    func forgotPasswordApi(email : String){
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURL(baseURL + ICMethods.forgotPassword, params: prm(), headers: nil) { (response) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            let message = response["message"] as? String ?? ""
            let status = response["status"] as? Int ?? 0
            
            if status == 200 {
                DispatchQueue.main.async {
                    showAlertMessage(title: kAppName.localized(), message: message, okButton: "OK", controller: self) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }else{
                alert(AppAlertTitle.appName.rawValue, message: message, view: self)
            }
            
        } failure: { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
        
    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnBack(_ sender: Any) {
        self.pop()
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        if validate() == false {
            return
        }
        else{
            forgotPasswordApi(email: "txtEmail")
        }
        
        
    }
    
    //------------------------------------------------------
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        viewEmail.borderColor =  ICColor.appButton
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewEmail.borderColor =  ICColor.appBorder
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
}
