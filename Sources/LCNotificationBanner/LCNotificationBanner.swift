//
//  LCNotificationBanner.swift
//  LCNotificationBanner
//
//  Created by DevLiuSir on 2021/6/24.
//

import Cocoa


public class LCNotificationBanner: NSView {
    
    // MARK: - 单例访问
    
    /// 用于全局共享配置的单例实例
    public static let shared = LCNotificationBanner()
    
    // MARK: - 配置属性（对外暴露以便设置）
    
    /// 通知横幅显示位置（默认顶部）
    public var position: LCNotificationBannerPosition = .top
    /// 横幅背景颜色（默认系统蓝）
    public var bgColor: CGColor = NSColor.systemBlue.cgColor
    /// 图标大小
    public var iconSize: CGFloat = 20
    /// 标题字体大小
    public var titleFontSize: CGFloat = 16
    
    // MARK: - 样式控制
    
    /// 样式（默认自动，内部使用）
    private var style: LCNotificationBannerStyle = .auto
    
    // MARK: - 当前展示中的横幅（内部控制）
    
    /// 当前正在展示的通知横幅实例，便于在显示新横幅时隐藏旧横幅
    private static var currentBanner: LCNotificationBanner?
    /// 图标
    private let iconImageView = NSImageView()
    /// 主题
    private let titleLabel = NSTextField(labelWithString: "")
    /// 内容
    private let messageLabel = NSTextField(labelWithString: "")
    
    /// 横幅的高度
    private var bannerHeight: CGFloat = 0 {
        didSet {
            let cornerRadius = bannerHeight / 2.25
            wantsLayer = true
            layer?.backgroundColor = bgColor
            layer?.cornerRadius = cornerRadius
        }
    }
    
    /// 水平间距
    private let horizontalPadding: CGFloat = 20
    
    /// 垂直间距
    private let verticalPadding: CGFloat = 10
    
    /// 图标和文字之间间距
    private let spacingBetweenIconAndText: CGFloat = 10
    
    /// 标题和内容之间垂直间距
    private let titleMessageSpacing: CGFloat = 4
    
    /// 父窗口，用于将横幅添加到对应的内容视图中
    private var parentWindow: NSWindow?
    
    /// 延迟隐藏任务，用于自动在一段时间后隐藏横幅
    private var hideWorkItem: DispatchWorkItem?
    
    
    /// 私有构造器，用于单例模式初始化（shared）
    private override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    /// 禁止从 storyboard/xib 解码使用此视图（强制只允许代码初始化）
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// 自定义初始化方法，用于创建并配置横幅视图
    ///
    /// - Parameters:
    ///   - parentWindow: 横幅挂载的窗口
    ///   - icon: 可选图标图像
    ///   - title: 标题文本
    ///   - message: 可选的附加消息
    private init(parentWindow: NSWindow, icon: NSImage?, title: String, message: String? = nil) {
        super.init(frame: .zero)
        
        self.iconSize = LCNotificationBanner.shared.iconSize
        self.titleFontSize = LCNotificationBanner.shared.titleFontSize
        self.bgColor = LCNotificationBanner.shared.bgColor
        self.position = LCNotificationBanner.shared.position
        
        self.parentWindow = parentWindow
        
        configIcon(icon: icon)
        setupTitleLabel(title: title)
        setupMessageLabel(message: message)
        layoutContents()
    }
    
    //MARK: - Private layout & configure
    
    /// 配置图标
    private func configIcon(icon: NSImage?) {
        iconImageView.image = icon
        //iconImageView.image?.isTemplate = true
        iconImageView.imageScaling = .scaleProportionallyUpOrDown
        addSubview(iconImageView)
    }
    /// 配置标题
    private func setupTitleLabel(title: String) {
        titleLabel.stringValue = title
        titleLabel.font = NSFont.boldSystemFont(ofSize: titleFontSize)
        titleLabel.textColor = bgColor == .white ? .black : .white
        titleLabel.wantsLayer = true
        titleLabel.backgroundColor = .orange
        addSubview(titleLabel)
    }
    
