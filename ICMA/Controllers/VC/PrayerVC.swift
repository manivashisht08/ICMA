//
//  PrayerVC.swift
//  ICMA
//
//  Created by Ucreate on 11/10/21.
//

import UIKit

class PrayerVC: UIViewController {

    @IBOutlet weak var tblPrayer: UITableView!
    var PrayerArray = [PrayerData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tblPrayer.dataSource = self
        tblPrayer.delegate = self
        tblPrayer.separatorStyle = .none
       
        tblPrayer.register(UINib(nibName: "PrayerTVCell", bundle: nil), forCellReuseIdentifier: "PrayerTVCell")
        self.PrayerArray.append(PrayerData(name: "Pray for me", details: "Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs", time: "Sep 21-4:30am"))
        self.PrayerArray.append(PrayerData(name: "Community", details: "Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs", time: "Oct 21-2:30am"))
        self.PrayerArray.append(PrayerData(name: "Pray for my dad's recovery", details: "Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs", time: "Mar 28-3:30am"))
        self.PrayerArray.append(PrayerData(name: "Pray for me", details: "Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs", time: "Sep 21-4:30am"))
        self.PrayerArray.append(PrayerData(name: "Community", details: "Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs", time: "Oct 21-2:30am"))
        self.PrayerArray.append(PrayerData(name: "Pray for my dad's recovery", details: "Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs", time: "Mar 28-3:30am"))
    }
    
    @IBAction func btnAdd(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PrayVC") as! PrayVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension PrayerVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PrayerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrayerTVCell", for: indexPath) as! PrayerTVCell

            cell.lblName.text = PrayerArray[indexPath.row].name
            cell.lblTime.text = PrayerArray[indexPath.row].time 
            cell.lblDetails.text = PrayerArray[indexPath.row].details
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
struct PrayerData {
    var name : String
    var details : String
    var time : String
    init(name : String, details : String , time : String ) {
        self.name = name
        self.details = details
        self.time = time
        
    }
}

