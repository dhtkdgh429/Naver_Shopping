//
//  RecentFindTableViewCell.swift
//  Naver_Shopping
//
//  Created by Oh Sangho on 01/04/2019.
//  Copyright © 2019 Oh Sangho. All rights reserved.
//

import UIKit

class RecentFindTableViewCell: UITableViewCell {

    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var findLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setLabel(index:Int, item: String) {
        
        indexLabel.text = String(index)
        findLabel.text = item
    }
}
