//
//  NeedSleepVC.swift
//  ICMA
//
//  Created by Dharmani Apps on 07/10/21.
//

import UIKit

class NeedSleepVC: UIViewController {

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblDetail: ICMediumLabel!
    @IBOutlet weak var lblTime: ICRegularLabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var tblSleep: UITableView!
    var SleepingArray = [SleepingData]()
    var section = ["For Anxiety - Inhale Peace,Exhale Anxiety","For Pain - Inhale Healing,Exhale Pain"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblSleep.dataSource = self
        tblSleep.delegate = self
        tblSleep.separatorStyle = .none
       
        tblSleep.register(UINib(nibName: "BreathingTVCell", bundle: nil), forCellReuseIdentifier: "BreathingTVCell")
      
        self.SleepingArray.append(SleepingData(image: "img1", details: " Inhale God's Peace, Exhale Anxiety with Guidance", time : "  4-5 min"))
        self.SleepingArray.append(SleepingData(image: "img2", details: " Inhale God's Peace, Exhale Anxiety with Guidance", time : "  3-7 min"))
        self.SleepingArray.append(SleepingData(image: "img3", details: " Inhale God's Peace, Exhale Anxiety with Guidance", time : "  1-2 min"))
        self.SleepingArray.append(SleepingData(image: "img4", details: " Inhale God's Peace, Exhale Anxiety with Guidance", time : "  1-3 min"))

    }
    
}
extension NeedSleepVC : UITableViewDelegate , UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return section.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return SleepingArray.count
        }else {
            return SleepingArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BreathingTVCell.self)) as? BreathingTVCell {
            cell.profileImg.image = UIImage(named: SleepingArray[indexPath.row].image)
            cell.lblName.text = SleepingArray[indexPath.row].details
            cell.lblTime.text = SleepingArray[indexPath.row].time
            cell.lblName.addLeading(image: #imageLiteral(resourceName: "music"), text: SleepingArray[indexPath.row].details)
            cell.lblTime.addLeading(image: #imageLiteral(resourceName: "clock"), text: SleepingArray[indexPath.row].time)
            DispatchQueue.main.async {
                self.heightConstraint.constant = self.tblSleep.contentSize.height
            }

            return cell
        }
            return UITableViewCell()
        }else{
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BreathingTVCell.self)) as? BreathingTVCell {
                cell.profileImg.image = UIImage(named: SleepingArray[indexPath.row].image)
                cell.lblName.text = SleepingArray[indexPath.row].details
                cell.lblTime.text = SleepingArray[indexPath.row].time
                DispatchQueue.main.async {
                    self.heightConstraint.constant = self.tblSleep.contentSize.height
                }
            return cell
        }
        return UITableViewCell()
    }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let view: ProfileViewForTitle = UIView.fromNib()
        view.titleLbl.text = "For Anxiety - Inhale Peace,Exhale Anxiety";"For Pain - Inhale Healing,Exhale Pain"
        view.layoutSubviews()
        return 70
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view: ProfileViewForTitle = UIView.fromNib()
//        view.titleLbl.text = "For Anxiety - Inhale Peace,Exhale Anxiety"
        view.titleLbl.text = "For Anxiety - Inhale Peace,\nExhale Anxiety";"For Pain - Inhale Healing,\nExhale Pain"
        view.layoutSubviews()
        return view
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
        return 105
    }
        else{
        return 106
            
    }
    
}
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AudioVC") as! AudioVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
struct SleepingData {
    var image : String
    var details : String
    var time : String
    init(image : String, details : String , time : String ) {
        self.image = image
        self.details = details
        self.time = time
     
    }
}
