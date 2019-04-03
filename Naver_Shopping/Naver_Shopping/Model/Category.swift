//
//  Category.swift
//  Naver_Shopping
//
//  Created by Oh Sangho on 03/04/2019.
//  Copyright © 2019 Oh Sangho. All rights reserved.
//

import UIKit

struct Category {
    
    var categoryTitle: String?
    var categoryArray: [String]?
    
    init(categoryTitle: String) {
        if categoryTitle == "아우터" {
            categoryArray = ["코트", "패딩", "자켓", "가디건", "야상", "점퍼", "베스트", "커플 아우터"]
        } else if categoryTitle == "상의" {
            categoryArray = ["니트", "맨투맨", "후드", "셔츠", "남방", "티셔츠", "블라우스", "민소매", "나시", "커플 상의"]
        } else if categoryTitle == "바지" {
            categoryArray = ["일자바지", "슬랙스팬츠", "스키니팬츠", "레깅스", "크롭팬츠", "부츠컷팬츠", "반바지", "배기팬츠"]
        } else if categoryTitle == "스커트" {
            categoryArray = ["미니스커트", "미디스커트", "롱스커트"]
        } else if categoryTitle == "원피스" {
            categoryArray = ["미니원피스", "미디원피스", "롱원피스", "투피스", "점프수트", "시밀러룩"]
        } else if categoryTitle == "가방" {
            categoryArray = ["숄더백", "크로스백", "토드백", "클러치", "미니백", "백팩", "파우치", "지갑", "에코백"]
        } else if categoryTitle == "슈즈" {
            categoryArray = ["단화", "부츠", "워커", "운동화", "힐", "샌들", "슬리퍼", "쪼리", "웨딩슈즈"]
        } else if categoryTitle == "트레이닝" {
            categoryArray = ["트레이닝 상의", "트레이닝 하의", "트레이닝 세트"]
        }
    }
}
