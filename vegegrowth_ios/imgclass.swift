//
//  takeimgclass.swift
//  vegegrouth_ios
//
//  Created by toui on 2023/05/12.
//

import Foundation
import UIKit

var vege_text_list: [String] = []

class ImgClass {
    private var vege_id: String = ""
    
    init(vege_id: String) {
        self.vege_id = vege_id
    }
    
    func take_img(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo
                               info: [UIImagePickerController.InfoKey : Any]) -> UIImage? {
        
        picker.dismiss(animated: true)

        guard let img = info[.originalImage] as? UIImage else {
            print("画像が見つかりませんでした")
            return nil
        }
        // 撮った写真を保存する
        vege_text_list = get_vege_text_list(vege_id: vege_id)
        let num = vege_text_list.count
        let file_name = self.vege_id + "_" + String(num)
        print(file_name)
        save_img(file_name: file_name, img: img)
        vege_text_list.append(file_name)
        UserDefaults.standard.set(vege_text_list, forKey: vege_id)
        vege_text_list = get_vege_text_list(vege_id: vege_id)
        print(vege_text_list)
        
        return img
    }
    
    func get_vege_text_list(vege_id: String) -> [String]{
        if UserDefaults.standard.object(forKey: vege_id) != nil {
            vege_text_list = UserDefaults.standard.object(forKey: vege_id) as! [String]
        }
        return vege_text_list
    }
    
    func get_url(file_name: String) -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let file_url = documentsDirectory.appendingPathComponent(file_name)
        return file_url
    }
    
    func encode_text(text: String) -> String{
        let encoded_text = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return encoded_text!
    }
    
    // 画像を保存
    func save_img(file_name: String, img: UIImage) {
        let file_url = get_url(file_name: file_name)
        if let img_data = img.pngData() {
            do {
                try img_data.write(to: file_url)
                print("\(file_url):に画像を保存しました")
            } catch {
                print("保存できませんでした")
            }
        }
    }
    
    // 画像を読み込む
    func load_img(file_name: String) -> UIImage? {
        let file_url = get_url(file_name: file_name).path
        
        if FileManager.default.fileExists(atPath: file_url) {
            if let img = UIImage(contentsOfFile: file_url) {
                print("\(file_url)は読み込めました")
                return img
            }
        } else {
            print("\(file_url)は読み込めませんでした")
            return nil
        }
        return nil
    }
}
