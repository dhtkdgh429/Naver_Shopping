//
//  SearchResultViewController.swift
//  Naver_Shopping
//
//  Created by Oh Sangho on 30/03/2019.
//  Copyright © 2019 Oh Sangho. All rights reserved.
//

import UIKit

class SearchResultViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var textField: SearchTextField!
    @IBOutlet weak var textFieldConst: NSLayoutConstraint!
    @IBOutlet weak var bgButton: UIButton!
    
    var shopping: ShoppingStore! {
        didSet {
            navigationItem.title = shopping.recentFind.first
        }
    }
    var shoppingArray: [ShoppingItem]!
    
    // collectionview moredata 관련..
    var moreCount: Int = 0
    var isLoading: Bool = false {
        didSet {
            if isLoading {
                DispatchQueue.main.async {
                    self.indicator.startAnimating()
                }
            } else {
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                }
                
            }
        }
    }
    // search textfield 관련
    var isShow: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib.init(nibName: "SearchResultCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SearchResultCollectionViewCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MoreItemCell")
        
        if shoppingArray != nil {
            print("result VC : \(shoppingArray.count)")
        } else {
            print("shopping nil!!!!")
        }
        
        // BackBarItem
        self.setBackButton()
        
        // search TextField
        textField.layer.borderColor = ColorUtil.getCustomGreen().cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 3
        textField.backgroundColor = UIColor.white
        textField.delegate = self
        textField.alpha = 0
        textField.clearButtonMode = .whileEditing
        textFieldConst.constant = -60
        // bgButton set
        bgButton.backgroundColor = UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.7)
        bgButton.isHidden = true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let resultDetailVC = segue.destination as! ResultDetailViewController
            if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                resultDetailVC.shoppingItem = shoppingArray[indexPath.row]
            }
        }
    }
    
    @IBAction func touchedSearchBarButton(_ sender: UIBarButtonItem) {
        self.animatedTextfield()
        
    }
    
    @IBAction func touchedBgButton(_ sender: Any) {
        self.textField.resignFirstResponder()
        self.animatedTextfield()
    }
    
    private func animatedTextfield() {
        
        UIView.animate(withDuration: 0.3) {
            
            if self.isShow {
                self.textFieldConst.constant = -60
                self.textField.alpha = 0
                self.bgButton.isHidden = true
                self.isShow = false
            } else {
                self.textFieldConst.constant = 20
                self.textField.alpha = 1
                self.bgButton.isHidden = false
                self.isShow = true
            }
            self.view.layoutIfNeeded()
        }
    }
    
    
}

extension SearchResultViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shoppingArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthSize = UIScreen.main.bounds.width
        return CGSize(width: widthSize/3-15, height: widthSize/3-15+50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return inset
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "SearchResultCollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! SearchResultCollectionViewCell
        
        let item = shoppingArray[indexPath.row]
        
        cell.setImage(item.image!)
        cell.setLabel(item: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowDetail", sender: self)    
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == self.shoppingArray.count-1, !isLoading {
            self.isLoading = true
            self.reloadMoreData()
            
            self.moreCount += 1
        }
    }
    
    private func reloadMoreData() {
        // startValue 최대 값이 1000이므로, 데이터 갯수가 998보다 많으면 return시킴.
        if self.shoppingArray.count > 998 {
            return
        }
        
        // 페이지 시작 지점 : 현재 데이터 개수의 + 1 위치...
        let startValue = String(self.shoppingArray.count + 1)
        let startParameter = ["start":startValue]
        self.shopping.fetchShoppingData(findString: self.shopping.recentFind.first!, parameters: startParameter) { (shoppingResult) in
            switch shoppingResult {
            case let .Success(shopping):
                print("More Shopping data : \(shopping.count)")
                self.shoppingArray.append(contentsOf: shopping)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                self.isLoading = false
            case let .Failure(error):
                print("More Fetching Error \(error)")
            }
        }
    }
    
}

extension SearchResultViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.text!.count > 0 {
            shopping.fetchShoppingData(findString: textField.text!, parameters: nil) { (shoppingResult) in
                switch shoppingResult {
                case let .Success(shopping):
                    print("Result Shopping data : \(shopping.count)")
                    self.shoppingArray = shopping
                    
                    DispatchQueue.main.async {
                        self.textField.resignFirstResponder()
                        self.collectionView.reloadData()
                        self.animatedTextfield()
                        self.shopping.recentFind.insert(textField.text!, at: 0)
                        self.navigationItem.title = self.shopping.recentFind.first
                        textField.text = ""
                    }
                case let .Failure(error):
                    print("Result Fetching Error \(error)")
                }
            }
            return true
        } else {
            return false
        }
        
    }
}
