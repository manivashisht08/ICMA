//
//  ReferFriendVC.swift
//  ICMA
//
//  Created by Dharmani Apps on 19/10/21.
//

import UIKit

class ReferFriendVC: UIViewController {

    @IBOutlet weak var lblReferal: ICMediumLabel!
    @IBOutlet weak var dashView: UIView!
    @IBOutlet weak var mainImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        dashView.addDashedBorder()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSend(_ sender: Any) {
    }
    
}
