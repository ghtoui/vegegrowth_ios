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
        let urlText: String = API.getTestURL() + "api/data"
        let url = URL(string: urlText)!
        
        let request = URLRequest(url: url)
        return URLSession.shared.rx.data(request: request)
            .map { data -> [BrowseData] in
                // レスポンスデータを変換
                let decoder = JSONDecoder()
                let browseData = try decoder.decode([BrowseData].self, from: data)
                return browseData
            }
    }
    
    // データをサーバーに送る
    public func sendData(model: BrowseData) -> Observable<Bool> {
        // 送るURL
        let urlText: String = API.getTestURL() + "api/send_data"
        let url = URL(string: urlText)!
        
        var request = URLRequest(url: url)
        
        // POSTで通信
        request.httpMethod = "POST"

        // 送信するデータをJSONデータに変換
        let encoder = JSONEncoder()
        guard let jsonData = try? encoder.encode(model) else {
            fatalError("Failed to encode to JSON.")
        }
        
        // 送信するデータ
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return URLSession.shared.rx.response(request: request)
            .map { response, _ in
                // レスポンスのステータスコードが200番台なら成功とみなす
                return 200...299 ~= response.statusCode
            }
            .catchAndReturn(false)
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
