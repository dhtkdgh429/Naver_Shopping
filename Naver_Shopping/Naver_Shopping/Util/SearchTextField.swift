//
//  SearchTextField.swift
//  Naver_Shopping
//
//  Created by Oh Sangho on 28/03/2019.
//  Copyright © 2019 Oh Sangho. All rights reserved.
//

import UIKit

class SearchTextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
    
    var tableView = UITableView()
    
    override func awakeFromNib() {
        self.layer.borderColor = ColorUtil.getCustomGreen().cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 3
        self.backgroundColor = UIColor.white
        self.clearButtonMode = .whileEditing
        
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
