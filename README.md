# iOSChatHead
Light Weight iOS chat Head with Badge

[![Swift 4.0](https://img.shields.io/badge/Swift-4-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-ios-blue.svg?style=flat)](https://cocoapods.org/pods/iOSDropDown)
[![Star](https://img.shields.io/amo/stars/dustman.svg?style=flat)]()



## Example
[![](https://raw.githubusercontent.com/jriosdev/iOSChatHead/master/images/1.gif)](images/1.gif)

[![](https://raw.githubusercontent.com/jriosdev/iOSChatHead/master/images/2.gif)](images/2.gif)



## Features
1. Gestures
        ` [single tap],[double tap],[longpress],[dragging],[drag done],[auto docking done]`
2. Badge text for icon  
        ` Fully customizable `
3. Auto Docking
4. All Attributes of ` UIButton`



### Manual

Just clone and add the following Swift files to your project:
- iOSChatHead.swfit

## Basic usage ✨



### Code Method
```swift
var chat1:iOSChatHead!

override func viewDidLoad() {
    super.viewDidLoad()

    self.chat1 = iOSChatHead.init(frame: CGRect(x: 0, y: 150, width: 50, height: 50))
    self.chat1.badgeEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 0, right: 15)
    //chat1.setImage(#imageLiteral(resourceName: "cha1.png"), for: .normal)

    UIApplication.shared.keyWindow?.bringSubviewToFront(self.chat3)
    chat1.badgeString = "New"

}
```
### Other Options
Actions && Closures

```swift
var tapBlock:(()->Void)? 
var doubleTapBlock:(()->Void)?
var longPressBlock:(()->Void)?
var draggingBlock:(()->Void)?
var dragDoneBlock:(()->Void)?
var autoDockingBlock:(()->Void)?
var autoDockingDoneBlock:(()->Void)?

````


## Customize iOSChatHead 🖌
You can customize with all properties of UIButton:
AND
You can customize these properties of the Badge:
- `badgeString ` : You can add badge for button.Default vaule is `""`
- `cornerRadiusFactor` : Factor that can change corner radius of badge. Default value is `2`
- `verticalMargin` : This is the space between text and badge's vertical edge 
- `horizontalMargin` : This is the space between text and badge's horizontal edge
- `badgeEdgeInsets`:  specify amount to inset (positive) for each of the edges. Type  is `UIEdgeInsets ` 
- `badgeBackgroundColor`: The  badge Background Color. Default value is  ` .red`
- `badgeTextColor`: This is Badge Text Color. Default value is `.white`
- `edgeInsetLeft`: Can be adjust from Interface Builder EdgeInsetLeft
- `edgeInsetRight`: Can be adjust from Interface Builder EdgeInsetRight
- `edgeInsetTop` : Can be adjust from Interface Builder EdgeInsetTop
- `edgeInsetBottom`:  Can be adjust from Interface Builder EdgeInsetBottom
- `anchor`: It represent different anchor on button Values are:0 = TopLeft,1 = TopRight,2 = BottomLeft,3 = BottomRight,4 = Center


## Author
### ✨✨If you like my project please Give me a STAR on Github✨✨
Jishnu Raj T, jriosdev@gmail.com
[![Contact](https://img.shields.io/badge/Contact-%40jishnurajt-blue.svg?style=flat)](https://twitter.com/jishnurajt)

## License

iOSChatHead is available under the MIT license. See the LICENSE file for more info.
