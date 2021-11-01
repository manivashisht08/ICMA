//
//  BreathingTVCell.swift
//  ICMA
//
//  Created by Dharmani Apps on 06/10/21.
//

import UIKit

class BreathingTVCell: UITableViewCell {

   var detailsArr:audioVideoListingModel?{
        didSet{
            details()
        }
    }
    
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
    
    func details(){
        self.profileImg.sd_setImage(with: URL(string: detailsArr?.audio_thumbnail ?? ""), placeholderImage: UIImage(named: "placehldr"))
        lblName.addLeading(image: #imageLiteral(resourceName: "music") , text: " \(detailsArr?.title ?? "")")
        lblTime.addLeading(image: #imageLiteral(resourceName: "clock") , text: " \(detailsArr?.time() ?? "")")
//        lblName.text =  detailsArr?.title ?? ""
//        lblTime.text =  detailsArr?.time() ?? ""
    }
    
}
