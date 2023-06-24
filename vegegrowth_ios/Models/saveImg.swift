//
//  takeimgclass.swift
//  vegegrouth_ios
//
//  Created by toui on 2023/05/12.
//

import Foundation
import UIKit.UIImage


class ImgClass {
    private var vegeId: String!
    private var fixRotateImg: UIImage!
    private var fileName: String!
    private var vegeTextList: [String]!
    
    // OpenCVがビルドできないので、後から実装
    //private var cv: CvClass = CvClass()
    
    init(vegeId: String) {
        self.vegeId = vegeId
    }
    
    func take_img(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo
                               info: [UIImagePickerController.InfoKey : Any]) -> UIImage?{
        
        picker.dismiss(animated: true)

        guard let img = info[.originalImage] as? UIImage else {
            print("画像が見つかりませんでした")
            return nil
        }
        // 撮った写真を保存する
        vegeTextList = getVegeTextList(vegeId: vegeId)
        let num = vegeTextList.count
        fileName = self.vegeId + "_" + String(num)
        // 画像の回転を直す
        fixRotateImg = fixRotate(img: img)!
        vegeTextList = getVegeTextList(vegeId: vegeId)
        
        // OpenCVがビルドできないので、後から実装
        //let conv_img = cv.convertColor(source: fix_rotateimg)
        
        return fixRotateImg
    }
    
    func getTakeImg() -> UIImage {
        return fixRotateImg
    }
    
    func getFileName() -> String {
        return fileName
    }
    
    // 保存されている画像のファイル名を取得
    func getVegeTextList(vegeId: String) -> [String]{
        if UserDefaults.standard.object(forKey: vegeId) != nil {
            vegeTextList = UserDefaults.standard.object(forKey: vegeId) as? [String]
        } else {
            vegeTextList = []
        }
        return vegeTextList
    }
    
    // 画像のファイル名からURLを生成
    func getImgURL(fileName: String) -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        return fileURL
    }
    
    // 画像を保存
    func saveImg(fileName: String, img: UIImage) {
        let file_url = getImgURL(fileName: fileName)
        if let img_data = img.pngData() {
            do {
                try img_data.write(to: file_url)
                print("\(file_url):に画像を保存しました")
            } catch {
                print("保存できませんでした")
            }
        }
        // ユーザーデフォルトに保存する処理
        vegeTextList.append(fileName)
        UserDefaults.standard.set(vegeTextList, forKey: vegeId)
    }
    
    // 画像を読み込む
    func loadImg(fileName: String) -> UIImage? {
        let imgFileURL = getImgURL(fileName: fileName).path
        
        if FileManager.default.fileExists(atPath: imgFileURL) {
            if let img = UIImage(contentsOfFile: imgFileURL) {
                print("\(imgFileURL)は読み込めました")
                return img
            }
        } else {
            print("\(imgFileURL)は読み込めませんでした")
            return nil
        }
        return nil
    }
    
    // 回転を直す
    func fixRotate(img: UIImage) -> UIImage? {
        guard img.imageOrientation != .up else {
            return img
        }
        
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale)
        img.draw(in: CGRect(origin: .zero, size: img.size))
        let fixedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return fixedImage
    }
}
