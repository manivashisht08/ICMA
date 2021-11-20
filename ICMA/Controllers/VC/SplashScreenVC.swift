////
////  SplashScreenVC.swift
////  ICMA
////
////  Created by Dharmani Apps on 20/11/21.
////
//
//import UIKit
//
//class SplashScreenVC: UIViewController {
//
//    @IBOutlet weak var imgSplash: UIImageView!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        self.animated()
//
//    }
//    func animated() {
//        UIView.animate(withDuration: 1.2, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {() -> Void in
//            self.imgSplash.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
//        }, completion: {(_ finished: Bool) -> Void in
//            self.perform(#selector(self.navigateForward), with: nil, afterDelay: 1)
//        })
//    }
//    @objc func navigateForward(){
//        if AFWrapperClass.getAuthToken().isEmpty{
//            print("empty token")
//            let vc = LogInVC.instantiate(fromAppStoryboard: .Main)
//            self.navigationController?.pushViewController(vc, animated: true)
//        }else{
//            print("non empty token")
//            let vc = TabBarVC.instantiate(fromAppStoryboard: .Main)
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//    }
//
//
//
//}
