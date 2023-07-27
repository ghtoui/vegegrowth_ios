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
    
    // データをサーバーに送る
    public func _sendData(model: BrowseData, imgList: [UIImage?]) -> Observable<Bool> {
        
        // 送るURL
        let urlText: String = API.getTestURL() + "api/send_data"
        let url = URL(string: urlText)!
        
        var request = URLRequest(url: url)
        
        // POSTで通信
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        let contentType = "multipart/form-data; boundary=\(boundary)"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        var httpBody = Data()

        for (index, img) in imgList.enumerated() {
            if let imgData = img?.jpegData(compressionQuality: 1) {
                let imgFieldName = "img\(index)"
                httpBody.append("--\(boundary)\r\n".data(using: .utf8)!)
                httpBody.append("Content-Disposition: form-data; name=\"\(imgFieldName)\"; filename=\"\(imgFieldName).jpg\"\r\n".data(using: .utf8)!)
                httpBody.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                httpBody.append(imgData)
                httpBody.append("\r\n".data(using: .utf8)!)
            }
        }
        let usernameFieldName = "name"
        httpBody.append("--\(boundary)\r\n".data(using: .utf8)!)
        httpBody.append("Content-Disposition: form-data; name=\"\(usernameFieldName)\"\r\n\r\n".data(using: .utf8)!)
        httpBody.append("\(model.name)\r\n".data(using: .utf8)!)

        httpBody.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = httpBody
        
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
    var base64EncodedImage: [String?]
}
