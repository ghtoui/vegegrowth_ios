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
    private var vege_length_list : [VegeLengthObject] = []
    private var date_class : DateClass = DateClass()
    
    init(vege_id: String) {
        self.vege_id = vege_id
    }
    
    // 野菜の大きさ管理のリストに追加する
    func add_vege_length(length: Double) {
        let date = date_class.get_date()
        vege_length_list.append(VegeLengthObject(date: date,
                                                 vege_length: length,
                                                 x: Double(vege_length_list.count)))
        set_usergraph_list()
    }
    
    // user_dataから野菜の大きさのオブジェクトリストを取得する
    func get_usergraph_list(vege_id: String) -> [VegeLengthObject] {
        let vege_length_id = vege_id + "_lengthlist"
        if UserDefaults.standard.object(forKey: vege_length_id) != nil {
            vege_length_list = UserDefaults.standard.object(forKey: vege_length_id) as! [VegeLengthObject]
        } else {
            vege_length_list = []
        }
        
        return vege_length_list
    }
    
    // 野菜の長さのリストをユーザーデフォルトに保存
    func set_usergraph_list() {
        let vege_length_id = vege_id + "_lengthlist"
        UserDefaults.standard.set(vege_length_list, forKey: vege_length_id)
    }
}

// 記録日付と野菜の大きさをセットで保持する
struct VegeLengthObject {
    var date: String
    var vege_length: Double
    var x: Double
}
