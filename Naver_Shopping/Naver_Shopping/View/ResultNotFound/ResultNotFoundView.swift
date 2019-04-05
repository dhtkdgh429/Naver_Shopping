//
//  ResultNotFoundView.swift
//  Naver_Shopping
//
//  Created by Oh Sangho on 05/04/2019.
//  Copyright © 2019 Oh Sangho. All rights reserved.
//

import UIKit

class ResultNotFoundView: UIView {
    
    @IBOutlet weak var resultLabel: UILabel!
    
    var isShow: Bool = true
    
    static func initResultNotFoundView() -> ResultNotFoundView {
        let view = Bundle.main.loadNibNamed("ResultNotFoundView", owner: self, options: nil)?.first as! ResultNotFoundView
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.init(red: 0.8, green: 0.8, blue: 0.8, alpha: 7.0).cgColor
        self.alpha = 0
    }
    
    func setResultLabel(text: String) {
        
        let result = String(format: "%@ 에 대한 검색 결과가 없습니다.", text)
        // 검색어 폰트 변경.
        let attributed = NSMutableAttributedString(string: result)
        let fontBold = UIFont.boldSystemFont(ofSize: 14)
        attributed.addAttribute(kCTFontAttributeName as NSAttributedString.Key, value: fontBold, range: (result as NSString).range(of: text))
        
        self.resultLabel.attributedText = attributed
        
    }
    
    func animateResultView() {
        
        UIView.animate(withDuration: 0.3, animations: {
            if self.isShow {
                self.alpha = 0
            } else {
                self.alpha = 1
            }
            self.layoutIfNeeded()
        }) { (isShow) in
            UIView.animate(withDuration: 0.3, delay: 2.0, options: [], animations: {
                if !self.isShow {
                    self.alpha = 0
                }
                self.layoutIfNeeded()
            }, completion: nil)
            
        }
        
    }
    
    
}
