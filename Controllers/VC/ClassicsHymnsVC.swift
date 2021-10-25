//
//  ClassicsHymnsVC.swift
//  ICMA
//
//  Created by Dharmani Apps on 07/10/21.
//

import UIKit

class ClassicsHymnsVC: UIViewController {

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tblClassics: UITableView!
    @IBOutlet weak var lblDetail: ICMediumLabel!
    @IBOutlet weak var lblTime: ICRegularLabel!
    @IBOutlet weak var mainImg: UIImageView!
    var HymnsArray = [HymnsData]()
    var section = ["For Anxiety - Inhale Peace,Exhale Anxiety","For Pain - Inhale Healing,Exhale Pain"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblClassics.dataSource = self
        tblClassics.delegate = self
        tblClassics.separatorStyle = .none
        
        tblClassics.register(UINib(nibName: "BreathingTVCell", bundle: nil), forCellReuseIdentifier: "BreathingTVCell")
      
        self.HymnsArray.append(HymnsData(image: "img1", details: " Inhale God's Peace, Exhale Anxiety with Guidance", time : "  4-5 min"))
        self.HymnsArray.append(HymnsData(image: "img2", details: " Inhale God's Peace, Exhale Anxiety with Guidance", time : "  3-7 min"))
        self.HymnsArray.append(HymnsData(image: "img3", details: " Inhale God's Peace, Exhale Anxiety with Guidance", time : "  1-2 min"))
        self.HymnsArray.append(HymnsData(image: "img4", details: " Inhale God's Peace, Exhale Anxiety with Guidance", time : "  1-3 min"))

    }

}

extension ClassicsHymnsVC : UITableViewDelegate , UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return section.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return HymnsArray.count
        }else {
            return HymnsArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BreathingTVCell.self)) as? BreathingTVCell {
            cell.profileImg.image = UIImage(named: HymnsArray[indexPath.row].image)
            cell.lblName.text = HymnsArray[indexPath.row].details
            cell.lblTime.text = HymnsArray[indexPath.row].time
            cell.lblName.addLeading(image: #imageLiteral(resourceName: "music"), text: HymnsArray[indexPath.row].details)
            cell.lblTime.addLeading(image: #imageLiteral(resourceName: "clock"), text: HymnsArray[indexPath.row].time)
           // cell.lblName.addLeading(image: UIImage(named: "music"), text: SleepingArray[indexPath.row])
            DispatchQueue.main.async {
                self.heightConstraint.constant = self.tblClassics.contentSize.height
            }

            return cell
        }
            return UITableViewCell()
        }else{
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BreathingTVCell.self)) as? BreathingTVCell {
                cell.profileImg.image = UIImage(named: HymnsArray[indexPath.row].image)
                cell.lblName.text = HymnsArray[indexPath.row].details
                cell.lblTime.text = HymnsArray[indexPath.row].time
                DispatchQueue.main.async {
                    self.heightConstraint.constant = self.tblClassics.contentSize.height
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
struct HymnsData {
    var image : String
    var details : String
    var time : String
    init(image : String, details : String , time : String ) {
        self.image = image
        self.details = details
        self.time = time
     
    }
}
