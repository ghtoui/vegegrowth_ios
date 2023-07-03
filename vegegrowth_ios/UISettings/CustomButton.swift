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
    @IBInspectable var borderColor: UIColor = UIColor.clear // 枠線の色
    @IBInspectable var borderWidth: CGFloat = 0.0 // 枠線の太さ
    @IBInspectable var cornerRadius: CGFloat = 0.0 // 枠線の角丸
    
    override func draw(_ rect: CGRect) {
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        super.draw(rect)
    }
}