    /// 配置内容
    private func setupMessageLabel(message: String? = nil) {
        if let msg = message, !msg.isEmpty {
            messageLabel.stringValue = msg
            messageLabel.font = NSFont.systemFont(ofSize: 13)
            messageLabel.textColor = bgColor == .white ? .black : .white
            messageLabel.wantsLayer = true
            messageLabel.backgroundColor = .red
            addSubview(messageLabel)
        }
    }
    
    /// 布局 Banner 内容
    private func layoutContents() {
        guard let contentView = parentWindow?.contentView else { return }
        
        // 计算标题、消息文本尺寸
        let (titleSize, messageSize) = calculateTextSizes()
        
        // 根据文字尺寸计算整体横幅高度
        calculatorBannerHeight(titleSize: titleSize, messageSize: messageSize)
        
        // 计算 icon 和文本起点 X 坐标
        let textStartX = layoutIconIfNeeded()
        
        // 布局标题与消息 label
        layoutTextLabels(titleSize: titleSize, messageSize: messageSize, textX: textStartX)
        
        // 设置自身 Frame 大小与位置
        layoutBannerFrame(textStartX: textStartX, contentViewWidth: contentView.bounds.width)
    }
    
    /// 计算标题和消息文本的尺寸
    private func calculateTextSizes() -> (CGSize, CGSize) {
        let titleSize = titleLabel.calculateTextSize(text: titleLabel.stringValue, font: titleLabel.font!)
        let messageSize: CGSize
        if messageLabel.stringValue.isEmpty {
            messageSize = .zero
        } else {
            messageSize = titleLabel.calculateTextSize(text: messageLabel.stringValue, font: messageLabel.font!)
        }
        return (titleSize, messageSize)
    }
    
    /// 计算`整体 Banner`的 `高度`（含文字与内边距）
    private func calculatorBannerHeight(titleSize: CGSize, messageSize: CGSize) {
        let hasMessage = !messageLabel.stringValue.isEmpty
        let textHeight = titleSize.height + (hasMessage ? (titleMessageSpacing + messageSize.height) : 0)
        let contentHeight = max(iconSize, textHeight)
        bannerHeight = contentHeight + 2 * verticalPadding
    }
    
    /// 布局图标，如果存在图标，返回文本的起始 X 坐标
    private func layoutIconIfNeeded() -> CGFloat {
        let hasIcon = iconImageView.image != nil
        let iconX = horizontalPadding
        if hasIcon {
            let iconY = (bannerHeight - iconSize) / 2
            iconImageView.frame = CGRect(x: iconX, y: iconY, width: iconSize, height: iconSize)
            return iconX + iconSize + spacingBetweenIconAndText
        } else {
            iconImageView.removeFromSuperview()
            return horizontalPadding
        }
    }
    
    
    /// 布局标题和消息文本
    private func layoutTextLabels(titleSize: CGSize, messageSize: CGSize, textX: CGFloat) {
        let hasMessage = !messageLabel.stringValue.isEmpty
        let textHeight = titleSize.height + (hasMessage ? (titleMessageSpacing + messageSize.height) : 0)
        let textY = (bannerHeight - textHeight) / 2
        
        titleLabel.frame = CGRect(
            x: textX,
            y: textY + (hasMessage ? (messageSize.height + titleMessageSpacing) : 0),
            width: max(titleSize.width + 5, messageSize.width),
            height: titleSize.height
        )
        
        if hasMessage {
            messageLabel.frame = CGRect(x: textX, y: textY, width: messageSize.width + 5, height: messageSize.height)
        }
    }
    
    
    /// 设置 Banner 自身的位置和大小
    private func layoutBannerFrame(textStartX: CGFloat, contentViewWidth: CGFloat) {
        let textWidth = max(titleLabel.frame.width, messageLabel.frame.width)
        let totalWidth = textStartX + textWidth + horizontalPadding
        let bannerWidth = min(totalWidth, contentViewWidth - 40)
        
        self.frame = CGRect(
            x: (contentViewWidth - bannerWidth) / 2,
            y: parentWindow?.contentView?.frame.height ?? 0,
            width: bannerWidth,
            height: bannerHeight
        )
    }
    
    
    // MARK: - Public Show & Hide methods
    
