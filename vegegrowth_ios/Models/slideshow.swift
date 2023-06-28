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
    private var vegeId: String
    private var currentIndex : Int = 0
    private var img: ImgClass!
    private var imgFileURLList : [URL] = []
    
    init(vegeId: String) {
        self.vegeId = vegeId
        self.img = ImgClass(vegeId: vegeId)
        imgFileURLList = getImgURLList()
    }
    
    func getImgURLList() -> [URL] {
        var imgFileList : [URL] = []
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory,                           in: .userDomainMask).first else {
            return []
        }
        
        do {
            let fileURLList = try FileManager.default.contentsOfDirectory(at: documentDirectory,includingPropertiesForKeys: nil)
            for fileName in img.getVegeTextList(vegeId: vegeId) {
                if let fileImgURL = fileURLList.first(where: { $0.lastPathComponent == fileName }) {
                    imgFileList.append(fileImgURL)
                }
            }
            return imgFileList
        } catch {
            return []
        }
    }
    
    func getCurrentIndex() -> Int {
        return currentIndex
    }
    
    
    func getShowImg() -> UIImage? {
        guard currentIndex >= 0 && currentIndex < imgFileURLList.count else {
            return nil
        }
        
        let fileURL = imgFileURLList[currentIndex]
        do {
            let imgData = try Data(contentsOf: fileURL)
            let img = img.fixRotate(img: UIImage(data: imgData)!)
            return img
        } catch {
            return nil
        }
    }
    
    func showNextImg() {
        guard !imgFileURLList.isEmpty else {
            return
        }
        if (currentIndex == imgFileURLList.count - 1) {
            currentIndex = 0
        } else {
            currentIndex += 1
        }
        
        if (imgFileURLList.count == 0) {
            currentIndex = 0
        }
    }
    
    func showPrevImg() {
        guard !imgFileURLList.isEmpty else {
            return
        }
        if (currentIndex == 0) {
            currentIndex = imgFileURLList.count - 1
        } else {
            currentIndex -= 1
        }
    }
}
