//
//  SearchResultViewController.swift
//  Naver_Shopping
//
//  Created by Oh Sangho on 30/03/2019.
//  Copyright © 2019 Oh Sangho. All rights reserved.
//

import UIKit

enum CollectionViewType {
    case categoryCollectionView,
    resultCollectionView
}

// caseIterable count 위해.
enum CategoryType: Int, CaseIterable {
    case outer = 0,
    top,
    pants,
    skirt,
    onepiece,
    bag,
    shoes,
    traing
}

class SearchResultViewController: UIViewController {
    
    @IBOutlet weak var resultCollectionView: UICollectionView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var textField: SearchTextField!
    @IBOutlet weak var textFieldConst: NSLayoutConstraint!
    @IBOutlet weak var bgButton: UIButton!
    @IBOutlet weak var tableView: RecentFindTableView!
    @IBOutlet weak var tableViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var filterItem: UIBarButtonItem!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    private var filterView: FilterView!
    private var filterViewTopConst: NSLayoutConstraint!

    
    let cellHeight:CGFloat = 35.0
    
    var shopping: ShoppingStore! {
        didSet {
            navigationItem.title = shopping.recentFind.first
        }
    }
    var shoppingArray: [ShoppingItem]!
    var categoryArray = [ShoppingItem]()
    
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
    // Category 관련.
    var isCategoryData: Bool = false
    var titleCategoryArray: [String]?
    // Category 데이터 호출 성공여부.
    var resultCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // category collectionView
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        categoryCollectionView.collectionViewLayout = flowLayout
        categoryCollectionView.showsHorizontalScrollIndicator = false
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.register(UINib.init(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        
        // result collectionView
        resultCollectionView.showsVerticalScrollIndicator = false
        resultCollectionView.delegate = self
        resultCollectionView.dataSource = self
        
        resultCollectionView.register(UINib.init(nibName: "SearchResultCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SearchResultCollectionViewCell")
        resultCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MoreItemCell")
        
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
        filterView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let resultDetailVC = segue.destination as! ResultDetailViewController
            if let indexPath = resultCollectionView.indexPathsForSelectedItems?.first {
                resultDetailVC.shoppingItem = shoppingArray[indexPath.row]
            }
        }
    }
    
    @IBAction func touchedSearchBarButton(_ sender: UIBarButtonItem) {
        
        // 필터 창이 열려있으면 닫음.
        if isFilterShow {
            self.animateFilterView(isFilterShow: true)
        }
        self.animatedTextfield(isShow: self.isShow)
        
    }
    
    @IBAction func touchedFilterBarButton(_ sender: UIBarButtonItem) {
        // 검색 창이 열려있으면 닫음.
        if isShow {
            self.animatedTextfield(isShow: true)
        }
        animateFilterView(isFilterShow: self.isFilterShow)
    }
    
    // 배경 터치.
    @IBAction func touchedBgButton(_ sender: Any) {
        self.textField.resignFirstResponder()
        // 검색 창이 열려있으면 닫음.
        if isShow {
            self.animatedTextfield(isShow: true)
        }
        // 필터 창이 열려있으면 닫음.
        if isFilterShow {
            self.animateFilterView(isFilterShow: true)
        }
        
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
    
    private func animateFilterView(isFilterShow: Bool) {
        self.filterViewTopConst.isActive = false
        UIView.animate(withDuration: 0.3) {
            if isFilterShow {
                self.filterViewTopConst = self.filterView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: -self.filterView.frame.height)
                self.filterViewTopConst.isActive = true
                self.bgButton.isHidden = true
                self.isFilterShow = false
            } else {
                self.filterViewTopConst = self.filterView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
                self.filterViewTopConst.isActive = true
                self.bgButton.isHidden = false
                self.isFilterShow = true
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
        
        // 카테고리 조회 시 리로드.
        if self.isCategoryData {
            self.shopping.fetchCategorySearchData(findArray: self.titleCategoryArray!, parameters: startParameter, type: CollectionViewType.categoryCollectionView) { (shoppingResult) in
                switch shoppingResult {
                case let .Success(shopping):
                    
                    print("More Category Data : \(shopping.count)")
                    self.resultCount += 1
                    self.categoryArray.append(contentsOf: shopping)
                    if self.resultCount == self.titleCategoryArray!.count {
                        self.resultSelectedCategoryItem(true, title: nil)
                    }
                    
                case let .Failure(error):
                    print("More Fetching Error \(error)")
                    self.categoryArray.removeAll()
                    self.resultCount = 0
                }
            }
            // 검색 시 리로드.
        } else {
            self.shopping.fetchShoppingData(findString: self.shopping.recentFind.first!, parameters: startParameter, type: CollectionViewType.resultCollectionView) { (shoppingResult) in
                switch shoppingResult {
                case let .Success(shopping):
                    print("More Shopping data : \(shopping.count)")
                    self.shoppingArray.append(contentsOf: shopping)
                    DispatchQueue.main.async {
                        self.resultCollectionView.reloadData()
                    }
                    self.isLoading = false
                case let .Failure(error):
                    print("More Fetching Error \(error)")
                }
            }
        }
    }
    
    private func pushSearchFindString(text: String, parameters: [String:String]?, type: CollectionViewType) {
        shopping.fetchShoppingData(findString: text, parameters: parameters, type: type) { (shoppingResult) in
            switch shoppingResult {
            case let .Success(shopping):
                print("Result Shopping data : \(shopping.count)")
                
                if type == .resultCollectionView {
                    self.shoppingArray = shopping
                    // 검색어 저장 메소드로 수정.
                    self.shopping.setRecentFindData(findString: text)
                    self.isCategoryData = false
                } else {
                    self.categoryArray.append(contentsOf: shopping)
                }
                
                DispatchQueue.main.async {
                    self.textField.resignFirstResponder()
                    self.resultCollectionView.reloadData()
                    self.animatedTextfield(isShow: true)
                    self.navigationItem.title = self.shopping.recentFind.first
                    self.textField.text = ""
                    self.updateTableView()
                }
            case let .Failure(error):
                print("Result Fetching Error \(error)")
                DispatchQueue.main.async {
                    self.textField.resignFirstResponder()
                    self.animatedTextfield(isShow: true)
                }
            }
        }
    }
    
    
    private func pushCategorySearch(textArray: [String], parameters: [String:String]?, title:String) {
        
        shopping.fetchCategorySearchData(findArray: textArray, parameters: parameters, type: CollectionViewType.categoryCollectionView) { (shoppingResult) in
            
            switch shoppingResult {
            case let .Success(shopping):
                print("3. Category Shopping data : \(shopping.count)")
                self.resultCount += 1
                self.categoryArray.append(contentsOf: shopping)
                if self.resultCount == textArray.count {
                    self.resultSelectedCategoryItem(true, title: title)
                    self.isCategoryData = true
                }
            case let .Failure(error):
                print("Category Fetching Error \(error)")
                self.categoryArray.removeAll()
                self.resultCount = 0
            }
        }
    }
    
    private func resultSelectedCategoryItem(_ isSuccess: Bool, title: String?) {
        // 데이터 호출 성공 시, 업데이트.
        if isSuccess {
            DispatchQueue.main.async {
                if title != nil {
                    self.navigationItem.title = title
                }
                self.shoppingArray = self.categoryArray
                self.isLoading = false
                self.resultCollectionView.reloadData()
                print("4. main update resultSelectedCategoryItem")
            }
        } else {
            // 실패 시, 호출하던 데이터 삭제 후, 기존 데이터 보여주기.
            self.categoryArray.removeAll()
            self.resultCollectionView.reloadData()
        }
    }
    
    private func categoryTypeString(type: CategoryType) -> String {
        switch type {
        case .outer:
            return "아우터"
        case .top:
            return "상의"
        case .pants:
            return "바지"
        case .skirt:
            return "스커트"
        case .onepiece:
            return "원피스"
        case .bag:
            return "가방"
        case .shoes:
            return "슈즈"
        case .traing:
            return "트레이닝"
        }
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension SearchResultViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return CategoryType.allCases.count
        } else {
            return shoppingArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCollectionView {
            return CGSize(width: 60, height: 60)
        } else {
            let widthSize = UIScreen.main.bounds.width
            return CGSize(width: widthSize/3-15, height: widthSize/3-15+50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return inset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == categoryCollectionView {
            return 10.0
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            let identifier = "CategoryCollectionViewCell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CategoryCollectionViewCell
            
            let item = categoryTypeString(type: CategoryType(rawValue: indexPath.row)!)
            cell.setLabel(item: item)
            
            return cell
        } else {
            let identifier = "SearchResultCollectionViewCell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! SearchResultCollectionViewCell
            
            let item = shoppingArray[indexPath.row]
            cell.setLabel(item: item)
            cell.setImage(item.image!)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == categoryCollectionView {
            print("1. selected category \(indexPath.row)")
            // 카테고리 데이터 초기화
            self.resultCount = 0
            self.categoryArray.removeAll()
            let title = categoryTypeString(type: CategoryType(rawValue: indexPath.row)!)
            
            if let itemArray = Category.init(categoryTitle: title).categoryArray {
                self.titleCategoryArray = itemArray
                self.pushCategorySearch(textArray: itemArray, parameters: nil, title: title)
            }
            
            DispatchQueue.main.async {
                self.resultCollectionView.setContentOffset(CGPoint.zero, animated: true)
            }
            
        } else {
            performSegue(withIdentifier: "ShowDetail", sender: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if collectionView == resultCollectionView {
            if indexPath.row == self.shoppingArray.count-1, !isLoading {
                self.resultCount = 0
                self.isLoading = true
                self.reloadMoreData()
                
                self.moreCount += 1
            }
        } else {
            
        }
    }
}

extension SearchResultViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.text!.count > 0 {
            pushSearchFindString(text: textField.text!, parameters: nil, type: .resultCollectionView)
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
        self.pushSearchFindString(text: findString!, parameters: nil, type: .resultCollectionView)
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
        self.pushSearchFindString(text: self.shopping.recentFind.first!, parameters: ["sort":type.rawValue], type: .resultCollectionView)
        self.animateFilterView(isFilterShow: true)
    }
}
