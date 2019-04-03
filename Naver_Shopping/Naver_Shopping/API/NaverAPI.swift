//
//  NaverAPI.swift
//  Naver_Shopping
//
//  Created by Oh Sangho on 28/03/2019.
//  Copyright © 2019 Oh Sangho. All rights reserved.
//

import Foundation

enum Method: String {
    case Shopping = "search/shop.json"
}

enum ShoppingResult {
    case Success([ShoppingItem]),
    Failure(Error)
}

enum ShoppingError: Error {
    case InvalidJSONData(String)
}

//400    SE01    Incorrect query request (잘못된 쿼리요청입니다.)    검색 API 요청에 오류가 있습니다. 요청 URL, 필수 요청 변수가 정확한지 확인 바랍니다.
//400    SE02    Invalid display value (부적절한 display 값입니다.)    display 요청 변수값이 허용 범위(1~100)인지 확인해 보세요.
//400    SE03    Invalid start value (부적절한 start 값입니다.)    start 요청 변수값이 허용 범위(1~1000)인지 확인해 보세요.
//400    SE04    Invalid sort value (부적절한 sort 값입니다.)    sort 요청 변수 값에 오타가 없는지 확인해 보세요.
//400    SE06    Malformed encoding (잘못된 형식의 인코딩입니다.)    검색어를 UTF-8로 인코딩하세요.
//404    SE05    Invalid search api (존재하지 않는 검색 api 입니다.)    검색 API 대상에 오타가 없는지 확인해 보세요.
//500    SE99    System Error (시스템 에러)    서버 내부 에러가 발생하였습니다. 포럼에 올려주시면 신속히 조치하겠습니다.

struct NaverAPI {
    private static let baseURLString = "https://openapi.naver.com/v1"
    
    private static let dateFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    // get shopping URL
    static func getShoppingURL(query: String, parameters: [String:String]?, type: CollectionViewType?) -> URL {
        
        // URLComponents를 이용해 URL 구성.....
        let url = String(format: "%@/%@", baseURLString, Method.Shopping.rawValue)
        var components = URLComponents(string: url)
        var queryItems = [URLQueryItem]()
        
        let queryParam = URLQueryItem(name: "query", value: query)
        queryItems.append(queryParam)
        
        if type == .categoryCollectionView {
            let displayParam = URLQueryItem(name: "display", value: "6")
            queryItems.append(displayParam)
        } else {
            let displayParam = URLQueryItem(name: "display", value: "36")
            queryItems.append(displayParam)
        }
        
        // 기본 정렬 등록일자 순으로.
        if parameters?.filter({$0.key == "sort"}) == nil {
            let sortParam = URLQueryItem(name: "sort", value: "date")
            queryItems.append(sortParam)
        }
        
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components?.queryItems = queryItems
        
        return components!.url!
    }
    
    static func shoppingsFromJSONData(data: Data) -> ShoppingResult {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as AnyObject
            
            guard let jsonDictionary = jsonObject as? [String: AnyObject] else {
                    // 일치하는 데이터 구조가가 없음...
                return .Failure(ShoppingError.InvalidJSONData as! Error)
            }
            
            if let errorMessage = jsonDictionary["errorMessage"] as? [String:AnyObject] {
                let error = errorMessage["errorMessage"] as! String
                print("Naver API Error : \(error))")
            }
            
            guard let shoppingArray = jsonDictionary["items"] as? [AnyObject] else {
                let error = jsonDictionary["errorMessage"] as! String
                return .Failure(ShoppingError.InvalidJSONData(error))
            }
            
            var finalShoppings = [ShoppingItem]()
            for item in shoppingArray {
                if let shopping = shoppingFromJSONObject(json: item as! [String : AnyObject]) {
                    finalShoppings.append(shopping)
                }
            }
            
            if finalShoppings.count == 0 {
                return .Failure(ShoppingError.InvalidJSONData as! Error)
            }
            
            return .Success(finalShoppings)
        } catch let error {
            return .Failure(error)
        }
    }
    
    // json 데이터 파싱하여 쇼핑 객체 생성하는 메소드...
    private static func shoppingFromJSONObject(json: [String: AnyObject]) -> ShoppingItem? {
        
        guard let image = json["image"] as? String,
        let hprice = json["hprice"] as? String,
        let lprice = json["lprice"] as? String,
        let title = json["title"] as? String,
        let link = json["link"] as? String,
        let productType = json["productType"] as? String,
        let productId = json["productId"] as? String,
            let mallName = json["mallName"] as? String else {
                // json의 데이터에 nil이 포함되면 return...
                return nil
        }
        
        // shopping 객체 생성..
        let shopping = ShoppingItem(title: title, link: link, image: image, lprice: lprice, hprice: hprice, mallName: mallName, productId: productId, productType: productType)
        
        return shopping
    }
    
}
