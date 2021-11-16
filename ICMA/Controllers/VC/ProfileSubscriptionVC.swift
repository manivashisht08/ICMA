//
//  ProfileSubscriptionVC.swift
//  ICMA
//
//  Created by Dharmani Apps on 18/10/21.
//

import UIKit
import Toucan
import IQKeyboardManagerSwift
import Alamofire

class ProfileSubscriptionVC: UIViewController,UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var lblActionStatus: ICRegularLabel!
    @IBOutlet weak var lblExpirationDate: ICRegularLabel!
    @IBOutlet weak var lblStartDate: ICRegularLabel!
    @IBOutlet weak var lblStatus: ICRegularLabel!
    @IBOutlet weak var lblSubscriptionPlan: ICRegularLabel!
    @IBOutlet weak var txtEmail: ICEmailTextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var txtLastName: ICUsernameTextField!
    @IBOutlet weak var lNameView: UIView!
    @IBOutlet weak var fNameView: UIView!
    @IBOutlet weak var txtFirstName: ICUsernameTextField!
    @IBOutlet weak var imgProfile: UIImageView!
    
    var returnKeyHandler: IQKeyboardReturnKeyHandler?
    var fName = String()
    var lName = String()
    var email = String()
    var proImage = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        txtEmail.text = email
        txtFirstName.text = fName
        txtLastName.text = lName
        self.imgProfile.sd_setImage(with: URL(string: proImage), placeholderImage: UIImage(named: "proplaceholder"))
    }
    
    func setup(){
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        returnKeyHandler?.delegate = self
        
        txtFirstName.delegate = self
        txtLastName.delegate = self
        txtEmail.delegate = self
        getPrayerApi()
    }
    
    func validate() -> Bool {
        
        if ValidationManager.shared.isEmpty(text: txtFirstName.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please enter first name." , okButton: "Ok", controller: self) {
            }
            
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: txtLastName.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please enter last name." , okButton: "Ok", controller: self) {
            }
            
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: txtEmail.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please enter email address." , okButton: "Ok", controller: self) {
            }
            
            return false
        }
        
        if ValidationManager.shared.isValid(text: txtEmail.text!, for: RegularExpressions.email) == false {
            showAlertMessage(title: kAppName.localized(), message: "Please enter valid email address." , okButton: "Ok", controller: self) {
            }
            
            return false
        }
  
        return true
    }
    
    func getPrayerApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        }
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header:HTTPHeaders = ["Token":token]
        print(token)
        AFWrapperClass.requestPOSTURL(baseURL + ICMethods.getProfileDetail, params:[:], headers:header) { [self] (response) in
            print(response)
            AFWrapperClass.svprogressHudDismiss(view: self)
            let data = response ["data"] as? [String:Any] ?? [:]
            txtFirstName.text = data["firstname"] as? String ?? ""
            txtLastName.text = data ["lastname"] as? String ?? ""
            txtEmail.text = data["email"] as? String ?? ""
            let img =  data["profileimage"] as? String ?? ""
            self.imgProfile.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named: "proplaceholder"))
            
        } failure: { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
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
        case txtFirstName:
            fNameView.borderColor =  ICColor.appButton
        case txtLastName:
            lNameView.borderColor =  ICColor.appButton
        case txtEmail:
            emailView.borderColor =  ICColor.appButton
     
        default:break
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case txtFirstName:
            fNameView.borderColor = ICColor.appBorder
        case txtLastName:
            lNameView.borderColor = ICColor.appBorder
        case txtEmail:
            emailView.borderColor = ICColor.appBorder
    
        default:break
        }
    }
    
    @IBAction func btnEdit(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        vc.delegate = self
        vc.email = txtEmail.text ?? ""
        vc.fname = txtFirstName.text ?? ""
        vc.lname = txtLastName.text ?? ""
        vc.img = proImage
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension ProfileSubscriptionVC: EditProfileProtocol{
    func editProfile(fromEdit: Bool) {
        if fromEdit{
        getPrayerApi()
        }
    }
}
