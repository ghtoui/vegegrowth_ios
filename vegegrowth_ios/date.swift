//
//  date.swift
//  vegegrowth_ios
//
//  Created by toui on 2023/06/02.
//

import Foundation

class DateClass {
    // 呼び出した時点の日本時間を返す
    func get_date() -> String {
        // 日付の取得(UTC)
        let date = Date()
        let date_formatter = DateFormatter()
        
        date_formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMdHms",
                                                             options: 0, locale: Locale(identifier: "ja_JP"))
        
        return date_formatter.string(from: date)
    }
}
