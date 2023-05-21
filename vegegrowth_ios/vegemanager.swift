//
//  vegemanager.swift
//  vegegrowth_ios
//
//  Created by toui on 2023/05/18.
//

import Foundation

var vege_id_dict: [String: String] = [:]

class VegemanagerClass {
    
    init() {
        get_vegeid_dict()
    }
    
    func unique_id() -> String {
        let uuid = UUID().uuidString
        return uuid
    }
    
    // 追加する名前とユニークIDを紐付ける
    func add_vege_id(vege_text: String) {
        let uuid = unique_id()
        vege_id_dict[vege_text] = uuid
        set_uservegeid_dict()
    }
    
    func get_vegeid_dict() {
        if UserDefaults.standard.object(forKey: "vegeid_dict") != nil {
            vege_id_dict = UserDefaults.standard.object(forKey: "vegeid_dict") as! [String: String]
        }
    }
    
    func set_uservegeid_dict() {
        UserDefaults.standard.set(vege_id_dict, forKey: "vegeid_dict")
    }
}
