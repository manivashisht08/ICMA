//
//  NotificationsVC.swift
//  ICMA
//
//  Created by Ucreate on 12/10/21.
//

import UIKit
import Foundation

class NotificationsVC: UIViewController {
    
    @IBOutlet weak var tblNotification: UITableView!
    var NotificationsArray = [NotificationsData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tblNotification.dataSource = self
        tblNotification.delegate = self
        tblNotification.separatorStyle = .none
        tblNotification.register(UINib(nibName: "NotificationsTVCell", bundle: nil), forCellReuseIdentifier: "NotificationsTVCell")
        
        self.NotificationsArray.append(NotificationsData(image: "place", details: "Grave Jodson accepted your appointment schedule on  Grave Jodson accepted your appointment schedule on", time : "11 February 2021"))
        self.NotificationsArray.append(NotificationsData(image: "place", details: "Grave Jodson accepted your appointment schedule on Lorem ipsum as it is sometimes known as text used in laying out", time : "15 February 2021"))
        self.NotificationsArray.append(NotificationsData(image: "place", details: "Grave Jodson accepted your appointment schedule on", time : "11 April 2021"))
        self.NotificationsArray.append(NotificationsData(image: "place", details: "Grave Jodson accepted your appointment schedule on  Grave Jodson accepted your appointment schedule on", time : "11 February 2021"))
        self.NotificationsArray.append(NotificationsData(image: "place", details: "Grave Jodson accepted your appointment schedule on Lorem ipsum as it is sometimes known as text used in laying out", time : "15 February 2021"))
        self.NotificationsArray.append(NotificationsData(image: "place", details: "Grave Jodson accepted your appointment schedule on", time : "11 April 2021"))
        self.NotificationsArray.append(NotificationsData(image: "place", details: "Grave Jodson accepted your appointment schedule on  Grave Jodson accepted your appointment schedule on", time : "11 February 2021"))
        self.NotificationsArray.append(NotificationsData(image: "place", details: "Grave Jodson accepted your appointment schedule on Lorem ipsum as it is sometimes known as text used in laying out", time : "15 February 2021"))
        self.NotificationsArray.append(NotificationsData(image: "place", details: "Grave Jodson accepted your appointment schedule on", time : "11 April 2021"))
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension NotificationsVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NotificationsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTVCell", for: indexPath) as! NotificationsTVCell
        let notify = NotificationsArray[indexPath.row]
        cell.imgMain.image = UIImage(named: NotificationsArray[indexPath.row].image)
        cell.imgMain.setRounded()
        cell.lblDetail.text = notify.details
        cell.lblDate.text = notify.time
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
