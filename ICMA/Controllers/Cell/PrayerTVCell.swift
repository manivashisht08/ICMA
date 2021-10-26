//
//  PrayerTVCell.swift
//  ICMA
//
//  Created by Ucreate on 11/10/21.
//

import UIKit

class PrayerTVCell: UITableViewCell {

    @IBOutlet var lblName: ICSemiboldLabel!
    @IBOutlet var lblDetails: ICRegularLabel!
    @IBOutlet var lblTime: ICMediumLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
