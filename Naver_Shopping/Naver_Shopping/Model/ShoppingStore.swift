//
//  ShoppingStore.swift
//  Naver_Shopping
//
//  Created by Oh Sangho on 28/03/2019.
//  Copyright © 2019 Oh Sangho. All rights reserved.
//

import UIKit

class ShoppingStore: NSObject {
    
    // 최근 검색어 배열.
    var recentFind = [String]()
    
    func setRecentFindData(findString: String) {
        
        // 중복 제거 검사.
        let mapFind = recentFind.map {$0.lowercased() == findString.lowercased()}
        if let index = mapFind.firstIndex(of: true) {
            recentFind.remove(at: index)
        }
        // 검색어 첫번째에 추가.
        recentFind.insert(findString, at: 0)
        
        // 10개 제한 조건.
        // for문 돌리는 이유는 혹시라도 11개 이상이 될지 모르니...
        if recentFind.count > 10 {
            for index in 10..<recentFind.count {
                recentFind.remove(at: index)
            }
        }
    }
    
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


// MARK: - UITableViewDataSource
// 쇼핑 최근 검색어 데이터 소스
extension ShoppingStore : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recentFind.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "RecentFindTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! RecentFindTableViewCell
        cell.selectionStyle = .none
        
        let item = self.recentFind[indexPath.row]
        cell.setLabel(index: indexPath.row+1, item: item)
        
        return cell
    }
    
}