    /// 显示`成功状态`信息
    public class func showSuccessWithStatus(_ status: String, style: LCNotificationBannerStyle = .auto, to window: NSWindow?) {
        LCNotificationBanner.shared.parentWindow = window
        showStatus(status, type: .success, style: style)
    }
    /// 显示`错误状态`信息
    public class func showErrorWithStatus(_ status: String, style: LCNotificationBannerStyle = .auto, to window: NSWindow?) {
        LCNotificationBanner.shared.parentWindow = window
        showStatus(status, type: .error, style: style)
    }
    /// 显示`提示状态`信息
    public class func showInfoWithStatus(_ status: String, style: LCNotificationBannerStyle = .auto, to window: NSWindow?) {
        LCNotificationBanner.shared.parentWindow = window
        showStatus(status, type: .info, style: style)
    }
    
    /// 显示`警告状态`信息
    public class func showWarningWithStatus(_ status: String, style: LCNotificationBannerStyle = .auto, to window: NSWindow?) {
        LCNotificationBanner.shared.parentWindow = window
        showStatus(status, type: .warning, style: style)
    }
    
    /// 只显示`文本信息`的方法
    ///
    /// - Parameter status: 显示的纯文本内容
    public class func showTextWithStatus(_ status: String, to window: NSWindow?) {
        guard let window = window else { return }
        // 不提供图标
        let banner = LCNotificationBanner(parentWindow: window, icon: nil, title: status)
        banner.show()
    }
    
    
    
    // MARK: - Private Show & Hide methods
    
    /// 显示
    private func show() {
        guard let contentView = parentWindow?.contentView else { return }
        
        // 隐藏旧的
        LCNotificationBanner.currentBanner?.hide()
        LCNotificationBanner.currentBanner = self
        
        // 布局子控件
        layoutContents()
        
        contentView.addSubview(self)
        
        // 初始 frame（隐藏状态）
        var startFrame = self.frame
        let endFrame: CGRect
        
        switch position {
        case .top:
            startFrame.origin.y = contentView.frame.height
            endFrame = CGRect(x: startFrame.origin.x,
                              y: contentView.frame.height - bannerHeight - 20,
                              width: startFrame.width,
                              height: startFrame.height)
            
        case .bottom:
            startFrame.origin.y = -bannerHeight
            endFrame = CGRect(x: startFrame.origin.x, y: 20,
                              width: startFrame.width, height: startFrame.height)
            
        case .leftCenter:
            startFrame.origin.x = -startFrame.width
            startFrame.origin.y = (contentView.frame.height - bannerHeight) / 2
            endFrame = CGRect(x: (contentView.frame.width - startFrame.width) / 2,
                              y: startFrame.origin.y,
                              width: startFrame.width,
                              height: startFrame.height)
            
        case .rightCenter:
            startFrame.origin.x = contentView.frame.width
            startFrame.origin.y = (contentView.frame.height - bannerHeight) / 2
            endFrame = CGRect(x: (contentView.frame.width - startFrame.width) / 2,
                              y: startFrame.origin.y,
                              width: startFrame.width,
                              height: startFrame.height)
        }
        
        
        self.frame = startFrame
        
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.3
            self.animator().frame = endFrame
        }
        
