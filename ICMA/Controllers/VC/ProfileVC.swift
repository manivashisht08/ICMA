//
//  ProfileVC.swift
//  ICMA
//
//  Created by Ucreate on 13/10/21.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var lblEmail: ICMediumLabel!
    @IBOutlet weak var lblName: ICMediumLabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var tblProfile: UITableView!
    var ProfileArray = [ProfileData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tblProfile.dataSource = self
        tblProfile.delegate = self
        
        tblProfile.register(UINib(nibName: "ProfileTVCell", bundle: nil), forCellReuseIdentifier: "ProfileTVCell")
        self.ProfileArray.append(ProfileData(image: ICImageName.iconMember, details: "Membership"))
        self.ProfileArray.append(ProfileData(image: ICImageName.iconAbout, details: "About Us"))
        self.ProfileArray.append(ProfileData(image: ICImageName.iconBlog, details: "Blog"))
        self.ProfileArray.append(ProfileData(image: ICImageName.iconContact, details: "Contact")) 
        self.ProfileArray.append(ProfileData(image: ICImageName.iconRefer, details: "Refer a Friend")) 
        self.ProfileArray.append(ProfileData(image: ICImageName.iconLogout, details: "Logout")) 
    }
    
    @IBAction func btnProfile(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProfileSubscriptionVC") as! ProfileSubscriptionVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnEdit(_ sender: Any) {
       
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
        if indexPath.row == 0{
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MembershipVC") as! MembershipVC
            self.navigationController?.pushViewController(vc, animated: true)

        }else if indexPath.row == 3 {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ContactVC") as! ContactVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 4 {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ReferFriendVC") as! ReferFriendVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            if indexPath.row == 5 {
                self.popActionAlert(title: kAppName, message: "Are you sure you want to log out from the app?", actionTitle: ["Ok","Cancel"], actionStyle: [.default , .cancel], action : [{ok in
                    AppDelegate.shared.logout()
                    print("fff")
                },{
                    cancel in
                }])
            }
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

