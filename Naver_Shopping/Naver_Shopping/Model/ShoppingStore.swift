//
//  ShoppingStore.swift
//  Naver_Shopping
//
//  Created by Oh Sangho on 28/03/2019.
//  Copyright © 2019 Oh Sangho. All rights reserved.
//

import UIKit

class ShoppingStore {
    
    // 최근 검색어 배열.
    var recentFind = [String]()
    
    // URLSession config...
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        let clientHeader = ["X-Naver-Client-Id":"ZJBhjtwMufVosEBkwyUl",
                            "X-Naver-Client-Secret":"nfNZee6AVa"]
        config.httpAdditionalHeaders = clientHeader
        return URLSession(configuration: config)
    }()
    
    // Naver에 쇼핑 데이터를 요청하는 메소드...
    // 데이터 호출 클로져 처리...
    func fetchShoppingData(findString: String, parameters: [String:String]?, completion: @escaping (ShoppingResult) -> Void) {
        
        let url = NaverAPI.getShoppingURL(query: findString, parameters: parameters)
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) {
            (data, response, error) in
            print(request.allHTTPHeaderFields)
            let result = self.processShoppingRequest(data: data, error: error)
            
            print("Shopping response: \(response)")
            completion(result)
            
        }
        task.resume()
    }
    
    // json data에 대한 방어 코드...
    func processShoppingRequest(data: Data?, error: Error?) -> ShoppingResult {
        guard let jsonData = data else {
            return .Failure(error!)
        }
        return NaverAPI.shoppingsFromJSONData(data: jsonData)
    }

}
