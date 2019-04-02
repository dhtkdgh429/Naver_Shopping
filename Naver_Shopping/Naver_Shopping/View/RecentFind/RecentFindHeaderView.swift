//
//  RecentFindHeaderView.swift
//  Naver_Shopping
//
//  Created by Oh Sangho on 02/04/2019.
//  Copyright © 2019 Oh Sangho. All rights reserved.
//

import UIKit

class RecentFindHeaderView: UITableViewHeaderFooterView {

    static let reuseIdentifer = "RecentFindHeaderView"
    let customLabel = UILabel()
    
    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        customLabel.font = UIFont.boldSystemFont(ofSize: 14)
        
        customLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(customLabel)
        self.contentView.backgroundColor = UIColor.white
        
        let margins = contentView.layoutMarginsGuide
        customLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        customLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        customLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        customLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
