//
//  MainSearchViewController.swift
//  Naver_Shopping
//
//  Created by Oh Sangho on 28/03/2019.
//  Copyright © 2019 Oh Sangho. All rights reserved.
//

import UIKit
import Kingfisher

class MainSearchViewController: UIViewController {
    
    @IBOutlet weak var textField: SearchTextField!
    @IBOutlet weak var textFieldConst: NSLayoutConstraint!
    @IBOutlet weak var bgButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConst: NSLayoutConstraint!
    
    let cellHeight:CGFloat = 35.0
    
    
    var shopping: ShoppingStore!
    var shoppingArray: [ShoppingItem]!
    // search textfield 관련
    var isShow: Bool = false
    
    let cache = ImageCache.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        
        // bgButton set
        bgButton.backgroundColor = UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.7)
        bgButton.isHidden = true
        
        // BackBarItem
        self.setBackButton()
        
        // tableView set
        tableView.backgroundColor = UIColor.clear
        tableView.layer.cornerRadius = 3
        tableView.layer.borderColor = UIColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0).cgColor
        tableView.layer.borderWidth = 1.0
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 17)
        tableView.delegate = self
        tableView.dataSource = shopping
        tableView.register(UINib.init(nibName: "RecentFindTableViewCell", bundle: nil), forCellReuseIdentifier: "RecentFindTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        textField.text = ""
        
        // find tableView data set
        tableViewHeightConst.constant = getTableViewHeight()
        tableView.reloadData()
        
        // image cache clear
        cache.clearMemoryCache()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSearch" {
            let searchResultVC = segue.destination as! SearchResultViewController
            searchResultVC.shoppingArray = shoppingArray
            searchResultVC.shopping = shopping
        }
    }
    
    @IBAction func touchedBgButton(_ sender: Any) {
        self.textField.resignFirstResponder()
        self.animatedTextfield(isShow: isShow)
    }
    
    private func getTableViewHeight() -> CGFloat {
        let findCount = CGFloat(self.shopping.recentFind.count)
        // 개수 * 60(cell높이)
        let height = findCount * cellHeight
        return height
    }
    
    private func animatedTextfield(isShow: Bool) {
        
        UIView.animate(withDuration: 0.3) {
            
            if isShow {
                self.textFieldConst = self.textField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
                self.textFieldConst.isActive = true
                self.bgButton.isHidden = true
                self.isShow = false
            } else {
                self.textFieldConst.isActive = false
                self.bgButton.isHidden = false
                self.isShow = true
            }
            self.view.layoutIfNeeded()
        }
    }
    
}

extension MainSearchViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        self.animatedTextfield(isShow: false)
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.text!.count > 0 {
            self.pushSearchFindString(text: textField.text!)
            self.textField.resignFirstResponder()
            self.animatedTextfield(isShow: true)
            return true
        } else {
            self.textField.resignFirstResponder()
            self.animatedTextfield(isShow: true)
            return false
        }
        
    }
    
    private func pushSearchFindString(text: String) {
        
        shopping.fetchShoppingData(findString: text, parameters: nil) { (shoppingResult) in
            switch shoppingResult {
            case let .Success(shopping):
                print("Shopping data : \(shopping.count)")
                self.shoppingArray = shopping
                
                DispatchQueue.main.async {
                    // 검색어 저장 메소드로 수정.
                    self.shopping.setRecentFindData(findString: text)
                    self.performSegue(withIdentifier: "ShowSearch", sender: self)
                }
            case let .Failure(error):
                print("Fetching Error \(error)")
            }
        }
        
    }
    
}

// MARK: - UITableViewDelegate
extension MainSearchViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! RecentFindTableViewCell
        
        let findString = cell.findLabel.text
        self.pushSearchFindString(text: findString!)
    }
}
