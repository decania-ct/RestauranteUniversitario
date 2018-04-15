//
//  NotificationsTableViewCell.swift
//  RestauranteUniversitario
//
//  Created by Felipe Podolan Oliveira on 02/08/17.
//  Copyright © 2017 Felipe Podolan Oliveira. All rights reserved.
//

import UIKit

class NotificationsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var identityLabel: UILabel!
    @IBOutlet weak var deleteIcon: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
