//
//  EditProfileVC.swift
//  ICMA
//
//  Created by Ucreate on 12/10/21.
//

import UIKit
import Toucan
import IQKeyboardManagerSwift

class EditProfileVC: UIViewController,UITextViewDelegate, UITextFieldDelegate, ImagePickerDelegate  {
   
    
    @IBOutlet weak var txtPswrd: ICPasswordTextField!
    @IBOutlet weak var pswrdView: UIView!
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
        txtPswrd.delegate = self
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
        
        if ValidationManager.shared.isEmpty(text: txtPswrd.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please enter password." , okButton: "Ok", controller: self) {
            }
            
            return false
        }
        
        if ValidationManager.shared.isValid(text: txtPswrd.text!, for: RegularExpressions.password8AS) == false {
            showAlertMessage(title: kAppName.localized(), message: "Please enter valid password. Password should contain at least 8 characters, with at least 1 letter and 1 special character." , okButton: "Ok", controller: self) {
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
            case txtPswrd:
                pswrdView.borderColor =  ICColor.appButton   
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
            case txtPswrd:
                pswrdView.borderColor = ICColor.appBorder
            default:break
        }
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCamera(_ sender: Any) {
        self.imagePickerVC?.present(from: (sender as? UIView)!)
    }
    @IBAction func btnSave(_ sender: Any) {
        validate()
    }
}
