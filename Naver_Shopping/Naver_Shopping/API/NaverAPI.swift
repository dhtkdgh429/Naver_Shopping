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
    case InvalidJSONData
}

struct NaverAPI {
    private static let baseURLString = "https://openapi.naver.com/v1"
    
    private static let dateFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    // get shopping URL
    static func getShoppingURL(query: String, parameters: [String:String]?) -> URL {
        
        // URLComponents를 이용해 URL 구성.....
        let url = String(format: "%@/%@", baseURLString, Method.Shopping.rawValue)
        var components = URLComponents(string: url)
        var queryItems = [URLQueryItem]()
        
        let queryParam = URLQueryItem(name: "query", value: query)
        queryItems.append(queryParam)
        let displayParam = URLQueryItem(name: "display", value: "36")
        queryItems.append(displayParam)
        
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
                    return .Failure(ShoppingError.InvalidJSONData)
            }
            
            let shoppingArray = jsonDictionary["items"] as! [AnyObject]
            
            var finalShoppings = [ShoppingItem]()
            for item in shoppingArray {
                if let shopping = shoppingFromJSONObject(json: item as! [String : AnyObject]) {
                    finalShoppings.append(shopping)
                }
            }
            
            if finalShoppings.count == 0 {
                return .Failure(ShoppingError.InvalidJSONData)
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
    
    
//    ▿ 8 elements
//    ▿ 0 : 2 elements
//    - key : "image"
//    - value : https://shopping-phinf.pstatic.net/main_1766838/17668386531.20190223184034.jpg
//    ▿ 1 : 2 elements
//    - key : "hprice"
//    - value : 179000
//    ▿ 2 : 2 elements
//    - key : "lprice"
//    - value : 123510
//    ▿ 3 : 2 elements
//    - key : "title"
//    - value : 지컷 백셔링 쿨 트렌치 7259216001
//    ▿ 4 : 2 elements
//    - key : "link"
//    - value : https://search.shopping.naver.com/gate.nhn?id=17668386531
//    ▿ 5 : 2 elements
//    - key : "productType"
//    - value : 1
//    ▿ 6 : 2 elements
//    - key : "productId"
//    - value : 17668386531
//    ▿ 7 : 2 elements
//    - key : "mallName"
//    - value : 네이버
    
}
