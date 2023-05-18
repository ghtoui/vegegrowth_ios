//
//  vegemanager.swift
//  vegegrowth_ios
//
//  Created by toui on 2023/05/18.
//

import Foundation

var vege_id_dict: [String: String] = [:]

class VegemanagerClass {
    
    func unique_id() -> String {
        let uuid = UUID().uuidString
        return uuid
    }
    
    // 追加する名前とユニークIDを紐付ける
    func add_vege_id(vege_text: String) {
        let uuid = unique_id()
        vege_id_dict[vege_text] = uuid
    }
}
