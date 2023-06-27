//
//  vegemanager.swift
//  vegegrowth_ios
//
//  Created by toui on 2023/05/18.
//

import Foundation

class VegeManagerClass {
    private var VegeIdDict: [String: String]!
    
    init() {
        VegeIdDict = getVegeIdDict()
    }
    public func uniqueId() -> String {
        let uuid = UUID().uuidString
        return uuid
    }
    
    // 追加する名前とユニークIDを紐付ける
    public func addVegeIdDict(vegeText: String) {
        VegeIdDict = getVegeIdDict()
        let uuid = uniqueId()
        VegeIdDict[vegeText] = uuid
        SetUserVegeIdDict()
    }
    
    public func getVegeIdDict() -> [String: String] {
        VegeIdDict = [: ]
        if UserDefaults.standard.object(forKey: "vegeid_dict") != nil {
            VegeIdDict = (UserDefaults.standard.object(forKey: "vegeid_dict") as! [String: String])
        }
        
        if UserDefaults.standard.object(forKey: "vegeIdDict") != nil {
            VegeIdDict = (UserDefaults.standard.object(forKey: "vegeIdDict") as! [String: String])
        }
        
        return VegeIdDict
    }
    
    public func SetUserVegeIdDict() {
        UserDefaults.standard.set(VegeIdDict, forKey: "vegeIdDict")
//        UserDefaults.standard.set(VegeIdDict, forKey: "vegeid_dict")
    }
    
    public func deleteItem(vegeText: String) {
        VegeIdDict = getVegeIdDict()
        VegeIdDict.removeValue(forKey: vegeText)
    }
}
