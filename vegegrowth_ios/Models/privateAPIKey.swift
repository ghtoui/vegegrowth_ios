//
//  privateAPIKey.swift
//  vegegrowth_ios
//
//  Created by toui on 2023/07/15.
//

import Foundation

class APIKeyClass {
    // githubに公開しないほうが良いっぽいので別に作る
    private var url = "http://127.0.0.1:5001/api/data"
    
    public func getURL() -> String {
        return url
    }
}
