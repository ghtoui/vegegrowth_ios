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
    public func fetchRepositories() -> Observable<[BrowseData]> {
        // gitHubAPI
        //            let url = URL(string: "https://api.github.com/users/ghtoui/repos")!
        let url = URL(string: "http://127.0.0.1:5001/api/data")!
        
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
    //    let description: String
}
