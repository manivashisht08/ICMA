//
//  SearchVC.swift
//  ICMA
//
//  Created by Ucreate on 13/10/21.
//

import UIKit
import Alamofire

class SearchVC: UIViewController {
    var page = 1
    var lastPage = "false"
    var searchListing = [searchListingModel]()
    @IBOutlet weak var tblSearch: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    var SearchArray = [SearchData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tblSearch.dataSource = self
        tblSearch.delegate = self
        
        tblSearch.register(UINib(nibName: "DFTherapyTVCell", bundle: nil), forCellReuseIdentifier: "DFTherapyTVCell")
        
        self.SearchArray.append(SearchData(image: "lady", details: "Something to Laugh About", time : "1:40"))
        self.SearchArray.append(SearchData(image: "lady", details: "Something to Laugh About", time : "2:40"))
        self.SearchArray.append(SearchData(image: "lady", details: "Something to Laugh About", time : "1:20"))
        self.SearchArray.append(SearchData(image: "lady", details: "Something to Laugh About", time : "3:40"))
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
}

extension SearchVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SearchArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DFTherapyTVCell", for: indexPath) as! DFTherapyTVCell
        cell.mainImg.image = UIImage(named: SearchArray[indexPath.row].image)
        cell.lblDetails.text = SearchArray[indexPath.row].details
        cell.lblTime.text = SearchArray[indexPath.row].time
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
}
struct SearchData {
    var image : String
    var details : String
    var time : String
    init(image : String, details : String , time : String ) {
        self.image = image
        self.details = details
        self.time = time
        
    }
}
//extension SearchVC {
//    func searchApi(){
//        DispatchQueue.main.async {
//            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
//        }
//        let param = [ "title" : "", "perPage" : "100","pageNo" : "1"] as [String:Any]
//        print(param)
//        let token = UserDefaults.standard.string(forKey: "Token") ?? ""
//        let header:HTTPHeaders = ["Token":token]
//        print(header)
//        AFWrapperClass.requestPOSTURL(baseURL + ICMethods.searchListing , params: param, headers: header) { (response) in
//            let msg = response["message"] as? String ?? ""
//            let status = response["status"] as? Int ?? 0
//            
//            if status == 1 {
//                if let result = response as? [String:Any]{
//                    if let dataDict = result["data"] as? [[String:Any]]{
//                        print(dataDict)
//                        for i in 0..<dataDict.count{
//                            
//                            self.searchListing.append(searchListingModel(id: dataDict[i]["id"] as? String ?? "", title: dataDict[i]["title"] as? String ?? "", video: dataDict[i]["video"] as? String ?? "", name: dataDict[i]["name"] as? String ?? "", start_time: dataDict[i]["start_time"] as? String ?? "", end_time: dataDict[i]["end_time"] as? String ?? "", video_width: dataDict[i]["video_width"] as? String ?? "", video_height: dataDict[i]["video_height"] as? String ?? "", video_thumbnail: dataDict[i]["video_thumbnail"] as? String ?? "", subcategory: dataDict[i]["subcategory"] as? String ?? "" , creation_at: dataDict[i]["creation_at"] as? String ?? "", type: dataDict[i]["type"] as? String ?? "", link: dataDict[i]["link"] as? String ?? "", audio_thumbnail: dataDict[i]["audio_thumbnail"] as? String ?? ""))
//                        }
//                    }
//                }else {
//                    alert(kAppName, message: msg, view: self)
//                }
//                self.tblSearch.reloadData()
//            }
//        } failure: { (error) in
//            AFWrapperClass.svprogressHudDismiss(view: self)
//            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
//        }
//        
//    }
//}
