//
//  SubscriptionTVCell.swift
//  ICMA
//
//  Created by Ucreate on 14/10/21.
//

import UIKit

class SubscriptionTVCell: UITableViewCell {

    @IBOutlet weak var lblTime: ICMediumLabel!
    @IBOutlet weak var lblRate: ICMediumLabel!
    @IBOutlet weak var lblDetails: ICMediumLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
