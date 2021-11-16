//
//  ProfileVC.swift
//  ICMA
//
//  Created by Ucreate on 13/10/21.
//

import UIKit
import Alamofire
import SDWebImage
import SafariServices

class ProfileVC: UIViewController {

    @IBOutlet weak var lblEmail: ICMediumLabel!
    @IBOutlet weak var lblName: ICMediumLabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var tblProfile: UITableView!
    var ProfileArray = [ProfileData]()
    var lastName = String()
    var firstName = String()
    var mainImg = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        tblProfile.dataSource = self
        tblProfile.delegate = self
       
        
        tblProfile.register(UINib(nibName: "ProfileTVCell", bundle: nil), forCellReuseIdentifier: "ProfileTVCell")
        self.ProfileArray.append(ProfileData(image: ICImageName.iconChange, details: "Change Password"))
        self.ProfileArray.append(ProfileData(image: ICImageName.iconMember, details: "Membership"))
        self.ProfileArray.append(ProfileData(image: ICImageName.iconAbout, details: "About Us"))
        self.ProfileArray.append(ProfileData(image: ICImageName.iconBlog, details: "Blog"))
        self.ProfileArray.append(ProfileData(image: ICImageName.iconContact, details: "Contact"))
        self.ProfileArray.append(ProfileData(image: ICImageName.iconRefer, details: "Refer a Friend")) 
        self.ProfileArray.append(ProfileData(image: ICImageName.iconLogout, details: "Logout")) 
    }
    override func viewWillAppear(_ animated: Bool) {
        getPrayerApi()
    }
    
//    func prm() -> [String:Any]{
//        let prm = ["user_id":userId]
//        return prm
//    }
    
    func getPrayerApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        }
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header:HTTPHeaders = ["Token":token]
        print(token)
        AFWrapperClass.requestPOSTURL(baseURL + ICMethods.getProfileDetail, params:[:], headers:header) { [self] (response) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            let data = response ["data"] as? [String:Any] ?? [:]
            let fName = data["firstname"] as? String ?? ""
            let lName = data ["lastname"] as? String ?? ""
            self.lastName = lName
            self.firstName = fName
            self.lblEmail.text = data["email"] as? String ?? ""
            self.lblName.text = "\(fName) \(lName)"
            self.mainImg =  data["profileimage"] as? String ?? ""
            self.imgProfile.sd_setImage(with: URL(string: data["profileimage"] as? String ?? ""), placeholderImage: UIImage(named: "proplaceholder"))
            
        } failure: { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
    }
        
    @IBAction func btnProfile(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProfileSubscriptionVC") as! ProfileSubscriptionVC
        vc.email = lblEmail.text ?? ""
        vc.fName = firstName
        vc.lName = lastName
        vc.proImage = mainImg
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnEdit(_ sender: Any) {
       
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
   //------------------------------------------------------
  // Mark:- LogoutApi
    
    func logoutApi() {
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "", view: self)
        }
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header:HTTPHeaders = ["Token":token]
        print(header)
        AFWrapperClass.requestPOSTURL(baseURL + ICMethods.logout, params: [:], headers: header) { (response) in
            print(response)
            AFWrapperClass.svprogressHudDismiss(view: self)
            let msg = response["message"] as? String ?? ""
            let status = response["status"] as? Int ?? 0
            if status == 1 {
                self.popActionAlert(title: kAppName.localized(), message: "Are you sure you want to log out from the app?", actionTitle: ["Ok","Cancel"], actionStyle: [.default , .cancel], action: [{ok in
//                    AppDelegate.shared.logout()
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
                    self.navigationController?.pushViewController(vc, animated: true)
//                    self.logoutApi()
                    print("fff")
                },{
                    cancel in
                }])
            }
            
        } failure: { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }

    }
}
extension ProfileVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVCell", for: indexPath) as! ProfileTVCell
        cell.imgMain.image = UIImage(named: ProfileArray[indexPath.row].image)
        cell.lblDetail.text = ProfileArray[indexPath.row].details
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if indexPath.row == 0 {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 1{
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MembershipVC") as! MembershipVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 2 {
            if let url = URL(string:baseURL + ICMethods.aboutUs)
                    {
                        let safariCC = SFSafariViewController(url: url)
                        present(safariCC, animated: true, completion: nil)
                    }
        }
        else if indexPath.row == 3 {
            if let url = URL(string:baseURL + ICMethods.blogs)
                    {
                        let safariCC = SFSafariViewController(url: url)
                        present(safariCC, animated: true, completion: nil)
                    }
        }
        
        else if indexPath.row == 4 {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ContactVC") as! ContactVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        else if indexPath.row == 5 {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ReferFriendVC") as! ReferFriendVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            if indexPath.row == 6 {
                self.popActionAlert(title: kAppName, message: "Are you sure you want to log out from the app?", actionTitle: ["Ok","Cancel"], actionStyle: [.default , .cancel], action : [{ok in
                    AppDelegate.shared.logout()
//                    self.logoutApi()
                    print("fff")
                },{
                    cancel in
                }])
//                self.logoutApi()
            }
            
        }
    }


struct ProfileData {
    var image : String
    var details : String
   
    init(image : String, details : String ) {
        self.image = image
        self.details = details
      
    }
}

}
