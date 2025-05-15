<p align="center">
<img src="./Design/icon.png" width="200">

<p align="center"> <b>LCNotificationBanner is a lightweight macOS notification banner component!</b></p>

<p align="center">
<img src="https://badgen.net/badge/icon/apple?icon=apple&label">
<img src="https://img.shields.io/badge/language-swift-orange.svg">
<img src="https://img.shields.io/badge/macOS-10.14-blue.svg">
<img src="https://img.shields.io/badge/build-passing-brightgreen">
<img src="https://img.shields.io/github/languages/top/DevLiuSir/LCNotificationBanner?color=blueviolet">
<img src="https://img.shields.io/github/license/DevLiuSir/LCNotificationBanner.svg">
<img src="https://img.shields.io/github/languages/code-size/DevLiuSir/LCNotificationBanner?color=ff69b4&label=codeSize">
<img src="https://img.shields.io/github/repo-size/DevLiuSir/LCNotificationBanner">
<img src="https://img.shields.io/github/last-commit/DevLiuSir/LCNotificationBanner">
<img src="https://img.shields.io/github/commit-activity/m/DevLiuSir/LCNotificationBanner">
<img src="https://img.shields.io/github/stars/DevLiuSir/LCNotificationBanner.svg?style=social&label=Star">
<img src="https://img.shields.io/github/forks/DevLiuSir/LCNotificationBanner?style=social">
<img src="https://img.shields.io/github/watchers/DevLiuSir/LCNotificationBanner?style=social">
<a href="https://twitter.com/LiuChuan_"><img src="https://img.shields.io/twitter/follow/LiuChuan_.svg?style=social"></a>
</p>

---



## Banner display position

- **Using enumerations to define `LCNotificationBannerPosition `** 

```swift
public enum LCNotificationBannerPosition {
    case top
    case bottom
    case leftCenter
    case rightCenter
}
```


## Preview of Notification Animations

| ![](Design/top_success.gif) | ![](Design/top_error.gif) | ![](Design/top_info.gif)|
| :------------: | :------------: | :------------: |
| Success | Error |  Info  |


| ![](Design/top_only_text.gif) | ![](Design/rightCenter.gif) | ![](Design/leftCenter.gif) |  ![](Design/bottom.gif) |
| :------------: | :------------: | :------------: | :------------: |
|  Only Text | rightCenter  | leftCenter | bottom|



## How to use

#### Provide Success, Info, Warning, Error, and Custom banner type

- Background color

```swift
LCNotificationBanner.shared.bgColor = NSColor.systemBlue.cgColor
```

- Position

```swift
LCNotificationBanner.shared.position = .top
```

- Success type

```swift
LCNotificationBanner.showSuccessWithStatus("This is a banner title", style: .dark, to: view.window)
```

- Error type

```swift
LCNotificationBanner.showErrorWithStatus("This is a banner title", style: .dark, to: view.window)
```

- Info type

```swift
LCNotificationBanner.showInfoWithStatus("This is a banner title", style: .dark, to: view.window)
```

- Text type only

```swift
LCNotificationBanner.showTextWithStatus("This is a banner title", to: view.window)
```




## Installation

### CocoaPods
LCNotificationBanner is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your Podfile:


```swift
pod 'LCNotificationBanner'
```



## License

MIT License

Copyright (c) 2024 Marvin


## Author

| [<img src="https://avatars2.githubusercontent.com/u/11488337?s=460&v=4" width="120px;"/>](https://github.com/DevLiuSir)  |  [DevLiuSir](https://github.com/DevLiuSir)<br/><br/><sub>Software Engineer</sub><br/> [<img align="center" src="https://cdn.jsdelivr.net/npm/simple-icons@3.0.1/icons/twitter.svg" height="20" width="20"/>][1] [<img align="center" src="https://cdn.jsdelivr.net/npm/simple-icons@3.0.1/icons/github.svg" height="20" width="20"/>][2] [<img align="center" src="https://raw.githubusercontent.com/iconic/open-iconic/master/svg/globe.svg" height="20" width="20"/>][3]|
| :------------: | :------------: |

[1]: https://twitter.com/LiuChuan_
[2]: https://github.com/DevLiuSir
[3]: https://devliusir.com/