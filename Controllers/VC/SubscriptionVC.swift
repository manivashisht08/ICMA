//
//  SubscriptionVC.swift
//  ICMA
//
//  Created by Ucreate on 14/10/21.
//

import UIKit

class SubscriptionVC: UIViewController {

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tblSubscription: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tblSubscription.delegate = self
        tblSubscription.dataSource = self
        tblSubscription.separatorStyle = .none
        
        tblSubscription.register(UINib(nibName: "SubscriptionTVCell", bundle: nil), forCellReuseIdentifier: "SubscriptionTVCell")
       
    }
    
    @IBAction func btnTerm(_ sender: Any) {
    }
    
    @IBAction func btnPolicy(_ sender: Any) {
    }
    
    @IBAction func btnPaypal(_ sender: Any) {
    }
    
    @IBAction func btnSubscription(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension SubscriptionVC : UITableViewDelegate, UITableViewDataSource {
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "SubscriptionTVCell", for: indexPath) as! SubscriptionTVCell
        DispatchQueue.main.async {
            self.heightConstraint.constant = self.tblSubscription.contentSize.height
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
