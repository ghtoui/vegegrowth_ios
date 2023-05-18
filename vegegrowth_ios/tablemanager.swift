//
//  tablemanager.swift
//  vegegrowth_ios
//
//  Created by toui on 2023/05/18.
//

import Foundation
var vege_list :[String] = []

class TablemanagerClass {
    private var vegemanager = VegemanagerClass()
    
    func add_vege(vege_text: String) {
        vege_list.append(vege_text)
        vegemanager.add_vege_id(vege_text: vege_text)
    }
    
    func update_vege_list() {
        if UserDefaults.standard.object(forKey: "vege_list") != nil {
            vege_list = UserDefaults.standard.object(forKey: "vege_list") as! [String]
        }
    }
    
}
