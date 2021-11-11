//
//  NeedSleepVC.swift
//  ICMA
//
//  Created by Dharmani Apps on 07/10/21.
//

import UIKit
import Alamofire
import AVKit
import AVFoundation

class NeedSleepVC: UIViewController {

    var audioVideoListing = [AudioModel]()
    var videoPlay = String()

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
       
        needSleepApi()
        
        tblSleep.register(UINib(nibName: "BreathingTVCell", bundle: nil), forCellReuseIdentifier: "BreathingTVCell")
      
//        self.SleepingArray.append(SleepingData(image: "img1", details: " Inhale God's Peace, Exhale Anxiety with Guidance", time : "  4-5 min"))
//        self.SleepingArray.append(SleepingData(image: "img2", details: " Inhale God's Peace, Exhale Anxiety with Guidance", time : "  3-7 min"))
//        self.SleepingArray.append(SleepingData(image: "img3", details: " Inhale God's Peace, Exhale Anxiety with Guidance", time : "  1-2 min"))
//        self.SleepingArray.append(SleepingData(image: "img4", details: " Inhale God's Peace, Exhale Anxiety with Guidance", time : "  1-3 min"))

    }
    @IBAction func btnVideoTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomVideoPlayer") as! CustomVideoPlayer
        vc.data = videoPlay
        self.navigationController?.pushViewController(vc, animated: true)

    }
}
extension NeedSleepVC : UITableViewDelegate , UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return audioVideoListing.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        audioVideoListing[section].audioDataModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BreathingTVCell.self)) as? BreathingTVCell {
            cell.detailsArr = audioVideoListing[indexPath.section].audioDataModel[indexPath.row]
            DispatchQueue.main.async {
                self.heightConstraint.constant = self.tblSleep.contentSize.height
            }
            return cell
        }
        return UITableViewCell()
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
        let audioUrlString = (audioVideoListing[indexPath.section].audioDataModel[indexPath.row].audio ?? "")
        print(audioUrlString)
        guard let url = URL(string: audioUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            alert(AppAlertTitle.appName.rawValue, message: "Invalid audio file", view: self)
            return
        }
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AudioVC") as! AudioVC
        vc.musicTitle = audioVideoListing[indexPath.section].audioDataModel[indexPath.row].title ?? ""
        vc.music = audioVideoListing[indexPath.section].audioDataModel[indexPath.row].audio ?? ""
        vc.bgImg = audioVideoListing[indexPath.section].audioDataModel[indexPath.row].audio_thumbnail ?? "crlcplay"
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

extension NeedSleepVC {
    func needSleepApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        }
        let param = ["categoryid" : "2"] as [String : Any]
        print(param)
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header:HTTPHeaders = ["token":token]
        print(header)
        AFWrapperClass.requestPOSTURL(baseURL + ICMethods.audioVideoListing, params: param, headers: header) { (response) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            let msg = response["message"] as? String ?? ""
            let status = response["status"] as? Int ?? 0
            if status == 1 {
                let data = response["video"] as? [String : Any] ?? [:]
                self.videoPlay = data["category_video"] as? String ?? ""

                let time = Double(data["creation_at"] as? String ?? "") ?? 0.0
                let timeString = self.timeStringFromUnixTimeOnly(unixTime: time)
                self.mainImg.sd_setImage(with: URL(string: data["video_thumbnail"] as? String ?? ""), placeholderImage: UIImage(named: "placeholder"))
                self.lblDetail.text = data["category_name"] as? String ?? ""
                self.lblTime.text = timeString
                
                if let result = response as? [String:Any]{
                    if let dataDict = result["audio"] as? [[String:Any]]{
                        var audioDt = [audioVideoListingModel]()
                        for obj in dataDict{
                            let dtDict = obj["data"] as? [NSDictionary] ?? [NSDictionary]()
                            print (dtDict)
                            for obj2 in dtDict{
                                audioDt.append(audioVideoListingModel.init(id: obj2["id"] as? String ?? "", title: obj2["title"] as? String ?? "", audio: obj2["audio"] as? String ?? "" , start_time: obj2["start_time"] as? String ?? "", end_time: obj2["end_time"] as? String ?? "", audio_thumbnail: obj2["audio_thumbnail"] as? String ?? "",subcategory_id: obj2["subcategory_id"] as? String ?? "",creation_at: obj2["creation_at"] as? String ?? "", categoryid: obj2["categoryid"] as? String ?? ""))
                            }
                            
                            self.audioVideoListing.append(AudioModel.init(subcategoryName: obj["subcategory_name"] as? String ?? "", audioDataModel: audioDt))
                            
                        }
                    }
                }
                
            }  else if status == 0{
                showAlertMessage(title: kAppName.localized(), message: msg, okButton: "OK", controller: self) {
                    appDel.logout()
                }
            
            }
            else {
            }
            self.tblSleep.reloadData()
        } failure: { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }

    }
}
