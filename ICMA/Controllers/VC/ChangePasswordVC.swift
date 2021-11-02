//
//  ChangePasswordVC.swift
//  ICMA
//
//  Created by Dharmani Apps on 02/11/21.
//

import UIKit
import IQKeyboardManagerSwift

class ChangePasswordVC: UIViewController,UITextFieldDelegate,UITextViewDelegate {
    
    @IBOutlet weak var txtConfirmPswrd: ICPasswordTextField!
    @IBOutlet weak var confirmNPswrdView: UIView!
    @IBOutlet weak var txtNewPswrd: ICPasswordTextField!
    @IBOutlet weak var newPswrdView: UIView!
    @IBOutlet weak var txtCurrentPswrd: ICPasswordTextField!
    @IBOutlet weak var currentPswrdView: UIView!
    
    var returnKeyHandler: IQKeyboardReturnKeyHandler?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    func setup() {
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        returnKeyHandler?.delegate = self
        
        txtCurrentPswrd.delegate = self
        txtNewPswrd.delegate = self
        txtConfirmPswrd.delegate = self
    }
    
    //------------------------------------------------------
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if IQKeyboardManager.shared.canGoNext {
            IQKeyboardManager.shared.goNext()
        } else {
            self.view.endEditing(true)
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case txtCurrentPswrd:
            currentPswrdView.borderColor =  ICColor.appButton
        case txtNewPswrd:
            newPswrdView.borderColor =  ICColor.appButton
        case txtConfirmPswrd:
            confirmNPswrdView.borderColor =  ICColor.appButton
            
        default:break
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case txtCurrentPswrd:
            currentPswrdView.borderColor = ICColor.appBorder
        case txtNewPswrd:
            newPswrdView.borderColor = ICColor.appBorder
        case txtConfirmPswrd:
            confirmNPswrdView.borderColor = ICColor.appBorder
            
        default:break
        }
    }
    
    func validate() -> Bool {
        
        if ValidationManager.shared.isEmpty(text: txtCurrentPswrd.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please enter current password." , okButton: "Ok", controller: self) {
            }
            
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: txtNewPswrd.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please enter new password." , okButton: "Ok", controller: self) {
            }
            
            return false
        }
        
        
        if ValidationManager.shared.isEmpty(text: txtConfirmPswrd.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please enter confirm new password." , okButton: "Ok", controller: self) {
            }
            
            return false
        }
//        if ValidationManager.shared.isValid(text: txtConfirmPswrd.text!, for: RegularExpressions.password8AS) == false {
//            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: "") {
//            }
//            return false
//        }
//
//        if (txtNewPswrd.text == txtConfirmPswrd.text) {
//            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.oldNewPasswordNotSame) {
//            }
//            return false
//        }
//
//        if (txtNewPswrd.text != txtConfirmPswrd.text) {
//            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.NewRetypePasswordNotMatch) {
//            }
//            return false
//
//        }
        return true
    
    }

    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        if validate() == false {
            return
        }else{
            
        }
    }
    
    
}



