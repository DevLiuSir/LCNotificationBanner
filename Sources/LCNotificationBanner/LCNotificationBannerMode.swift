//
//  LCNotificationBannerMode.swift
//  LCNotificationBanner
//
//  Created by DevLiuSir on 2021/6/24.
//

import Cocoa

/// 通知横幅的样式
public enum LCNotificationBannerMode {
    
    /// 显示`信息图标`和`状态消息文本`
    case info(view: NSView)
    
    /// 显示`成功图标`和`状态消息文本`
    case success(view: NSView)
    
    /// 显示`错误图标`和`状态消息文本`
    case error(view: NSView)
    
    /// 显示`警告图标`和`状态消息文本`
    case warning(view: NSView)
    
    /// 仅显示`状态消息文本`
    case text
    
    /// 显示`自定义视图`和`状态消息文本`
    case custom(view: NSView)
    
    
    /// 为 `需要视图` 的情况提供匹配方法
    func with(view: NSView) -> LCNotificationBannerMode {
        switch self {
        case .success:
            return .success(view: view)
        case .error:
            return .error(view: view)
        case .info:
            return .info(view: view)
        case .warning:
            return .warning(view: view)
        case .custom:
            return .custom(view: view)
        default:
            return self
        }
    }
}
