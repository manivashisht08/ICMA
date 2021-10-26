//
//  DevotionalVC.swift
//  ICMA
//
//  Created by Dharmani Apps on 18/10/21.
//

import UIKit
import FittedSheets

class DevotionalVC: UIViewController {
   
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var lblLink: ICRegularLabel!
    @IBOutlet weak var lblPasscode: ICRegularLabel!
    @IBOutlet weak var lblMeeting: ICRegularLabel!
    var centerFrame : CGRect!
    
    func presentPopUp()  {
        self.view.backgroundColor = .none
        dataView.frame = CGRect(x: centerFrame.origin.x, y: view.frame.size.height, width: centerFrame.width, height: centerFrame.height)
        dataView.isHidden = false
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.90, initialSpringVelocity: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.dataView.frame = self.centerFrame
        }, completion: nil)
    }
    
    static func instantiate() -> DevotionalVC {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: "DevotionalVC") as! DevotionalVC
    }
    func dismissPopUp(_ dismissed:@escaping ()->())  {
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.90, initialSpringVelocity: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            
            self.dataView.frame = CGRect(x: self.centerFrame.origin.x, y: self.view.frame.size.height, width: self.centerFrame.width, height: self.centerFrame.height)
            
        },completion:{ (completion) in
            self.dismiss(animated: false, completion: {
            })
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func btnDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
