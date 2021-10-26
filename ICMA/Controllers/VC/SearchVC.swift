//
//  SearchVC.swift
//  ICMA
//
//  Created by Ucreate on 13/10/21.
//

import UIKit

class SearchVC: UIViewController {

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
