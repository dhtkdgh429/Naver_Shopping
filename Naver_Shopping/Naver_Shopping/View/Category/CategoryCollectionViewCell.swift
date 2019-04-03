//
//  CategoryCollectionViewCell.swift
//  Naver_Shopping
//
//  Created by Oh Sangho on 03/04/2019.
//  Copyright © 2019 Oh Sangho. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryLabel.text = nil
        imageView.layer.cornerRadius = 5
        imageView.backgroundColor = UIColor.init(red: 1.000, green: 0.940, blue: 0.763, alpha: 1.0)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        categoryLabel.text = nil
    }
    
    func setLabel(item: String) {
        categoryLabel.text = item
    }
    
}
