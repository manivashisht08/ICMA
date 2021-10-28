//
//  EditProfileVC.swift
//  ICMA
//
//  Created by Ucreate on 12/10/21.
//

import UIKit
import Toucan
import IQKeyboardManagerSwift
import Alamofire

class EditProfileVC: UIViewController,UITextViewDelegate, UITextFieldDelegate, ImagePickerDelegate  {
    var imageData = Data()
    @IBOutlet weak var txtMobile: ICMobileNumberTextField!
    @IBOutlet weak var mobileView: UIView!
    @IBOutlet weak var txtEmail: ICEmailTextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var txtLastName: ICUsernameTextField!
    @IBOutlet weak var lNameView: UIView!
    @IBOutlet weak var fNameView: UIView!
    @IBOutlet weak var txtFirstName: ICUsernameTextField!
    @IBOutlet weak var imgProfile: UIImageView!
    var returnKeyHandler: IQKeyboardReturnKeyHandler?
    var imagePickerVC: ImagePicker?
    var selectedImage: UIImage? {
        didSet {
            if selectedImage != nil {
                imgProfile.image = selectedImage
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
       
    }
    
    func setup() {
        //        imgProfile.image = getPlaceholderImage()
        imagePickerVC = ImagePicker(presentationController: self, delegate: self)
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        returnKeyHandler?.delegate = self
        
        txtFirstName.delegate = self
        txtLastName.delegate = self
        txtEmail.delegate = self
        txtMobile.delegate = self
    }
    
    func editProfileApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "", view: self)
        }
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let userId = UserDefaults.standard.string(forKey: "id") ?? ""
        let header:HTTPHeaders = ["token":token]
        AFWrapperClass.requestPOSTURL(baseURL + ICMethods.editProfile, params: generatingParameters(), headers: header) { (response) in
            print(response)
            AFWrapperClass.svprogressHudDismiss(view: self)
            let msg = response["message"] as? String ?? ""
            let status = response["status"] as? Int ?? 0
            if status == 1 {
                showAlertMessage(title: kAppName.localized(), message: msg, okButton: "OK", controller: self) {
                    
                }
            }else {
                alert(AppAlertTitle.appName.rawValue, message: msg, view: self)
            }
            
        } failure: { error in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
        
    }
    func editProfileApis()  {
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "", view: self)
        }
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let userId = UserDefaults.standard.string(forKey: "id") ?? ""
        let url = baseURL + ICMethods.editProfile
        var params = [String:Any]()
        params = ["user_id":userId,"firstname":txtFirstName.text!,"lastname":txtLastName.text!,"phone":txtMobile.text!,"password":""]
        let header:HTTPHeaders = ["token":token]
        AF.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(self.imageData, withName: "profileimage", fileName: "profileimage", mimeType: "")
            
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
        }, to: url, usingThreshold: UInt64.init(), method: .post, headers: header, interceptor: nil, fileManager: .default)
        .uploadProgress(closure: { (progress) in
            print("Upload Progress: \(progress.fractionCompleted)")
        })
        .responseJSON { (response) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            switch response.result {
            case .success(let value):
                if let JSON = value as? [String: Any] {
                    if let dataDict = JSON as? NSDictionary{
                        print(dataDict)
                        let message = dataDict["message"] as? String ?? ""
                        let status = JSON["status"] as? Int ?? 0
                        if status == 1{
                            self.navigationController?.popViewController(animated: true)
                        }else{
                            //  self.Alert(message: message)
                            alert(AppAlertTitle.appName.rawValue, message: message, view: self)
                        }
                    }
                }
            case .failure(let error):
                //self.Alert(message: error.localizedDescription)
                alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
                AFWrapperClass.svprogressHudDismiss(view: self)
                break
            }
        }
    }
    
    func generatingParameters() -> [String:AnyObject] {
        var parameters:[String:AnyObject] = [:]
        parameters["email"] = txtEmail.text  as AnyObject
        parameters["phone"] = txtMobile.text  as AnyObject
        parameters["firstname"] = txtFirstName.text  as AnyObject
        parameters["lastname"] = txtLastName.text  as AnyObject
        
        return parameters
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
        
        if ValidationManager.shared.isEmpty(text: txtMobile.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please enter mobile number." , okButton: "Ok", controller: self) {
            }
            
            return false
        }
        
        return true
    }
    
    func didSelect(image: UIImage?) {
        if let imageData = image?.jpegData(compressionQuality: 0), let compressImage = UIImage(data: imageData) {
            self.selectedImage = Toucan.init(image: compressImage).resizeByCropping(ICSettings.profileImageSize).maskWithRoundedRect(cornerRadius: 10, borderWidth: ICSettings.profileBorderWidth, borderColor: UIColor.white).image
            imgProfile.image = selectedImage
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
        case txtMobile:
            mobileView.borderColor =  ICColor.appButton
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
        case txtMobile:
            mobileView.borderColor = ICColor.appBorder
        default:break
        }
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCamera(_ sender: Any) {
        self.imagePickerVC?.present(from: (sender as? UIView)!)
        //        self.imgProfile.image = imagePickerVC
        //        self.imgProfile.setRounded()
        //        self.imageData = (image.jpegData(compressionQuality: 0.7)!)
    }
    @IBAction func btnSave(_ sender: Any) {
        if validate() == false {
            return
        }
        else{
            editProfileApis()
        }
    }
}
