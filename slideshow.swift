//
//  slideshow.swift
//  vegegrowth_ios
//
//  Created by toui on 2023/05/18.
//

import Foundation
import UIKit

// スライドショーを行うクラス
class SlideshowClass {
    private var vege_id: String
    private var imgfileurl_list: [URL] = []
    private var current_index : Int = 0
    
    init(vege_id: String) {
        self.vege_id = vege_id
        self.imgfileurl_list = get_imgurl_list()
    }
    
    func get_imgurl_list() -> [URL] {
        guard let document_directry = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return []
        }
        
        do {
            let fileurl_list = try FileManager.default.contentsOfDirectory(at: document_directry, includingPropertiesForKeys: nil)
            let imgfile_list = fileurl_list.filter { $0.pathExtension.lowercased() == "png" || $0.pathExtension.lowercased() == "jpg" }
            return imgfile_list
        } catch {
            return []
        }
    }
    
    
    func get_showimg() -> UIImage? {
        
        guard current_index >= 0 && current_index < imgfileurl_list.count else {
            return nil
        }
                
        let file_url = imgfileurl_list[current_index]
        do {
            let img_data = try Data(contentsOf: file_url)
            let img = UIImage(data: img_data)
            return img
        } catch {
            return nil
        }
    }
    
    func show_next_img() {
        if (current_index == imgfileurl_list.count) {
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
