//
//  PrayVC.swift
//  ICMA
//
//  Created by Ucreate on 11/10/21.
//

import UIKit
import Foundation
import IQKeyboardManagerSwift

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

    func addPrayApi(name:String,title:String, detail:String ){
        let params = ["name":txtName.text!, "title":txtRequest.text! , "detail":txtViewPrayer.text!]
        AFWrapperClass.requestPOSTURL(baseURL + WSMethods.addPrayer, params: params, headers: nil) { (response) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            
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
//        validate()
        addPrayApi(name: "txtName", title: "txtRequest", detail: "txtViewPrayer")
    }
    
    
}
