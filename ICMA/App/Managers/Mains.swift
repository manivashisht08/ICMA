//
//  Mains.swift
//  ICMA
//
//  Created by Vivek Dharmani on 08/11/21.
//

import Foundation
struct Mains {
    static var AppTitle = "ICMA"
    func convertToHMS(number: Int) -> String {
//        let minute  = (number % 3600) / 60;
        let minute = (number / 60) % 3600
        let second = (number % 3600) % 60 ;
        var m = String(minute);
        var s = String(second);
        if m.count == 1{
            m = "0\(minute)";
        }
        if s.count == 1{
            s = "0\(second)";
        }
        return "\(m):\(s)"
    }
}
