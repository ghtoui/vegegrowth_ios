//
//  browseData.swift
//  vegegrowth_ios
//
//  Created by toui on 2023/07/15.
//

import Foundation
import RxSwift
import RxCocoa

class browseClass {
    private let API = APIKeyClass()
    
    public func fetchRepositories() -> Observable<[BrowseData]> {
        // gitHubAPI
        //            let url = URL(string: "https://api.github.com/users/ghtoui/repos")!
        
        // こういうのは、githubに公開しないほうが良いっぽいので、別に作って、とってくるようにする
        let url = URL(string: API.getURL())!
        
        let request = URLRequest(url: url)
        return URLSession.shared.rx.data(request: request)
            .map { data -> [BrowseData] in
                // レスポンスデータを変換
                let decoder = JSONDecoder()
                let browseData = try decoder.decode([BrowseData].self, from: data)
                return browseData
            }
    }
}

struct BrowseData: Codable {
    let name: String
    var date: [String]
    var vegeLength: [Double]
    var x: [Double]
    var memoText: [String]
}
