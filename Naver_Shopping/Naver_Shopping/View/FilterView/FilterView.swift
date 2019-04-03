//
//  FilterView.swift
//  Naver_Shopping
//
//  Created by Oh Sangho on 02/04/2019.
//  Copyright © 2019 Oh Sangho. All rights reserved.
//

import UIKit

protocol FilterViewDelegate {
    func touchedFilterButton(type: FilterType)
}

enum FilterType:String {
    case dateButton = "date"
    case ascButton = "asc"
    case dscButton = "dsc"
}

class FilterView: UIView {
    
    @IBOutlet weak var dateButton: UIButton!    // 등록일순
    @IBOutlet weak var ascButton: UIButton!     // 가격 오름차순
    @IBOutlet weak var dscButton: UIButton!     // 가격 내림차순
    
    var delegate: FilterViewDelegate?
    
    static func initFilterView() -> FilterView {
        let view = Bundle.main.loadNibNamed("FilterView", owner: self, options: nil)?.first as! FilterView
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.init(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
        
    }
    
    @IBAction func touchedDateButton(_ sender: UIButton) {
        print("date button")
        if let delegate = self.delegate {
            delegate.touchedFilterButton(type: .dateButton)
        }
    }
    
    @IBAction func touchedAscButton(_ sender: UIButton) {
        print("asc button")
        if let delegate = self.delegate {
            delegate.touchedFilterButton(type: .ascButton)
        }
    }
    
    @IBAction func touchedDscButton(_ sender: UIButton) {
        print("dsc button")
        if let delegate = self.delegate {
            delegate.touchedFilterButton(type: .dscButton)
        }
    }
    
}

