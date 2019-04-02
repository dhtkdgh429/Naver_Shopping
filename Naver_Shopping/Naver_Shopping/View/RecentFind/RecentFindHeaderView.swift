//
//  RecentFindHeaderView.swift
//  Naver_Shopping
//
//  Created by Oh Sangho on 02/04/2019.
//  Copyright © 2019 Oh Sangho. All rights reserved.
//

import UIKit

protocol RecentFindHeaderViewDelegate {
    func clearRecentFindData()
}

class RecentFindHeaderView: UITableViewHeaderFooterView {

    static let reuseIdentifer = "RecentFindHeaderView"
    let customLabel = UILabel()
    
    let deleteButton = UIButton()
    
    var delegate: RecentFindHeaderViewDelegate?
    
    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        customLabel.font = UIFont.boldSystemFont(ofSize: 14)
        
        customLabel.translatesAutoresizingMaskIntoConstraints = false
        customLabel.text = "최근 검색어"
        self.contentView.addSubview(customLabel)
        self.contentView.backgroundColor = UIColor.white
        
        let margins = contentView.layoutMarginsGuide
        customLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        customLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        customLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        customLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        
        // 삭제 버튼.
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        deleteButton.setTitleColor(UIColor.lightGray, for: .normal)
        deleteButton.setTitle("전체삭제", for: .normal)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(deleteButton)
        
        deleteButton.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        deleteButton.addTarget(self, action: #selector(touchedDeleteButton), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func touchedDeleteButton() {
        if let delegate = self.delegate {
            delegate.clearRecentFindData()
        }
    }
}
