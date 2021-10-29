//
//  NotificationsVC.swift
//  ICMA
//
//  Created by Ucreate on 12/10/21.
//

import UIKit
import Foundation
import Alamofire

class NotificationsVC: UIViewController {
    var page = 1
    var lastPage = "false"
    var notificationModel = [notificationListingModel]()
    
    @IBOutlet weak var tblNotification: UITableView!
    var NotificationsArray = [NotificationsData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tblNotification.dataSource = self
        tblNotification.delegate = self
        tblNotification.separatorStyle = .none
        tblNotification.register(UINib(nibName: "NotificationsTVCell", bundle: nil), forCellReuseIdentifier: "NotificationsTVCell")
        
//        self.NotificationsArray.append(NotificationsData(image: "place", details: "Grave Jodson accepted your appointment schedule on  Grave Jodson accepted your appointment schedule on", time : "11 February 2021"))
//        self.NotificationsArray.append(NotificationsData(image: "place", details: "Grave Jodson accepted your appointment schedule on Lorem ipsum as it is sometimes known as text used in laying out", time : "15 February 2021"))
//        self.NotificationsArray.append(NotificationsData(image: "place", details: "Grave Jodson accepted your appointment schedule on", time : "11 April 2021"))
//        self.NotificationsArray.append(NotificationsData(image: "place", details: "Grave Jodson accepted your appointment schedule on  Grave Jodson accepted your appointment schedule on", time : "11 February 2021"))
//        self.NotificationsArray.append(NotificationsData(image: "place", details: "Grave Jodson accepted your appointment schedule on Lorem ipsum as it is sometimes known as text used in laying out", time : "15 February 2021"))
//        self.NotificationsArray.append(NotificationsData(image: "place", details: "Grave Jodson accepted your appointment schedule on", time : "11 April 2021"))
//        self.NotificationsArray.append(NotificationsData(image: "place", details: "Grave Jodson accepted your appointment schedule on  Grave Jodson accepted your appointment schedule on", time : "11 February 2021"))
//        self.NotificationsArray.append(NotificationsData(image: "place", details: "Grave Jodson accepted your appointment schedule on Lorem ipsum as it is sometimes known as text used in laying out", time : "15 February 2021"))
//        self.NotificationsArray.append(NotificationsData(image: "place", details: "Grave Jodson accepted your appointment schedule on", time : "11 April 2021"))
    }
    override func viewWillAppear(_ animated: Bool) {
        page = 1
        notificationListingApi()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension NotificationsVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTVCell", for: indexPath) as! NotificationsTVCell
        let notify = notificationModel[indexPath.row]
        cell.imgMain.image = UIImage(named: notificationModel[indexPath.row].image)
        cell.imgMain.sd_setImage(with: URL(string: notificationModel[indexPath.row].image), placeholderImage: UIImage(named: "placehldr"))
        cell.imgMain.setRounded()
        cell.lblDetail.text = notify.message
        cell.lblDate.text = notify.creation_at
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
struct NotificationsData {
    var image : String
    var details : String
    var time : String
    
    init(image : String, details : String , time : String ) {
        self.image = image
        self.details = details
        self.time = time
        
    }
}
extension NotificationsVC{
    func notificationListingApi() {
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        }
        let param = ["pageNo":page,"perPage":"5"] as [String : Any]
        print(param)
        let token =  UserDefaults.standard.string(forKey: "token") ?? ""
        let header:HTTPHeaders = ["Content-Type":"application/json","token":token]
        print(header)
        AFWrapperClass.requestPOSTURL(baseURL + ICMethods.notificationListing, params: param, headers: header) { (response) in
            print(response)
            AFWrapperClass.svprogressHudDismiss(view: self)
            let msg = response["message"] as? String ?? ""
            let status = response["status"] as? Int ?? 0
            self.lastPage = response["lastPage"] as? String ?? "false"
            if status == 1 {
                if let result  = response as? [String:Any]{
                    if let dataDict = result["data"] as? [[String:Any]]{
                        print(dataDict)
                        for i in 0..<dataDict.count{
                            let time = Double(dataDict[i]["creation_at"] as? String ?? "") ?? 0.0
                            let timeString = self.convertTimeStampToDate(dateVal: time)
                            self.notificationModel.append(notificationListingModel(notification_id: dataDict[i]["notification_id"] as? String ?? "", title: dataDict[i]["title"] as? String ?? "", message: dataDict[i]["message"] as? String ?? "", userid: dataDict[i]["userid"] as? String ?? "", notification_type: dataDict[i]["notification_type"] as? String ?? "", creation_at: timeString,name: dataDict[i]["name"] as? String ?? "" , image: dataDict[i]["image"] as? String ?? ""))
                        }
                    }
                }
            }else {
                alert(kAppName, message: msg, view: self)
            }
            self.tblNotification.reloadData()
        } failure: { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
        self.tblNotification.reloadData()
        
    }
}
