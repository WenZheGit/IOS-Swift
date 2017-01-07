//
//  PropertyTableViewCell.swift
//  LostAndFoundIOS
//
//  Created by Kevin on 9/05/2016.
//  Copyright © 2016 Vincent. All rights reserved.
//

import UIKit

class PropertyTableViewCell: UITableViewCell {
    
    @IBOutlet var title: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var time: UILabel!
    
    var property: Property?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureCell(property: Property) {
        self.property = property
        
        // Set the labels and textView.
        self.title.text = property.title
        self.address.text = property.address
        self.time.text = property.time
    }
}
