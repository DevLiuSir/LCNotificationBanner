//
//  LCNotificationType.swift
//  LCNotificationBanner
//
//  Created by DevLiuSir on 2021/6/24.
//



import Cocoa

/// 表示通知横幅的类型，用于决定显示的图标和样式。
public enum LCNotificationType {
    
    /// 成功类型通知，通常显示绿色勾号图标。
    case success
    
    /// 错误类型通知，通常显示红色叉号图标。
    case error
    
    /// 信息类型通知，通常显示蓝色感叹号或信息图标。
    case info
}
