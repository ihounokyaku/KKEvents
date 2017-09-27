//
//  EventCell.swift
//  KKEvents
//
//  Created by Southard Dylan on 10/3/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit
//textLabel
//backgroundView
//imageView
class EventCell: UITableViewCell {

    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var logoPic: UIImageView!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
