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
    
    var url: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        itemImage.image = nil
    }
    
    func setImage(_ url: String) {
        if url == self.url {
            return
        }
        self.url = url
        
        print("Download Started")
        if let imageURL = URL(string: url) {
            GlobalUtil.getData(from: imageURL) { data, response, error in
                guard let data = data, error == nil else { return }
                print("Download Finished")
                DispatchQueue.main.async() {
                    self.itemImage.image = UIImage(data: data)
                }
            }
        }
    }
}
