//
//  AudioVC.swift
//  ICMA
//
//  Created by Ucreate on 12/10/21.
//

import UIKit

class AudioVC: UIViewController {
    
    @IBOutlet weak var sliderValue: UISlider!
    @IBOutlet weak var lblEndTime: ICMediumLabel!
    @IBOutlet weak var lblStartTime: ICMediumLabel!
    @IBOutlet weak var lblTitle: ICMediumLabel!
    @IBOutlet weak var imgMain: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnSlider(_ sender: Any) {
        lblStartTime.text = "\(sliderValue.value)"
    }
    
    @IBAction func btnClose(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBckwrd(_ sender: Any) {
    }
    
    @IBAction func btnForward(_ sender: Any) {
    }
    
    @IBAction func btnPlay(_ sender: Any) {
    }
}
