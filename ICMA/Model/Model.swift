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
struct notificationListingModel {
    var notification_id = String()
    var title = String()
    var message = String()
    var userid = String()
    var notification_type = String()
    var creation_at = String()
    var name = String()
    var image = String()
    init(notification_id : String, title:String,message : String, userid:String, notification_type:String, creation_at:String, name:String, image:String ) {
        self.notification_id = notification_id
        self.title = title
        self.message = message
        self.userid = userid
        self.notification_type = notification_type
        self.creation_at = creation_at
        self.name = name
        self.image = image
    }
}

struct videoListingModel {
    var id = String()
    var title = String()
    var video = String()
    var name = String()
    var start_time = String()
    var end_time = String()
    var video_width = String()
    var video_height = String()
    var video_thumbnail = String()
    var subcategory = String()
    var creation_at = String()
    init(id : String, title:String,video : String, name:String, start_time:String, end_time:String, video_width:String, video_height:String,video_thumbnail:String,subcategory:String,creation_at : String ) {
        self.id = id
        self.title = title
        self.video = video
        self.name = name
        self.start_time = start_time
        self.end_time = end_time
        self.video_width = video_width
        self.video_height = video_height
        self.video_thumbnail = video_thumbnail
        self.subcategory = subcategory
        self.creation_at = creation_at
        
    }
}

struct AudioModel {
    let subcategoryName: String?
    let audioDataModel: [audioVideoListingModel]
    init(subcategoryName:String,audioDataModel:[audioVideoListingModel]) {
        self.subcategoryName = subcategoryName
        self.audioDataModel = audioDataModel
    }
}

struct audioVideoListingModel {
    var id:String?
    var title:String?
    var audio :String?
    var start_time :String?
    var end_time :String?
    var audio_thumbnail :String?
    var subcategory_id :String?
    var categoryid :String?
    var creation_at :String?
    init(id : String, title:String,audio : String,  start_time:String, end_time:String ,audio_thumbnail:String,subcategory_id:String,creation_at : String, categoryid:String ) {
        self.id = id
        self.title = title
        self.audio = audio
        self.start_time = start_time
        self.end_time = end_time
        self.categoryid = categoryid
        self.audio_thumbnail = audio_thumbnail
        self.subcategory_id = subcategory_id
        self.creation_at = creation_at
        
    }
    
    func time()->String{
        let timeString = self.timeStringFromUnixTimeOnly(unixTime: Double(creation_at ?? "0.0") ?? 0.0)
        return timeString
    }
    
    func timeStringFromUnixTimeOnly(unixTime: Double) -> String {
        let date = NSDate(timeIntervalSince1970: unixTime)
        let dateFormatter = DateFormatter()
        // Returns date formatted as 12 hour time.
        dateFormatter.dateFormat = "hh:mm"
        return dateFormatter.string(from: date as Date)
    }
}
