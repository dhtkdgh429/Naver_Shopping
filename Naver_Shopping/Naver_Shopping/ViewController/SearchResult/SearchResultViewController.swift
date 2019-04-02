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
    @IBOutlet weak var tableView: RecentFindTableView!
    @IBOutlet weak var tableViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var filterItem: UIBarButtonItem!
    private var filterView: FilterView!
    private var filterViewTopConst: NSLayoutConstraint!
//    @IBOutlet weak var filterViewHeightConst: NSLayoutConstraint!

    
    let cellHeight:CGFloat = 35.0
    
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
    // Filter 관련.
    var isFilterShow: Bool = false
    
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
        
        // search TextField
        textField.alpha = 0
        textField.delegate = self
        textFieldConst.constant = -60
        // bgButton set
        bgButton.backgroundColor = UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.7)
        bgButton.isHidden = true
        
        filterItem.tintColor = ColorUtil.getCustomGreen()
        tableView.delegate = self
        tableView.dataSource = shopping
        setFilterView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // BackBarItem
        self.setBackButton()
        
        updateTableView()
    }
    
    // 필터 뷰 세팅.
    private func setFilterView() {
        
        filterView = FilterView.initFilterView()
        view.addSubview(filterView)
        filterView.delegate = self
        filterView.translatesAutoresizingMaskIntoConstraints = false
        
        // default view setting.
        filterViewTopConst = filterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -filterView.frame.height)
        filterViewTopConst.isActive = true
        filterView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        filterView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        filterView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
    }
    
    private func animateFilterView(isFilterShow: Bool) {
        self.filterViewTopConst.isActive = false
        UIView.animate(withDuration: 0.3) {
            if isFilterShow {
                self.filterViewTopConst = self.filterView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: -self.filterView.frame.height)
                self.filterViewTopConst.isActive = true
                self.isFilterShow = false
            } else {
                self.filterViewTopConst = self.filterView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
                self.filterViewTopConst.isActive = true
                self.isFilterShow = true
            }
            self.view.layoutIfNeeded()
        }
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
        self.animatedTextfield(isShow: self.isShow)
        
    }
    
    @IBAction func touchedFilterBarButton(_ sender: UIBarButtonItem) {
        animateFilterView(isFilterShow: self.isFilterShow)
    }
    
    
    @IBAction func touchedBgButton(_ sender: Any) {
        self.textField.resignFirstResponder()
        self.animatedTextfield(isShow: true)
    }
    
    private func animatedTextfield(isShow: Bool) {
        
        if !isShow {
            self.textField.becomeFirstResponder()
        } else {
            self.textField.resignFirstResponder()
        }
        
        UIView.animate(withDuration: 0.3) {
            
            if isShow {
                self.textFieldConst.constant = -60
                self.textField.alpha = 0
                self.bgButton.isHidden = true
                self.tableView.isHidden = true
                self.isShow = false
            } else {
                self.textFieldConst.constant = 20
                self.textField.alpha = 1
                self.bgButton.isHidden = false
                self.tableView.isHidden = false
                self.isShow = true
            }
            self.view.layoutIfNeeded()
        }
    }
    
    private func updateTableView() {
        // find tableView data set
        tableViewHeightConst.constant = tableView.getTableViewHeight(count: shopping.recentFind.count)
        tableView.reloadData()
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
    
    private func pushSearchFindString(text: String, parameters: [String:String]?) {
        shopping.fetchShoppingData(findString: text, parameters: parameters) { (shoppingResult) in
            switch shoppingResult {
            case let .Success(shopping):
                print("Result Shopping data : \(shopping.count)")
                self.shoppingArray = shopping
                
                DispatchQueue.main.async {
                    self.textField.resignFirstResponder()
                    self.collectionView.reloadData()
                    self.animatedTextfield(isShow: true)
                    // 검색어 저장 메소드로 수정.
                    self.shopping.setRecentFindData(findString: text)
                    self.navigationItem.title = self.shopping.recentFind.first
                    self.textField.text = ""
                    self.updateTableView()
                }
            case let .Failure(error):
                print("Result Fetching Error \(error)")
                self.textField.resignFirstResponder()
                self.animatedTextfield(isShow: true)
            }
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
        cell.setLabel(item: item)
        cell.setImage(item.image!)
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
}

extension SearchResultViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.text!.count > 0 {
            pushSearchFindString(text: textField.text!, parameters: nil)
            return true
        } else {
            return false
        }
        
    }
}

// MARK: - UITableViewDelegate
extension SearchResultViewController : UITableViewDelegate {
    
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
        self.pushSearchFindString(text: findString!, parameters: nil)
    }
}

// MARK: - RecentFindHeaderViewDelegate
// 최근 검색어 헤더 delegate
extension SearchResultViewController : RecentFindHeaderViewDelegate {
    
    func clearRecentFindData() {
        print("clear!!!")
        self.shopping.recentFind.removeAll()
        self.shopping.removeRecentUserData()
        self.updateTableView()
        
    }
    
}

// MARK: - FilterViewDelegate
// 필터 delegate
extension SearchResultViewController : FilterViewDelegate {
    func touchedFilterButton(type: FilterType) {
        self.pushSearchFindString(text: self.shopping.recentFind.first!, parameters: ["sort":type.rawValue])
        self.animateFilterView(isFilterShow: true)
    }
}
