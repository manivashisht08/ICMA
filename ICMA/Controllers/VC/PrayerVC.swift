//
//  PrayerVC.swift
//  ICMA
//
//  Created by Ucreate on 11/10/21.
//

import UIKit
import Alamofire
import KRPullLoader

class PrayerVC: UIViewController {
    var page = 1
    var lastPage = String()
    
    var pageCount = Int()
    var prayerGet = [getPrayerModel]()
    var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tblPrayer: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageCount = 1
        let loadMoreView = KRPullLoadView()
        loadMoreView.delegate = self
        tblPrayer.addPullLoadableView(loadMoreView, type: .loadMore)
        tblPrayer.dataSource = self
        tblPrayer.delegate = self
        tblPrayer.separatorStyle = .none
        tblPrayer.register(UINib(nibName: "PrayerTVCell", bundle: nil), forCellReuseIdentifier: "PrayerTVCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        page = 1
        pageCount = 1
        getPrayApi()
//        self.tblPrayer.reloadData()
        self.prayerGet.removeAll()
    }
    
    @objc func reloadtV() {
        
        pageCount = 1
        getPrayApi()
        //self.NotificationList()
        refreshControl.endRefreshing()
    }
    func getPrayApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        }
        //  let userId = UserDefaults.standard.string(forKey: "id") ?? ""
        let param = ["pageNo":"\(pageCount)","perPage":"10"] as [String : Any]
        print(param,"pii")
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header:HTTPHeaders = ["Content-Type":"application/json","token":token]
        print(header)
        AFWrapperClass.requestPOSTURL(baseURL + ICMethods.getPrayers, params: param, headers: header) { (response) in
            print(response)
            print(baseURL + ICMethods.getPrayers)
            AFWrapperClass.svprogressHudDismiss(view: self)
            let msg = response["message"] as? String ?? ""
            let status = response ["status"] as? Int ?? 0
            self.lastPage = response["lastPage"] as? String ?? "false"
            print(self.lastPage,"123")
            if status == 1{
                self.pageCount = self.pageCount + 1
                if let result = response as? [String:Any] {
                    if let dataDict = result["data"] as? [[String:Any]]{
                        print(dataDict)
//                        self.prayerGet.removeAll()
                        for i in 0..<dataDict.count{
                            let time = Double(dataDict[i]["creation_at"] as? String ?? "") ?? 0.0
                           
                            let timeString = self.timeStringFromUnixTime(unixTime: time)
                            
                            self.prayerGet.append(getPrayerModel(id: dataDict[i]["id"] as? String ?? "", name: dataDict[i]["name"] as? String ?? "", userid: dataDict[i]["userid"] as? String ?? "", title: dataDict[i]["title"] as? String ?? "", detail: dataDict[i]["detail"] as? String ?? "", creation_at: timeString))
                        
//                            self.tblPrayer.beginUpdates()
//                            self.tblPrayer.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .top)
//                            self.tblPrayer.endUpdates()
                        }
                    }
                }
                
            }
            else{
                alert(kAppName, message: msg, view: self)
                // self.prayerGet.removeAll()
                
            }
            self.tblPrayer.reloadData()
        } failure: { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
    }
    @IBAction func btnAdd(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PrayVC") as! PrayVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension PrayerVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prayerGet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrayerTVCell", for: indexPath) as! PrayerTVCell
        
        cell.lblName.text = prayerGet[indexPath.row].title
        cell.lblTime.text = prayerGet[indexPath.row].creation_at
        cell.lblDetails.text = prayerGet[indexPath.row].detail
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row == prayerGet.count-1{
//            if lastPage == "false" {
//                pageCount = pageCount + 1
//                getPrayApi()
//                // self.NotificationList()
//            //}
//        }
    }
    func updateNextSet(){
        page = page + 1
        getPrayApi()
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


extension PrayerVC:KRPullLoadViewDelegate{
    func pullLoadView(_ pullLoadView: KRPullLoadView, didChangeState state: KRPullLoaderState, viewType type: KRPullLoaderType) {
        if type == .loadMore {
            switch state {
            case let .loading(completionHandler):
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                    completionHandler()
                   
                    self.getPrayApi()
                }
            default: break
            }
            return
        }
        
        switch state {
        case .none:
            pullLoadView.messageLabel.text = ""
            
        case let .pulling(offset, threshould):
            if offset.y > threshould {
                pullLoadView.messageLabel.text = "Pull more. offset: \(Int(offset.y)), threshould: \(Int(threshould)))"
            } else {
                pullLoadView.messageLabel.text = "Release to refresh. offset: \(Int(offset.y)), threshould: \(Int(threshould)))"
            }
            
        case let .loading(completionHandler):
            pullLoadView.messageLabel.text = "Updating..."
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                completionHandler()
             
                
            }
        }
    }
    
    
}
