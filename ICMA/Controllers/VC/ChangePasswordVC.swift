//
//  ChangePasswordVC.swift
//  ICMA
//
//  Created by Dharmani Apps on 02/11/21.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire

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

        if (txtNewPswrd.text != txtConfirmPswrd.text) {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.NewRetypePasswordNotMatch) {
            }
            return false

        }
        return true
    
    }

    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        if validate() == false {
            return
        }else{
            changePasswordApi()
        }
    }
    
}
extension ChangePasswordVC {
    func changePasswordApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading", view: self)
        }
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
//        let userID = UserDefaults.standard.string(forKey: "id") ?? ""
        let url = baseURL + ICMethods.changePassword
        var param = [String:Any]()
        param  = ["old_password" : txtCurrentPswrd.text!,"new_password":txtNewPswrd.text!]
        print(param)
        let header:HTTPHeaders = ["Content-Type":"application/json","token":token]
        AFWrapperClass.requestPOSTURL(url, params: param, headers: header) { (response) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            let msg = response["message"] as? String ?? ""
            let status = response["status"] as? Int ?? 0
            if status == 1 {
                DispatchQueue.main.async {
                    Alert.present(
                        title: AppAlertTitle.appName.rawValue,
                        message: "Password updated successfully.",
                        actions: .ok(handler: {
                            self.navigationController?.popViewController(animated: true)
                        }),
                        from: self
                    )
                
            }
                
            }else {
                DispatchQueue.main.async {
                    Alert.present(title: AppAlertTitle.appName.rawValue, message: msg, actions: .ok(handler: {
                        
                    }), from: self)
                }
            }
        } failure: { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(error)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }

    }
}



