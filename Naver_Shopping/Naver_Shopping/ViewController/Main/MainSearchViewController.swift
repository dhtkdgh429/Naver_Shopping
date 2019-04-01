//
//  MainSearchViewController.swift
//  Naver_Shopping
//
//  Created by Oh Sangho on 28/03/2019.
//  Copyright © 2019 Oh Sangho. All rights reserved.
//

import UIKit

class MainSearchViewController: UIViewController {
    
    @IBOutlet weak var textField: SearchTextField!
    
    var shopping: ShoppingStore!
    var shoppingArray: [ShoppingItem]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.layer.borderColor = ColorUtil.getCustomGreen().cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 3
        textField.delegate = self
        
        // BackBarItem
        self.setBackButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSearch" {
            let searchResultVC = segue.destination as! SearchResultViewController
            searchResultVC.shoppingArray = shoppingArray
            searchResultVC.shopping = shopping
        }
    }
}

extension MainSearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.text!.count > 0 {
            shopping.fetchShoppingData(findString: textField.text!, parameters: nil) { (shoppingResult) in
                switch shoppingResult {
                case let .Success(shopping):
                    print("Shopping data : \(shopping.count)")
                    self.shoppingArray = shopping
                    
                    DispatchQueue.main.async {
                        self.textField.resignFirstResponder()
                        self.shopping.findString = textField.text!
                        self.performSegue(withIdentifier: "ShowSearch", sender: self)
                    }
                case let .Failure(error):
                    print("Fetching Error \(error)")
                }
            }
            
            return true
        } else {
            return false
        }
        
    }
    
}
