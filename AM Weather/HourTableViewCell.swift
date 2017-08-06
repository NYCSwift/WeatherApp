//
//  HourTableViewCell.swift
//  AM Weather
//
//  Created by Aferdita Muriqi on 1/2/16.
//  Copyright © 2016 Aferdita Muriqi. All rights reserved.
//

import UIKit

class HourTableViewCell: UITableViewCell {

    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
