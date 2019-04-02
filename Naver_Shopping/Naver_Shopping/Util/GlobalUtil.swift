//
//  GlobalUtil.swift
//  Naver_Shopping
//
//  Created by Oh Sangho on 30/03/2019.
//  Copyright © 2019 Oh Sangho. All rights reserved.
//

import UIKit

class GlobalUtil {
    // for imageDownload.
    static func getData(from url: URL?, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url!, completionHandler: completion).resume()
    }
    
}


extension String {
    func replace(of: String, with: String) -> String {
        let result = self.replacingOccurrences(of: of, with: with, options: .regularExpression, range: nil)
        return result
    }
}

extension UIViewController {
    func setBackButton() {
        // Main
        if self is MainSearchViewController {
            navigationController?.isNavigationBarHidden = true
        } else {
            navigationController?.isNavigationBarHidden = false
        }
        
        let image = UIImage(named: "back-icon")
        navigationController?.navigationBar.tintColor = ColorUtil.getCustomGreen()
        navigationController?.navigationBar.backIndicatorImage = image
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }
    
}
