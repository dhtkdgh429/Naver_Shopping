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
    @IBOutlet weak var tableView: RecentFindTableView!
    @IBOutlet weak var tableViewHeightConst: NSLayoutConstraint!
    
    // 검색 결과 없음 창 관련.
    var resultNotFountView: ResultNotFoundView?
    
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
        
        tableView.delegate = self
        tableView.dataSource = shopping
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // BackBarItem
        self.setBackButton()
        
        // image cache clear
        cache.clearMemoryCache()
        
        updateTableView()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSearch" {
            let searchResultVC = segue.destination as! SearchResultViewController
            searchResultVC.shoppingArray = shoppingArray
            searchResultVC.shopping = shopping
        }
    }
    
    @IBAction func touchedBgButton(_ sender: Any) {
        self.animatedTextfield(isShow: isShow)
    }
    
    private func updateTableView() {
        // find tableView data set
        tableViewHeightConst.constant = tableView.getTableViewHeight(count: shopping.recentFind.count)
        tableView.reloadData()
    }
    
    private func animatedTextfield(isShow: Bool) {
        
        UIView.animate(withDuration: 0.3) {
            
            if isShow {
                self.textField.resignFirstResponder()
                self.textFieldConst = self.textField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
                self.textFieldConst.isActive = true
                self.bgButton.isHidden = true
                self.tableView.isHidden = true
                self.isShow = false
            } else {
                self.textFieldConst.isActive = false
                self.bgButton.isHidden = false
                self.tableView.isHidden = false
                self.isShow = true
            }
            self.view.layoutIfNeeded()
        }
    }
    
    private func pushSearchFindString(text: String) {
        
        shopping.fetchShoppingData(findString: text, parameters: nil, type: nil) { (shoppingResult) in
            switch shoppingResult {
            case let .Success(shopping):
                print("Shopping data : \(shopping.count)")
                if shopping.count > 0 {
                    self.shoppingArray = shopping
                    // 검색어 저장 메소드로 수정.
                    self.shopping.setRecentFindData(findString: text)
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "ShowSearch", sender: self)
                        
                        self.animatedTextfield(isShow: true)
                        self.textField.text = ""
                        self.updateTableView()
                    }
                }
                
            case let .Failure(error):
                print("Fetching Error \(error)")
                
                DispatchQueue.main.async {
                    self.animatedTextfield(isShow: true)
                    
                    self.setResultNotFoundView(text: text)
                    self.resultNotFountView?.isShow = false
                    self.resultNotFountView?.animateResultView()
                    
                    self.textField.text = ""
                }
            }
        }
    }
    
    private func setResultNotFoundView(text: String) {
        self.resultNotFountView = ResultNotFoundView.initResultNotFoundView()
        self.view.addSubview(self.resultNotFountView!)
        self.resultNotFountView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.resultNotFountView?.setResultLabel(text: text)
        
        self.resultNotFountView?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.resultNotFountView?.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.resultNotFountView?.widthAnchor.constraint(equalToConstant: 200).isActive = true
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
            return true
        } else {
            self.animatedTextfield(isShow: true)
            return false
        }
    }
}

// MARK: - UITableViewDelegate
extension MainSearchViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: RecentFindHeaderView.reuseIdentifer) as? RecentFindHeaderView else {
            return nil
        }
        
        header.delegate = self
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! RecentFindTableViewCell
        
        let findString = cell.findLabel.text
        self.pushSearchFindString(text: findString!)
    }
}


// MARK: - RecentFindHeaderViewDelegate
// 최근 검색어 헤더 delegate
extension MainSearchViewController: RecentFindHeaderViewDelegate {
    
    func clearRecentFindData() {
        print("clear!!!")
        self.shopping.recentFind.removeAll()
        self.shopping.removeRecentUserData()
        self.updateTableView()
        
    }
    
}
