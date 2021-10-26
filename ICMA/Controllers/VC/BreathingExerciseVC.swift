//
//  BreathingExerciseVC.swift
//  ICMA
//
//  Created by Dharmani Apps on 07/10/21.
//

import UIKit

class BreathingExerciseVC: UIViewController {
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tblBreathing: UITableView!
    @IBOutlet weak var lblDetails: ICMediumLabel!
    @IBOutlet weak var lblTime: ICRegularLabel!
    @IBOutlet weak var mainImg: UIImageView!
    var BreathingArray = [BreathingData]()
    var section = ["For Anxiety - Inhale Peace,Exhale Anxiety","For Pain - Inhale Healing,Exhale Pain"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblBreathing.dataSource = self
        tblBreathing.delegate = self
        tblBreathing.separatorStyle = .none
        
        tblBreathing.register(UINib(nibName: "BreathingTVCell", bundle: nil), forCellReuseIdentifier: "BreathingTVCell")
      
        self.BreathingArray.append(BreathingData(image: "img1", details:" Inhale God's Peace, Exhale Anxiety with Guidance", time : "  4-5 min"))
        self.BreathingArray.append(BreathingData(image: "img2", details: " Inhale God's Peace, Exhale Anxiety with Guidance", time : "  3-7 min"))
        self.BreathingArray.append(BreathingData(image: "img3", details: " Inhale God's Peace, Exhale Anxiety with Guidance", time : "  1-2 min"))
        self.BreathingArray.append(BreathingData(image: "img4", details: " Inhale God's Peace, Exhale Anxiety with Guidance", time : "  1-2 min"))
    }
    
}
extension BreathingExerciseVC : UITableViewDelegate , UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return section.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return BreathingArray.count
        }else {
            return BreathingArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BreathingTVCell.self)) as? BreathingTVCell {
            cell.profileImg.image = UIImage(named: BreathingArray[indexPath.row].image)
            cell.lblName.text = BreathingArray[indexPath.row].details
            cell.lblTime.text = BreathingArray[indexPath.row].time
            cell.lblName.addLeading(image: #imageLiteral(resourceName: "music"), text: BreathingArray[indexPath.row].details)
            cell.lblTime.addLeading(image: #imageLiteral(resourceName: "clock"), text: BreathingArray[indexPath.row].time)
            DispatchQueue.main.async {
                self.heightConstraint.constant = self.tblBreathing.contentSize.height
            }

            return cell
        }
            return UITableViewCell()
        }else{
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BreathingTVCell.self)) as? BreathingTVCell {
                cell.profileImg.image = UIImage(named: BreathingArray[indexPath.row].image)
                cell.lblName.text = BreathingArray[indexPath.row].details
                cell.lblTime.text = BreathingArray[indexPath.row].time
                DispatchQueue.main.async {
                    self.heightConstraint.constant = self.tblBreathing.contentSize.height
                }
            return cell
        }
        return UITableViewCell()
    }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let view: ProfileViewForTitle = UIView.fromNib()
        view.titleLbl.text = "For Anxiety - Inhale Peace,\n Exhale Anxiety"; "For Pain - Inhale Healing, \n Exhale Pain"
        view.layoutSubviews()
        return 70
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view: ProfileViewForTitle = UIView.fromNib()
//        view.titleLbl.text = "For Anxiety - Inhale Peace,Exhale Anxiety"
        view.titleLbl.text = "For Anxiety - Inhale Peace, \nExhale Anxiety";"For Pain - Inhale Healing,\nExhale Pain"
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
struct BreathingData {
    var image : String
    var details : String
    var time : String
    init(image : String, details : String , time : String ) {
        self.image = image
        self.details = details
        self.time = time
     
    }
}



