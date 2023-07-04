//
//  CustomButton.swift
//  vegegrowth_ios
//
//  Created by toui on 2023/07/01.
//

import Foundation
import UIKit

class CustomButton: UIButton {
    // @IBInspectable のアノテーションを設定することでカスタムプロパティを追加することができる
    
    // 枠線の色
    @IBInspectable var borderColor: UIColor = UIColor.clear
    // 枠線の太さ
    @IBInspectable var borderWidth: CGFloat = 0.0
    // 枠線の角丸
    @IBInspectable var cornerRadius: CGFloat = 0.0
    
//    // 文字の縁取り色
//    @IBInspectable var textStrokeColor: UIColor = UIColor.clear
//    // 文字の縁取り幅
//    @IBInspectable var textStrokeWidth: CGFloat = 0.0
    
    override func draw(_ rect: CGRect) {
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        
        super.draw(rect)
    }
}
