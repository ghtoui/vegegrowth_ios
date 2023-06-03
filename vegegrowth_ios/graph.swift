//
//  graph.swift
//  vegegrowth_ios
//
//  Created by toui on 2023/06/01.
//

import Foundation
import Charts

class GraphClass {
    private var vege_id : String
    private var vege_length_list : [VegeLengthObject]!
    private var date_class : DateClass = DateClass()
    
    init(vege_id: String) {
        self.vege_id = vege_id
        vege_length_list = []
    }
    
    // 野菜の大きさ管理のリストに追加する
    func add_vege_length(length: Double) {
        let date = date_class.get_date()
        vege_length_list = get_usergraph_list()
        vege_length_list.append(VegeLengthObject(date: date,
                                                 vege_length: length,
                                                 x: Double(vege_length_list.count)))
        set_usergraph_list()
    }
    
    // 野菜の長さのリストをユーザーデフォルトに保存
    func set_usergraph_list() {
        var vegelengthobject_list: [[String: Any]] = []
        for item in vege_length_list {
            let vegelengthobject: [String: Any] = [
                "date": item.date,
                "vege_length": item.vege_length,
                "x": item.x
            ]
            vegelengthobject_list.append(vegelengthobject)
        }
        let vege_length_id = get_vegelength_id()
        UserDefaults.standard.set(vegelengthobject_list, forKey: vege_length_id)
    }
    
    // ユーザーデフォルトから野菜の長さのリストを取得
    func get_usergraph_list() -> [VegeLengthObject] {
        var vegelengthobject_list: [[String: Any]]!
        var vege_length_list: [VegeLengthObject] = []
        let vege_length_id = get_vegelength_id()
        if UserDefaults.standard.object(forKey: vege_length_id) != nil {
            vegelengthobject_list = UserDefaults.standard.object(forKey: vege_length_id) as? [[String: Any]]
        } else {
            return []
        }
        for item in vegelengthobject_list {
            guard let date = item["date"] as? String,
                  let vege_length = item["vege_length"] as? Double,
                  let x = item["x"] as? Double else {
                continue
            }
            let vegelengthobject = VegeLengthObject(date: date,
                                                    vege_length: vege_length,
                                                    x: x)
            vege_length_list.append(vegelengthobject)
        }
        return vege_length_list
    }
    
    // 野菜の大きさにアクセスするためのIDを生成
    private func get_vegelength_id() -> String {
        let vege_length_id = vege_id + "_lengthlist"
        return vege_length_id
    }
}

// 記録日付と野菜の大きさをセットで保持する
// date: 日付
// vege_length: 野菜の大きさ
// x: 何個目か
struct VegeLengthObject {
    var date: String
    var vege_length: Double
    var x: Double
}
