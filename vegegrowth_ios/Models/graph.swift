//
//  graph.swift
//  vegegrowth_ios
//
//  Created by toui on 2023/06/01.
//

import Foundation
import Charts

class GraphClass {
    private var vegeId : String
    private var vegeLengthList : [VegeLengthObject]!
    private var dateClass : DateClass = DateClass()
    
    init(vegeId: String) {
        self.vegeId = vegeId
        vegeLengthList = []
    }
    
    // 野菜の大きさ管理のリストに追加する
    func addVegeLength(length: Double) {
        let date = dateClass.get_date()
        vegeLengthList = getUserGraphList()
        vegeLengthList.append(VegeLengthObject(date: date,
                                                 vegeLength: length,
                                                 x: Double(vegeLengthList.count)))
        setUserGraphList()
    }
    
    // 野菜の長さのリストをユーザーデフォルトに保存
    func setUserGraphList() {
        var vegeLengthObjectList: [[String: Any]] = []
        for item in vegeLengthList {
            let vegeLengthObject: [String: Any] = [
                "date": item.date,
                "vegeLength": item.vegeLength,
                "x": item.x
            ]
            vegeLengthObjectList.append(vegeLengthObject)
        }
        let vegeLengthId = getVegeLengthList()
        UserDefaults.standard.set(vegeLengthObjectList, forKey: vegeLengthId)
    }
    
    // ユーザーデフォルトから野菜の長さのリストを取得
    func getUserGraphList() -> [VegeLengthObject] {
        var vegeLengthObjectList: [[String: Any]]!
        var vegeLengthList: [VegeLengthObject] = []
        let vegeLengthId = getVegeLengthList()
        if UserDefaults.standard.object(forKey: vegeLengthId) != nil {
            vegeLengthObjectList = UserDefaults.standard.object(forKey: vegeLengthId) as? [[String: Any]]
        } else {
            return []
        }
        for item in vegeLengthObjectList {
            guard let date = item["date"] as? String,
                  let vegeLength = item["vegeLength"] as? Double,
                  let x = item["x"] as? Double else {
                continue
            }
            let vegeLengthObject = VegeLengthObject(date: date,
                                                    vegeLength: vegeLength,
                                                    x: x)
            vegeLengthList.append(vegeLengthObject)
        }
        return vegeLengthList
    }
    
    // 野菜の大きさにアクセスするためのIDを生成
    private func getVegeLengthList() -> String {
//        let vegeLengthId = vegeId + "_LengthList"
        let vegeLengthId = vegeId + "_lengthlist"
        return vegeLengthId
    }
}

// 記録日付と野菜の大きさをセットで保持する
// date: 日付
// vege_length: 野菜の大きさ
// x: 何個目か
struct VegeLengthObject {
    var date: String
    var vegeLength: Double
    var x: Double
}
