//
//  DFHSTherapyVC.swift
//  ICMA
//
//  Created by Dharmani Apps on 06/10/21.
//

import UIKit
import FittedSheets
import Alamofire
import AVFoundation
import AVKit

class DFHSTherapyVC: UIViewController {
    var page = 1
    var lastPage = "false"
    var videoListing = [videoListingModel]()
    
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var tblTherapy: UITableView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    var TherapyArray = [TherapyData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblTherapy.dataSource = self
        tblTherapy.delegate = self
        therapyListingApi()
       
        tblTherapy.register(UINib(nibName: "DFTherapyTVCell", bundle: nil), forCellReuseIdentifier: "DFTherapyTVCell")
        
        self.TherapyArray.append(TherapyData(image: "lady", details: "Something to Laugh About", time : "1:40"))
        self.TherapyArray.append(TherapyData(image: "lady", details: "Something to Laugh About", time : "2:40"))
        self.TherapyArray.append(TherapyData(image: "lady", details: "Something to Laugh About", time : "1:20"))
        self.TherapyArray.append(TherapyData(image: "lady", details: "Something to Laugh About", time : "3:40"))
    }
    func bottomSheetView(){
        let controller = DevotionalVC.instantiate()
        var sizes = [SheetSize]()
        sizes.append(.fixed(UIScreen.main.bounds.size.height * 0.8))
        let sheetController = SheetViewController(controller: controller, sizes: sizes)
        sheetController.modalPresentationStyle = .overFullScreen
        self.present(sheetController, animated: true, completion: nil)
    }
    
    
    @IBAction func btnSearch(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func btnProfile(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnNotification(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnMainImg(_ sender: Any) {

        bottomSheetView()

    }
}
extension DFHSTherapyVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DFTherapyTVCell", for: indexPath) as! DFTherapyTVCell
        cell.mainImg.sd_setImage(with: URL(string: videoListing[indexPath.row].video_thumbnail), placeholderImage: UIImage(named: "placeholder"))
        cell.lblDetails.text = videoListing[indexPath.row].title
        cell.lblTime.text = videoListing[indexPath.row].end_time
        let video = videoListing[indexPath.row].video_thumbnail
        print(video,videoListing[indexPath.row].video,"lop")
        DispatchQueue.main.async {
        self.heightConstraint.constant = self.tblTherapy.contentSize.height
        }
        
        cell.videoBTN = {
            let url : String = self.videoListing[indexPath.row].video
            if let urlStr : String = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),let convertedURL : URL = URL(string: urlStr){
                let player = AVPlayer(url: convertedURL)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true)
                {
                    playerViewController.player!.play()
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoListing.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 245
    }
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }

}

struct TherapyData {
    var image : String
    var details : String
    var time : String
    init(image : String, details : String , time : String ) {
        self.image = image
        self.details = details
        self.time = time
     
        
    }
}
extension DFHSTherapyVC {
    func therapyListingApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        }
        let param = ["pageNo":"1","perPage":"10"] as [String : Any]
        print(param)
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header:HTTPHeaders = ["Token":token]
        print(header)
        AFWrapperClass.requestPOSTURL(baseURL + ICMethods.videoListing, params: param, headers: header) { (response) in
            print(response)
            AFWrapperClass.svprogressHudDismiss(view: self)
            let msg = response["message"] as? String ?? ""
            let status = response["status"] as? Int ?? 0
            self.lastPage = response["lastPage"] as? String ?? "false"
            if status == 1 {
                let data = response ["banner"] as? [String:Any] ?? [:]
            
                self.mainImg.sd_setImage(with: URL(string: data["banner_image"] as? String ?? ""), placeholderImage: UIImage(named: "placeholder"))
                
                
                
                if let result = response as? [String:Any]{
                    if let dataDict = result["video"] as? [[String:Any]]{
                        print(dataDict)
                        for i in 0..<dataDict.count{
                            
                            let time = Double(dataDict[i]["creation_at"] as? String ?? "") ?? 0.0
                           
                            let timeString = self.timeStringFromUnixTimeOnly(unixTime: time)
                            self.videoListing.append(videoListingModel(id: dataDict[i]["id"] as? String ?? "", title: dataDict[i]["title"] as? String ?? "", video: dataDict[i]["video"] as? String ?? "", name: dataDict[i]["name"] as? String ?? "", start_time: dataDict[i]["start_time"] as? String ?? "", end_time: dataDict[i]["end_time"] as? String ?? "", video_width: dataDict[i]["video_width"] as? String ?? "", video_height: dataDict[i]["video_height"] as? String ?? "", video_thumbnail: dataDict[i]["video_thumbnail"] as? String ?? "", subcategory: dataDict[i]["subcategory"] as? String ?? "", creation_at: timeString))
                        }
                    }
                    
                }
            }else {
                alert(kAppName, message: msg, view: self)
            }
            self.tblTherapy.reloadData()
        } failure: { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }

    }
}
