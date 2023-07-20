//
//  browseData.swift
//  vegegrowth_ios
//
//  Created by toui on 2023/07/15.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit.UIImage

class browseClass {
    private let API = APIKeyClass()
    
    public func fetchData() -> Observable<[BrowseData]> {
        // gitHubAPI
        //            let url = URL(string: "https://api.github.com/users/ghtoui/repos")!
        
        // こういうのは、githubに公開しないほうが良いっぽいので、別に作って、とってくるようにする
        let url = URL(string: API.getTestURL() + "api/data")!
        
        let request = URLRequest(url: url)
        return URLSession.shared.rx.data(request: request)
            .map { data -> [BrowseData] in
                // レスポンスデータを変換
                let decoder = JSONDecoder()
                let browseData = try decoder.decode([BrowseData].self, from: data)
                return browseData
            }
    }
    
    public func sendData() -> Observable<Bool> {
        let url = URL(string: API.getTestURL() + "api/send_data")!
        
        let json = ["name": "mori"]
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return URLSession.shared.rx.response(request: request)
            .map { response, _ in
                // レスポンスのステータスコードが200番台なら成功とみなす
                return 200...299 ~= response.statusCode
            }
            .catchErrorJustReturn(false)
    }
}

struct BrowseData: Codable {
    let name: String
    var date: [String]
    var vegeLength: [Double]
    var x: [Double]
    var memoText: [String]
    var base64EncodedImage: [String]
}
