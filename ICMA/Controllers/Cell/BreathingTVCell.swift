//
//  BreathingTVCell.swift
//  ICMA
//
//  Created by Dharmani Apps on 06/10/21.
//

import UIKit

class BreathingTVCell: UITableViewCell {

    @IBOutlet weak var lblTime: ICRegularLabel!
    @IBOutlet weak var lblName: ICMediumLabel!
    @IBOutlet weak var profileImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
