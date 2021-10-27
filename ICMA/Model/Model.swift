//
//  Model.swift
//  ICMA
//
//  Created by Dharmani Apps on 27/10/21.
//

import Foundation


struct getPrayerModel {
    var id = String()
    var name = String()
    var userid = String()
    var title = String()
    var detail = String()
    var creation_at = String()
    
    init(id :String, name:String, userid:String, title:String, detail:String, creation_at : String) {
        self.id = id
        self.name = name
        self.userid = userid
        self.title = title
        self.detail = detail
        self.creation_at = creation_at
    }
}
