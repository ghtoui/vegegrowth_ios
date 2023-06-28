//
//  tablemanager.swift
//  vegegrowth_ios
//
//  Created by toui on 2023/05/18.
//

import Foundation

class TablemanagerClass {
    private var vegeList :[String]!
    private var vegemanager = VegeManagerClass()
    
    init() {
        vegeList = getVegeList()
    }
    public func addVege(vegeText: String) {
        vegeList.append(vegeText)
        vegemanager.addVegeIdDict(vegeText: vegeText)
        setUserVegeList()
    }
    
    public func getVegeList() -> [String] {
        var vegeList: [String] = []
        
        if UserDefaults.standard.object(forKey: "vegeList") != nil {
            vegeList = UserDefaults.standard.object(forKey: "vegeList") as! [String]
        }
        return vegeList
    }
    
    public func setUserVegeList() {
        UserDefaults.standard.set(vegeList, forKey: "vegeList")
//        UserDefaults.standard.set(vegeList, forKey: "vege_list")
    }
    
    public func deleteItem(index: Int) {
        let vegeText: String = vegeList[index]
        vegeList.remove(at: index)
        vegemanager.deleteItem(vegeText: vegeText)
        setUserVegeList()
    }
}
