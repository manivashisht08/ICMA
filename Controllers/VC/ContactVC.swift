//
//  ContactVC.swift
//  ICMA
//
//  Created by Ucreate on 13/10/21.
//

import UIKit
import Foundation
import IQKeyboardManagerSwift

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
        validate()
    }
    
}
