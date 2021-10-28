//
//  PrayVC.swift
//  ICMA
//
//  Created by Ucreate on 11/10/21.
//

import UIKit
import Foundation
import IQKeyboardManagerSwift
import Alamofire
import SafariServices

class PrayVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var txtViewPrayer: UITextView!
    @IBOutlet weak var viewPrayer: UIView!
    @IBOutlet weak var requestView: UIView!
    @IBOutlet weak var txtRequest: ICUserTextField!
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
        txtRequest.delegate = self
        txtViewPrayer.delegate = self
        
    }

    func addPrayApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        }
        let param = ["name":txtName.text!,"title":txtRequest.text!,"detail": txtViewPrayer.text! ] as [String : Any]
        print(param)
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header:HTTPHeaders = ["Content-Type":"application/json","Token":token]
        AFWrapperClass.requestPOSTURL(baseURL + ICMethods.addPrayer, params: param, headers: header) { (response) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            AFWrapperClass.svprogressHudDismiss(view: self)
            let msg = response["message"] as? String ?? ""
            let status = response["status"] as? Int ?? 0
            if status == 200 {
                self.navigationController?.popViewController(animated: true)
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
                case txtRequest:
                    requestView.borderColor = ICColor.appButton
                default:break
                    
            }
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            switch textField {
                case txtName:
                    nameView.borderColor =  ICColor.appBorder
                case txtRequest:
                    requestView.borderColor = ICColor.appBorder
                default:break
            }
        }
       
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtViewPrayer.textColor == ICColor.appButton {
            txtViewPrayer.tintColor = ICColor.appButton
            txtViewPrayer.textColor = ICColor.appButton
           }
        viewPrayer.borderColor = ICColor.appButton
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtViewPrayer.text.isEmpty {
            txtViewPrayer.textColor = UIColor.lightGray
            }
        viewPrayer.borderColor = ICColor.appBorder
    }
        
        
    
    func validate() -> Bool {
        
        if ValidationManager.shared.isEmpty(text: txtName.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please enter first name." , okButton: "Ok", controller: self) {
            }
            
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: txtRequest.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please enter request title." , okButton: "Ok", controller: self) {
            }
            
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: txtViewPrayer.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please enter your prayer request " , okButton: "Ok", controller: self) {
            }
            
            return false
        }
        
        return true
    }
    
    
    
    @IBAction func btnCancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        if validate() == false {
            return
        }
        else{
            addPrayApi()
        }

    }
    
    
}
