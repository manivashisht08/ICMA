//
//  DevotionalVC.swift
//  ICMA
//
//  Created by Dharmani Apps on 18/10/21.
//

import UIKit
import FittedSheets

class DevotionalVC: UIViewController {
   
    @IBOutlet weak var linkText: UITextView!
    @IBOutlet weak var dataView: UIView!
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
        let messageStr = " https: // us04web.zoom.us/j/78263208311? pwd = dDNiMU5yQ2|IW|U2RXN2dnZwN0|nZz09 "
                
                var attributedString: NSMutableAttributedString? = nil
                do {
                    if let data = messageStr.data(using: .unicode) {
                        attributedString = try
                            
                            NSMutableAttributedString(data: data,
                                                      options: [.documentType : NSAttributedString.DocumentType.html],
                                                      documentAttributes: nil)
                    }
                } catch {
                }
                var res = attributedString
                res?.beginEditing()
                res?.enumerateAttribute(
                    .font,
                    in: NSRange(location: 0, length: res?.length ?? 0),
                    options: [],
                    using: { value, range, stop in
                        if value != nil {
                            
                            let oldFont = value as? UIFont
                            print("old font---> \(oldFont?.pointSize ?? 0.0)")
                            let oldFontSize = oldFont?.pointSize ?? 0.0
                            let newFont = oldFont?.withSize(14)
                            res?.addAttribute(.font, value: newFont, range: range)
                        }
                })
        
                res?.endEditing()
       
        linkText.attributedText = res
        linkText.textColor = #colorLiteral(red: 0.6210585237, green: 0.1947439313, blue: 0.9591183066, alpha: 1)
    }

    
    @IBAction func btnDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
