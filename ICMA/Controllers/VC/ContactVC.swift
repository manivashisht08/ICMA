//
//  ContactVC.swift
//  ICMA
//
//  Created by Ucreate on 13/10/21.
//

import UIKit
import Foundation
import IQKeyboardManagerSwift
import Alamofire

class ContactVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var txtMsg: UITextView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var txtEmail: ICEmailTextF!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var txtName: ICUserTextField!
    var returnKeyHandler: IQKeyboardReturnKeyHandler?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    //MARK: Customs
    
    func setup() {
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        returnKeyHandler?.delegate = self
        
        txtName.delegate = self
        txtEmail.delegate = self
        txtMsg.delegate = self
        
    }
    
    func contactUsApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        }
        let param = ["name":txtName.text! , "email":txtEmail.text!, "message":txtMsg.text!] as [String:Any]
        print(param)
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header:HTTPHeaders = ["Token":token]
        AFWrapperClass.requestPOSTURL(baseURL + ICMethods.contactUs, params: param, headers: header) { (response) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            let msg = response["message"] as? String ?? ""
            let status = response["status"] as? Int ?? 0
            if status == 200 {

                self.CustomAlert(title: kAppName.localized(), message: msg)
            }
        } failure: { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(error)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }

    }
    
    //MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
            case txtName:
                nameView.borderColor =  ICColor.appButton
            case txtEmail:
                emailView.borderColor = ICColor.appButton
            default:break
                
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
            case txtName:
                nameView.borderColor =  ICColor.appBorder
            case txtEmail:
                emailView.borderColor = ICColor.appBorder
            default:break
        }
    }
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        
//        txtMsg.layer.borderColor = ICColor.appButton as! CGColor
//    } 
//    
//    func textViewDidEndEditing(_ textView: UITextView) {
//        txtMsg.layer.borderColor = ICColor.appBorder as? CGColor
//    }
    
    func validate() -> Bool {
        
        if ValidationManager.shared.isEmpty(text: txtName.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please enter your name." , okButton: "Ok", controller: self) {
            }
            
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: txtEmail.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please enter your email." , okButton: "Ok", controller: self) {
            }
            
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: txtMsg.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please enter your message" , okButton: "Ok", controller: self) {
            }
            
            return false
        }
        
        return true
    }
    
    @IBAction func btnClose(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        if validate() == false {
            return
        }
        else{
            contactUsApi()
        }
    }
    
}
