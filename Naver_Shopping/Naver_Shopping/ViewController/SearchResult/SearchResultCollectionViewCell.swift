//
//  SearchResultCollectionViewCell.swift
//  Naver_Shopping
//
//  Created by Oh Sangho on 30/03/2019.
//  Copyright © 2019 Oh Sangho. All rights reserved.
//

import UIKit

class SearchResultCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lpriceLabel: UILabel!
    
    var url: String?
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        itemImage.image = nil
        titleLabel.text = nil
        lpriceLabel.text = nil
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // reusing될 때 초기화
        itemImage.image = nil
        titleLabel.text = nil
        lpriceLabel.text = nil
    }
    
    func setLabel(item: ShoppingItem) {
        
        let title = item.title?.replace(of: "<b>|</b>", with: "")
        titleLabel.text = title
        let dLprice = Double(item.lprice!)! as NSNumber
        let lprice = numberFormatter.string(from: dLprice)
        lpriceLabel.text = String(format: "%@원", lprice!)
    }
    
    func setImage(_ url: String) {
        if url == self.url {
            return
        }
        self.url = url
        
//        print("Download Started")
        if let imageURL = URL(string: url) {
            GlobalUtil.getData(from: imageURL) { data, response, error in
                guard let data = data, error == nil else { return }
//                print("Download Finished")
                DispatchQueue.main.async() {
                    self.itemImage.image = UIImage(data: data)
                }
            }
        }
    }
}



