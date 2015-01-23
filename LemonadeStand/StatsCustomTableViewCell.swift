//
//  StatsCustomTableViewCell.swift
//  LemonadeStand
//
//  Created by Robb C. Bennett on 1/21/15.
//  Copyright (c) 2015 Visual23. All rights reserved.
//

import UIKit

class StatsCustomTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var statsIconImage: UIImageView!
    @IBOutlet weak var statsLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(iconImage: String, stat: String) {
        self.statsIconImage.image = UIImage(named: iconImage)
        self.statsLabel.text = stat
    }

}
