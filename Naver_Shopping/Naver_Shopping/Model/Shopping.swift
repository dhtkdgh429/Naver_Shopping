//
//  Shopping.swift
//  Naver_Shopping
//
//  Created by Oh Sangho on 28/03/2019.
//  Copyright © 2019 Oh Sangho. All rights reserved.
//

import UIKit

class ShoppingItem {
    
    var lastBuildDate: Date?
    var total: Int?
    var start: Int?
    var display: Int?
    
    var title: String?
    var link: String?
    var image: String?
    var lprice: String?
    var hprice: String?
    var mallName: String?
    var productId: String?
    var productType: String?
  
    init(title: String, link: String, image: String, lprice: String, hprice: String, mallName: String, productId: String, productType: String) {
        self.title = title
        self.link = link
        self.image = image
        self.lprice = lprice
        self.hprice = hprice
        self.mallName = mallName
        self.productId = productId
        self.productType = productType
    }
}



//필드    타입    설명
//rss    -    디버그를 쉽게 하고 RSS 리더기만으로 이용할 수 있게 하기 위해 만든 RSS 포맷의 컨테이너이며 그 외의 특별한 의미는 없다.
//channel    -    검색 결과를 포함하는 컨테이너이다. 이 안에 있는 title, link, description 등의 항목은 참고용으로 무시해도 무방하다.
//lastBuildDate    datetime    검색 결과를 생성한 시간이다.
//total    integer    검색 결과 문서의 총 개수를 의미한다.
//start    integer    검색 결과 문서 중, 문서의 시작점을 의미한다.
//display    integer    검색된 검색 결과의 개수이다.
//item/items    -    XML 포멧에서는 item 태그로, JSON 포멧에서는 items 속성으로 표현된다. 개별 검색 결과이며 title, link을 포함한다.
//title    string    검색 결과 문서의 제목을 나타낸다. 제목에서 검색어와 일치하는 부분은 태그로 감싸져 있다.
//link    string    검색 결과 문서의 하이퍼텍스트 link를 나타낸다.
//image    string    썸네일 이미지의 URL이다. 이미지가 있는 경우만 나타난다.
//lprice    integer    최저가 정보이다. 최저가 정보가 없는 경우 0으로 표시되며, 가격비교 데이터가 없는 경우 이 필드는 가격을 나타낸다.
//hprice    integer    최고가 정보이다. 최고가 정보가 없거나 가격비교 데이터가 없는 경우 0으로 표시된다.
//mallName    string    상품을 판매하는 쇼핑몰의 상호이다. 정보가 없을 경우 네이버로 표기된다.
//productId    integer    해당 상품에 대한 ID 이다.
//productType    integer    상품군 정보를 일반상품, 중고상품, 단종상품, 판매예정상품으로 구분한다. 상품군의 종류는 다음과 같다.

//상품군 종류 설명 표
//상품군    상품 종류    타입
//일반상품    가격비교 상품    1
//가격비교 비매칭 일반상품    2
//가격비교 매칭 일반상품    3
//중고상품    가격비교 상품    4
//가격비교 비매칭 일반상품    5
//가격비교 매칭 일반상품    6
//단종상품    가격비교 상품    7
//가격비교 비매칭 일반상품    8
//가격비교 매칭 일반상품    9
//판매예정상품    가격비교 상품    10
//가격비교 비매칭 일반상품    11
//가격비교 매칭 일반상품    12
