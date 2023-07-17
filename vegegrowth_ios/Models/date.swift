//
//  date.swift
//  vegegrowth_ios
//
//  Created by toui on 2023/06/02.
//

import Foundation

class DateClass {
    private let dateFormatter = DateFormatter()
    private let calendar = Calendar.current
    
    init() {
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "y/MMM/d H", options: 0, locale: Locale(identifier: "ja_JP"))
    }
    // 呼び出した時点の日本時間を返す
    func getDate() -> String {
        // 日付の取得(UTC)
        let date = Date()
        
        return dateFormatter.string(from: date)
    }
    
    // 日付の差分を求める
    func diffDate(firstDateText: String, secondDateText: String) -> Int {
        // 文字列を日付データに変換する
        // 変換できなかったら-1を返す -> -1でいいのか？
        guard let firstDate = dateFormatter.date(from: firstDateText), let secondDate = dateFormatter.date(from: secondDateText) else {
            return -1
        }
        
        let firstDateComponents = calendar.dateComponents([.year, .month, .day], from: firstDate)
        let secondDateComponents = calendar.dateComponents([.year, .month, .day], from: secondDate)
        
        guard var diffDays: Int = calendar.dateComponents([.day], from: firstDateComponents, to: secondDateComponents).day else {
            return -1
        }
        
        // 絶対値に変更して1始まりにする
        diffDays = abs(diffDays) + 1
        
        return diffDays
    }
}