        hideWorkItem?.cancel()
        hideWorkItem = DispatchWorkItem { [weak self] in self?.hide() }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: hideWorkItem!)
    }
    
    /// 隐藏
    private func hide() {
        guard let contentView = parentWindow?.contentView else { return }
        var targetFrame = self.frame
        switch position {
        case .top:
            targetFrame.origin.y = contentView.frame.height
        case .bottom:
            targetFrame.origin.y = -bannerHeight
        case .leftCenter:
            targetFrame.origin.x = -self.frame.width
        case .rightCenter:
            targetFrame.origin.x = contentView.frame.width
        }
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.3
            self.animator().frame = targetFrame
        }, completionHandler: {
            self.removeFromSuperview()
        })
    }
    
    
    /// 显示带有图标和状态文本的通知横幅
    ///
    /// - Parameters:
    ///   - status: 要显示的状态文本，例如“成功”、“失败”或“信息提示”
    ///   - type: 通知的类型，影响图标和语义（如 `.success` / `.error` / `.info`）
    ///   - style: 图标风格，默认为 `.auto`，可根据当前主题自动适配（浅色/深色）或自定义
    private class func showStatus(_ status: String, type: LCNotificationType, style: LCNotificationBannerStyle = .auto) {
        // 获取当前用于显示通知的窗口
        guard let window = LCNotificationBanner.shared.parentWindow else { return }
        
        // 根据通知类型构建对应的图标模式（此处 view 是占位的，为了与 .success/.error/.info 枚举匹配）
        let mode: LCNotificationBannerMode
        switch type {
        case .success:
            mode = .success(view: NSView())
        case .error:
            mode = .error(view: NSView())
        case .info:
            mode = .info(view: NSView())
        case .warning:
            mode = .warning(view: NSView())
        }
        
        // 获取对应图标图像，考虑当前风格（自动、浅色、深色）
        guard let icon = imageForStatus(mode, style: style) else { return }
        
        // 构建通知横幅视图，传入必要参数
        let banner = LCNotificationBanner(parentWindow: window, icon: icon, title: status)
        banner.show()
    }
    
    
    // MARK: - 获取 Bundle 里面的图片
    
    /// 获取对应的状态图标
    ///
    /// - Parameters:
    ///   - type: HUD 的状态类型（成功/错误）
    ///   - style: 当前 HUD 样式
    /// - Returns: 对应的 NSImage
    private class func imageForStatus(_ type: LCNotificationBannerMode, style: LCNotificationBannerStyle) -> NSImage? {
        let imageName: String
        switch type {
        case .success:
            if style.isEqual(to: .auto) {
                imageName = NSApp.effectiveAppearance.name == .darkAqua ? "success_white@2x.png" : "success_black@2x.png"
            } else {
                imageName = style.isEqual(to: .dark) ? "success_white@2x.png" : "success_black@2x.png"
            }
        case .error:
            if style.isEqual(to: .auto) {
                imageName = NSApp.effectiveAppearance.name == .darkAqua ? "error_white@2x.png" : "error_black@2x.png"
            } else {
                imageName = style.isEqual(to: .dark) ? "error_white@2x.png" : "error_black@2x.png"
            }
        case .info:
            if style.isEqual(to: .auto) {
                imageName = NSApp.effectiveAppearance.name == .darkAqua ? "info_white@2x.png" : "info_black@2x.png"
            } else {
                imageName = style.isEqual(to: .dark) ? "info_white@2x.png" : "info_black@2x.png"
            }
        case .warning:
            if style.isEqual(to: .auto) {
                imageName = NSApp.effectiveAppearance.name == .darkAqua ? "warning_white@2x.png" : "warning_black@2x.png"
            } else {
                imageName = style.isEqual(to: .dark) ? "warning_white@2x.png" : "warning_black@2x.png"
            }
        default:
            return nil
        }
        return bundleImage(imageName)
    }
    
    /// 从 LCNotificationBanner.bundle 中加载指定名称的图片
    /// 支持 `.bundle` 嵌套在 `.bundle` 的结构（CocoaPods 默认行为）
    /// - Parameter imageName: 图片名称
    /// - Returns: 加载的 NSImage
    private class func bundleImage(_ imageName: String) -> NSImage {
        // 先获取主资源 Bundle
        guard let outerBundleURL = Bundle(for: LCNotificationBanner.self)
            .url(forResource: "LCNotificationBanner", withExtension: "bundle"),
              let outerBundle = Bundle(url: outerBundleURL) else {
            print("❌ 无法加载外层 LCNotificationBanner.bundle")
            return NSImage()
        }
        
        // 再尝试获取内层嵌套的 LCNotificationBanner.bundle（CocoaPods 的行为）
        let nestedBundleURL = outerBundle.url(forResource: "LCNotificationBanner", withExtension: "bundle")
        let finalBundle = nestedBundleURL.flatMap { Bundle(url: $0) } ?? outerBundle
        
        // 加载图片
        guard let imagePath = finalBundle.path(forResource: imageName, ofType: nil),
              let image = NSImage(contentsOfFile: imagePath) else {
            print("❌ 无法找到图片 \(imageName) in \(finalBundle.bundlePath)")
            return NSImage()
        }
        return image
    }
    
    
    
}
