//
//  RecentFindself.swift
//  Naver_Shopping
//
//  Created by Oh Sangho on 02/04/2019.
//  Copyright © 2019 Oh Sangho. All rights reserved.
//

import UIKit

class RecentFindTableView: UITableView {
    // tableView header 및 cell 높이.
    let cellHeight:CGFloat = 35.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // tableView set
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = 3
        self.layer.borderColor = UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        self.layer.borderWidth = 1.0
        self.separatorStyle = .none
        self.isScrollEnabled = false
        self.isHidden = true
        self.register(RecentFindHeaderView.self, forHeaderFooterViewReuseIdentifier: RecentFindHeaderView.reuseIdentifer)
        self.register(UINib.init(nibName: "RecentFindTableViewCell", bundle: nil), forCellReuseIdentifier: "RecentFindTableViewCell")
    }
    
    
    func getTableViewHeight(count: Int) -> CGFloat {
        let findCount = CGFloat(count)
        // 개수 * 60(cell높이) + header높이
        var height: CGFloat?
        if count > 0 {
            height = findCount * cellHeight + cellHeight
        } else {
            height = findCount * cellHeight
        }
        return height!
    }
    
}

