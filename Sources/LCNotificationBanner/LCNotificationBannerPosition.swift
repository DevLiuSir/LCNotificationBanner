//
//  LCNotificationBannerPosition.swift
//  LCNotificationBanner
//
//  Created by DevLiuSir on 2021/6/24.
//

import Cocoa


/// `ProgressHUD`在视图中的位置
public enum LCNotificationBannerPosition {
    /// 将 `ProgressHUD` 从顶部滑入
    case top
    
    /// 将 `ProgressHUD` 从底部滑入
    case bottom
    
    /// 将 `ProgressHUD` 从左侧滑入
    case leftCenter
    
    /// 将 `ProgressHUD` 从右侧滑入
    case rightCenter
}
