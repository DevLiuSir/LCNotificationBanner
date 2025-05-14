//
//  NSTextField+Extension.swift
//  LCNotificationBanner
//
//  Created by DevLiuSir on 2021/6/24.
//

import Cocoa
 
public extension NSTextField {
    
    /// 计算给定文本在指定字体下所占的渲染尺寸。
    ///
    /// - Parameters:
    ///   - text: 要计算的文本内容。
    ///   - font: 用于渲染文本的字体。
    /// - Returns: 返回该文本在无限宽高限制下所占的实际尺寸。
    func calculateTextSize(text: String, font: NSFont) -> CGSize {
        // 1. 创建字体属性字典
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font
        ]
        
        // 2. 设置计算文本尺寸时的最大限制区域（无限宽高）
        let maxSize = CGSize(width: .greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        
        // 3. 将 String 转为 NSString，以使用 boundingRect 方法
        let nsText = text as NSString
        
        // 4. 计算文本在给定字体和约束下所占的矩形区域
        let boundingRect = nsText.boundingRect(
            with: maxSize,
            options: [.usesLineFragmentOrigin], // 支持多行计算
            attributes: attributes
        )
        
        // 5. 返回实际的尺寸
        return boundingRect.size
    }
}
