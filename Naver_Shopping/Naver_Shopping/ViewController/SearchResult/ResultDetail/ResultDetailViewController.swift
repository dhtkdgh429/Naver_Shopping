//
//  ResultDetailViewController.swift
//  Naver_Shopping
//
//  Created by Oh Sangho on 31/03/2019.
//  Copyright © 2019 Oh Sangho. All rights reserved.
//

import UIKit
import WebKit

class ResultDetailViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    var shoppingItem: ShoppingItem! {
        didSet {
            navigationItem.title = shoppingItem.mallName
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // BackBarItem
        self.setBackButton()
        
        let url = URL(string: shoppingItem.link!)!
        let request = URLRequest(url: url)
        webView.load(request)
        
    }
    
}
