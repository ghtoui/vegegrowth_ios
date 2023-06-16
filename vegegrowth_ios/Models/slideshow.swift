//
//  slideshow.swift
//  vegegrowth_ios
//
//  Created by toui on 2023/05/18.
//

import Foundation
import class UIKit.UIImage

// スライドショーを行うクラス
class SlideshowClass {
    private var vege_id: String
    private var current_index : Int = 0
    private var img_class : ImgClass
    private var imgfileurl_list : [URL] = []
    
    init(vege_id: String) {
        self.vege_id = vege_id
        self.img_class = ImgClass(vege_id: vege_id)
        set_imgurl_list()
    }
    
    func set_imgurl_list() {
        self.imgfileurl_list = get_imgurl_list()
    }
    
    func get_imgurl_list() -> [URL] {
        var img_file_list : [URL] = []
        guard let document_directry = FileManager.default.urls(for: .documentDirectory,
                                                               in: .userDomainMask).first else {
            return []
        }
        
        do {
            let fileurl_list = try FileManager.default.contentsOfDirectory(at: document_directry,includingPropertiesForKeys: nil)
            for file_name in img_class.get_vege_text_list(vege_id: vege_id) {
                if let fileimg_url = fileurl_list.first(where: { $0.lastPathComponent == file_name }) {
                    img_file_list.append(fileimg_url)
                }
            }
            return img_file_list
        } catch {
            return []
        }
    }
    
    func get_currentindex() -> Int {
        return current_index
    }
    
    
    func get_showimg() -> UIImage? {
        guard current_index >= 0 && current_index < imgfileurl_list.count else {
            return nil
        }
        
        let file_url = imgfileurl_list[current_index]
        do {
            let img_data = try Data(contentsOf: file_url)
            let img = img_class.fix_rotate(img: UIImage(data: img_data)!)
            return img
        } catch {
            return nil
        }
    }
    
    func show_next_img() {
        if (current_index == imgfileurl_list.count - 1) {
            current_index = 0
        } else {
            current_index += 1
        }
    }
    
    func show_prev_img() {
        if (current_index == 0) {
            current_index = imgfileurl_list.count - 1
        } else {
            current_index -= 1
        }
    }
}
