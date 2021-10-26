//
//  DFHSTherapyVC.swift
//  ICMA
//
//  Created by Dharmani Apps on 06/10/21.
//

import UIKit
import FittedSheets

class DFHSTherapyVC: UIViewController {
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var tblTherapy: UITableView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    var TherapyArray = [TherapyData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblTherapy.dataSource = self
        tblTherapy.delegate = self
       
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
//        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DevotionalVC") as! DevotionalVC
//        vc.modalPresentationStyle = .overFullScreen
//        self.present(vc, animated: true, completion: nil)
        bottomSheetView()
//        let vc = DevotionalVC.instantiate(fromAppStoryboard: .Setting)
//              vc.modalPresentationStyle = .overFullScreen
//              self.present(vc, animated: true, completion: nil)
    }
}
extension DFHSTherapyVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DFTherapyTVCell", for: indexPath) as! DFTherapyTVCell
        cell.mainImg.image = UIImage(named: TherapyArray[indexPath.row].image)
        cell.lblDetails.text = TherapyArray[indexPath.row].details
        cell.lblTime.text = TherapyArray[indexPath.row].time
      
        DispatchQueue.main.async {
            self.heightConstraint.constant = self.tblTherapy.contentSize.height
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TherapyArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260
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
