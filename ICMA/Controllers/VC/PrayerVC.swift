//
//  PrayerVC.swift
//  ICMA
//
//  Created by Ucreate on 11/10/21.
//

import UIKit
import Alamofire

class PrayerVC: UIViewController {
    var page = 1
    var lastPage = "false"
    var prayerGet = [getPrayerModel]()
    
    @IBOutlet weak var tblPrayer: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblPrayer.dataSource = self
        tblPrayer.delegate = self
        tblPrayer.separatorStyle = .none
        tblPrayer.register(UINib(nibName: "PrayerTVCell", bundle: nil), forCellReuseIdentifier: "PrayerTVCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        page = 1
        getPrayApi()
//        self.tblPrayer.reloadData()
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
        
        cell.lblName.text = prayerGet[indexPath.row].name
        cell.lblTime.text = prayerGet[indexPath.row].creation_at
        cell.lblDetails.text = prayerGet[indexPath.row].detail
        return cell
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == prayerGet.count - 1{
            if lastPage == "false"{
                updateNextSet()
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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

extension PrayerVC {
    
    func getPrayApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        }
        //  let userId = UserDefaults.standard.string(forKey: "id") ?? ""
        let param = ["pageNo":page,"perPage":"10"] as [String : Any]
        print(param)
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
            if status == 1{
                if let result = response as? [String:Any] {
                    if let dataDict = result["data"] as? [[String:Any]]{
                        print(dataDict)
                        for i in 0..<dataDict.count{
                            let time = Double(dataDict[i]["creation_at"] as? String ?? "") ?? 0.0
                           
                            let timeString = self.timeStringFromUnixTime(unixTime: time)
                            
                            self.prayerGet.append(getPrayerModel(id: dataDict[i]["id"] as? String ?? "", name: dataDict[i]["name"] as? String ?? "", userid: dataDict[i]["userid"] as? String ?? "", title: dataDict[i]["title"] as? String ?? "", detail: dataDict[i]["detail"] as? String ?? "", creation_at: timeString))
                        
                            self.tblPrayer.beginUpdates()
                            self.tblPrayer.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .top)
                            self.tblPrayer.endUpdates()
                        }
                    }
                }
                
            }else{
                alert(kAppName, message: msg, view: self)
                // self.prayerGet.removeAll()
            }
            self.tblPrayer.reloadData()
        } failure: { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
        self.tblPrayer.reloadData()
    }
    
}
