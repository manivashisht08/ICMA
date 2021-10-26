//
//  MembershipVC.swift
//  ICMA
//
//  Created by Dharmani Apps on 18/10/21.
//

import UIKit

class MembershipVC: UIViewController {

    @IBOutlet weak var tblMembership: UITableView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        tblMembership.delegate = self
        tblMembership.dataSource = self
        tblMembership.separatorStyle = .none
        
        tblMembership.register(UINib(nibName: "SubscriptionTVCell", bundle: nil), forCellReuseIdentifier: "SubscriptionTVCell")
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnTerm(_ sender: Any) {
    }
    @IBAction func btnPolicy(_ sender: Any) {
    }
    @IBAction func btnSubscription(_ sender: Any) {
    }
    @IBAction func btnPaypal(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SubscriptionVC") as! SubscriptionVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension MembershipVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "SubscriptionTVCell", for: indexPath) as! SubscriptionTVCell
        DispatchQueue.main.async {
            self.heightConstraint.constant = self.tblMembership.contentSize.height
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}
