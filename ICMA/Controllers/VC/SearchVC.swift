//
//  SearchVC.swift
//  ICMA
//
//  Created by Ucreate on 13/10/21.
//

import UIKit
import Alamofire
import AVFoundation

class SearchVC: UIViewController,UITextFieldDelegate {
    var page = 1
    var lastPage = Bool()
    var searchListing:[searchListingModel] = []{
        didSet{
            DispatchQueue.main.async {
                self.tblSearch.reloadData()
            }
        }
    }
    @IBOutlet weak var tblSearch: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    var debounce: SCDebouncer?

    var SearchArray = [SearchData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tblSearch.dataSource = self
        tblSearch.delegate = self
        txtSearch.delegate = self
        searchApi(searchText: "")
        tblSearch.separatorStyle = .none
        tblSearch.register(UINib(nibName: "DFTherapyTVCell", bundle: nil), forCellReuseIdentifier: "DFTherapyTVCell")
        
        self.SearchArray.append(SearchData(image: "lady", details: "Something to Laugh About", time : "1:40"))
        self.SearchArray.append(SearchData(image: "lady", details: "Something to Laugh About", time : "2:40"))
        self.SearchArray.append(SearchData(image: "lady", details: "Something to Laugh About", time : "1:20"))
        self.SearchArray.append(SearchData(image: "lady", details: "Something to Laugh About", time : "3:40"))
        txtSearch.addTarget(self, action: #selector(searchTapped(sendeR:)), for: .editingDidEnd)
        txtSearch.addTarget(self, action: #selector(editingChanges(sendeR:)), for: .editingChanged)
        txtSearch.clearsOnBeginEditing = true
//        txtSearch.addTarget(self, action: #selector(searchText(sender:)), for: .editingDidEndOnExit)
    }
    
    @objc func editingChanges(sendeR: UITextField){
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload(_:)), object: sendeR)
        perform(#selector(self.reload(_:)), with: sendeR, afterDelay: 0.75)
    }
      
    @objc func reload(_ searchField: UITextField) {
        if searchField.text != ""{
            lastPage = false
            page = 1
            self.searchListing.removeAll()
            self.tblSearch.reloadData()
            searchApi(searchText: searchField.text!)
        }else{
            lastPage = false
            page = 1
            self.searchListing.removeAll()
            self.tblSearch.reloadData()
            searchApi(searchText: "")
        }
    }
      
      
    @objc func searchTapped(sendeR: UITextField){
        if sendeR.text == ""{
            lastPage = false
            page = 1
            self.searchListing.removeAll()
            self.tblSearch.reloadData()
            searchApi(searchText: sendeR.text!)
        }
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.txtSearch.text = ""
        self.page = 1
        searchApi(searchText: "")
        self.navigationController?.popViewController(animated: false)
    }
    
}

extension SearchVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchListing.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DFTherapyTVCell", for: indexPath) as! DFTherapyTVCell
//        cell.mainImg.image = UIImage(named: SearchArray[indexPath.row].image)
        cell.mainImg.sd_setImage(with: URL(string: searchListing[indexPath.row].video_thumbnail),placeholderImage: UIImage(named: "placeholder"))
        cell.lblDetails.text = searchListing[indexPath.row].title
        cell.lblTime.text = searchListing[indexPath.row].creation_at
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == searchListing.count - 1{
            if lastPage == true {
                updateNextSet()
            }
        }
    }
    func updateNextSet(){
        page = page + 1
        searchApi(searchText: txtSearch.text!)
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

extension SearchVC {
    func searchApi(searchText: String){
        DispatchQueue.main.async {
           // AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        }
        let param = [ "title" : searchText, "perPage" : "100","pageNo" : "\(page)"] as [String:Any]
        print(param)
        let token = UserDefaults.standard.string(forKey: "Token") ?? ""
        let header:HTTPHeaders = ["Token":token]
        print(header)
        AFWrapperClass.requestPOSTURL(baseURL + ICMethods.searchListing , params: param, headers: header) { (response) in
           // AFWrapperClass.svprogressHudDismiss(view: self)
            let msg = response["message"] as? String ?? ""
            let status = response["status"] as? Int ?? 0
            if status == 1 {
                if let result = response as? [String:Any]{
                    if let dataDict = result["data"] as? [[String:Any]]{
                        print(dataDict)
                        for i in 0..<dataDict.count{
                            let time = Double(dataDict[i]["creation_at"] as? String ?? "") ?? 0.0
                            let timeString = self.timeStringFromUnixTimeOnly(unixTime: time)
                            let id = dataDict[i]["id"] as? String ?? ""
                            let filter = self.searchListing.filter({$0.id == id}).isEmpty
                            if filter{
                                self.searchListing.append(searchListingModel(id: dataDict[i]["id"] as? String ?? "", title: dataDict[i]["title"] as? String ?? "", video: dataDict[i]["video"] as? String ?? "", name: dataDict[i]["name"] as? String ?? "", start_time: dataDict[i]["start_time"] as? String ?? "", end_time: dataDict[i]["end_time"] as? String ?? "", video_width: dataDict[i]["video_width"] as? String ?? "", video_height: dataDict[i]["video_height"] as? String ?? "", video_thumbnail: dataDict[i]["video_thumbnail"] as? String ?? "", subcategory: dataDict[i]["subcategory"] as? String ?? "" , creation_at: timeString, type: dataDict[i]["type"] as? String ?? "", link: dataDict[i]["link"] as? String ?? "", audio_thumbnail: dataDict[i]["audio_thumbnail"] as? String ?? ""))
                            }
                        }
                    }
                }else {
                    alert(kAppName, message: msg, view: self)
                }
                self.tblSearch.reloadData()
            }
        } failure: { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
        
    }
}
