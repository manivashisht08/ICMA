//
//  NotificationsTVCell.swift
//  ICMA
//
//  Created by Ucreate on 12/10/21.
//

import UIKit

class NotificationsTVCell: UITableViewCell {

    @IBOutlet weak var lblDate: ICRegularLabel!
    @IBOutlet weak var lblDetail: ICMediumLabel!
    @IBOutlet weak var imgMain: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
