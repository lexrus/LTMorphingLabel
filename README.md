
# LTMorphingLabel

[![Travis](https://img.shields.io/travis/lexrus/LTMorphingLabel.svg)](https://travis-ci.org/lexrus/LTMorphingLabel)
![Language](https://img.shields.io/badge/language-Swift%205-orange.svg)
[![CocoaPods](https://img.shields.io/cocoapods/v/LTMorphingLabel.svg?style=flat)](https://github.com/lexrus/LTMorphingLabel)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Accio supported](https://img.shields.io/badge/Accio-supported-0A7CF5.svg?style=flat)](https://github.com/JamitLabs/Accio)
![License](https://img.shields.io/github/license/lexrus/LTMorphingLabel.svg?style=flat)

A morphing UILabel subclass written in Swift, originally designed to mimic [Apple's QuickType animation in iOS 8 at WWDC 2014](https://youtu.be/w87fOAG8fjk?t=3451).

## Table of Contents

- [Available Effects](#available-effects)
	- [.scale](#scale-default)
	- [.evaporate](#evaporate)
	- [.fall](#fall)
	- [.pixelate](#pixelate)
	- [.sparkle](#sparkle)
	- [.burn](#burn)
- [Usage](#usage)
    - [UIKit](#uikit)
    - [SwiftUI](#swiftui)
- [Requirements](#requirements)
- [Installation](#installation)
    - [Swift Package Manager](#swift-package-manager)
    - [CocoaPods](#cocoapods)
    - [Carthage](#carthage)
    - [XCFramework](#xcframework)
    - [Accio](#accio)
- [Unit Testing](#unit-testing)
- [Apps Using `LTMorphingLabel`](#apps-using-ltmorphinglabel)
- [Third-Party Ports](#third-party-ports)
	- [Android](#android)
	- [React Native](#react-native)
- [License](#license)

## Available Effects

#### .scale (_default_)
<img src="https://cloud.githubusercontent.com/assets/219689/3491822/96bf5de6-059d-11e4-9826-a6f82025d1af.gif" width="300" height="70" alt="LTMorphingLabel"/>

#### [.evaporate](https://github.com/lexrus/LTMorphingLabel/blob/master/LTMorphingLabel/LTMorphingLabel%2BEvaporate.swift)
<img src="https://cloud.githubusercontent.com/assets/219689/3491838/ffc5aff2-059d-11e4-970c-6e2d7664785a.gif" width="300" height="70" alt="LTMorphingLabel-Evaporate"/>

#### [.fall](https://github.com/lexrus/LTMorphingLabel/blob/master/LTMorphingLabel/LTMorphingLabel%2BFall.swift)
<img src="https://cloud.githubusercontent.com/assets/219689/3491840/173c2238-059e-11e4-9b33-dcd21edae9e2.gif" width="300" height="70" alt="LTMorphingLabel-Fall"/>

#### [.pixelate](https://github.com/lexrus/LTMorphingLabel/blob/master/LTMorphingLabel/LTMorphingLabel%2BPixelate.swift)
<img src="https://cloud.githubusercontent.com/assets/219689/3491845/29bb0f8c-059e-11e4-9ef8-de56bec1baba.gif" width="300" height="70" alt="LTMorphingLabel-Pixelate"/>

#### [.sparkle](https://github.com/lexrus/LTMorphingLabel/blob/master/LTMorphingLabel/LTMorphingLabel%2BSparkle.swift)
<img src="https://cloud.githubusercontent.com/assets/219689/3508789/31e9fafe-0690-11e4-9a76-ba3ef45eb53a.gif" width="300" height="70" alt="LTMorphingLabel-Sparkle"/>

> ```.sparkle``` is built on top of `QuartzCore.CAEmitterLayer`. There is also a SpriteKit-powered version [here](https://github.com/lexrus/LTMorphingLabel/blob/spritekit-sparkle/LTMorphingLabel/LTMorphingLabel%2BSparkle.swift).

#### [.burn](https://github.com/lexrus/LTMorphingLabel/blob/master/LTMorphingLabel/LTMorphingLabel%2BBurn.swift)
<img src="https://cloud.githubusercontent.com/assets/219689/3582586/4fb8c52e-0bfe-11e4-9b6f-f070f7f3ab55.gif" width="300" height="70" alt="LTMorphingLabel-Burn"/>

#### [.anvil](https://github.com/lexrus/LTMorphingLabel/blob/master/LTMorphingLabel/LTMorphingLabel%2BAnvil.swift)
<img src="https://cloud.githubusercontent.com/assets/219689/3594949/815cd3e8-0caa-11e4-9738-278a9c959478.gif" width="300" height="70" alt="LTMorphingLabel-Anvil"/>

## Usage

### UIKit

Since `LTMorphingLabel` is a drop-in replacement, you can use it like any `UILabel` by setting its text property, yielding the default effect (`.scale`):

```swift
var exampleLabel = LTMorphingLabel()
exampleLabel.text = "This is a test"
```
![UIKitExample1](https://github.com/jonathanwuki/LTMorphingLabel/assets/11484046/bba7138e-1ef8-4714-8792-f34349434761)

Alternatively, it can be used interactively:
```swift
var exampleLabel = LTMorphingLabel()
exampleLabel.text = "This is a test"
exampleLabel.pause()

// Call .updateProgress(progress: Float) for interactive animation
// Note: In this case, animation will stop at 45% and will not complete
//       unless called later with 100 as the `progress` float value.
exampleLabel.updateProgress(progress: 45.0)
```

The effect can be changed by setting the `morphingEffect` property:
```swift
var exampleLabel = LTMorphingLabel()
exampleLabel.text = "This is a test"
exampleLabel.morphingEffect = .burn
```
![UIKitExample2](https://github.com/jonathanwuki/LTMorphingLabel/assets/11484046/13ab83a6-7f1f-4aac-b0eb-d6172773a671)

### SwiftUI

To use `LTMorphingLabel` in SwiftUI, simply declare it and set its text, `effect`, `font`, and `textColor` properties:
```swift
public var body: some View {
    VStack {
        MorphingText(
            "This is a test",
            font: UIFont.systemFont(ofSize: 20),
            textColor: .black,
            textAlignment: .center
        )
        .frame(maxWidth: 200, maxHeight: 100)
    }
}
```

Similar to its use in UIKit, you can also specify the morphing effect manually (if you do not want to use the default `.scale` effect):
```swift
public var body: some View {
    VStack {
        MorphingText(
            "This is a test",
            effect: .burn,
            font: UIFont.systemFont(ofSize: 20),
            textColor: .black,
            textAlignment: .center
        )
        .frame(maxWidth: 200, maxHeight: 100)
    }
}
```
![LTMorphingLabelSwiftUI](https://user-images.githubusercontent.com/219689/81505494-2c528c80-9322-11ea-9bdb-b208dd38a5e6.png)

## Requirements

- Xcode 12+
- iOS 9.0+ (note that SwiftUI requires iOS 13+)

## Installation

### [Swift Package Manager](https://swift.org/package-manager/)

Simply add this library to your package manifest or follow instructions on adding a package dependency [using Xcode here](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app).
```swift
.package(
    url: "https://github.com/lexrus/LTMorphingLabel.git",
    .branch("master")
)
```

### [CocoaPods](http://cocoapods.org)

Add `pod 'LTMorphingLabel'` to your Podfile or follow instructions to add dependencies [here](https://guides.cocoapods.org/using/using-cocoapods.html).

### [Carthage](https://github.com/Carthage/Carthage)

Add `github "lexrus/LTMorphingLabel"` to your Cartfile or follow instructions on adding frameworks [here](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application).

### [XCFramework](https://developer.apple.com/videos/play/wwdc2019/416/)

A pre-compiled `xcframework` file is available on the [Releases](https://github.com/lexrus/LTMorphingLabel/releases) page.

### [Accio](https://github.com/JamitLabs/Accio)

1. Add this library to your package manifest (see [Swift Package Manager](#swift-package-manager))

2. Update your target dependencies to include `LTMorphingLabel`:

  ```swift
  .target(
      name: "App",
      dependencies: [
          "LTMorphingLabel",
      ]
  ),
  ```

3. Run `accio update`.

## Unit Testing

Clone the repo by running `git clone https://github.com/lexrus/LTMorphingLabel.git`, then open the project with Xcode and press Cmd + U (or, in the menu bar, click Product > Build for > Testing).

## Apps Using `LTMorphingLabel`
- [Idea](https://itunes.apple.com/app/id1286758943) by [Igor Matyushkin](https://github.com/igormatyushkin014)
- [Speedo[kilo]meter](https://itunes.apple.com/it/app/speedo-kilo-meter/id1228840413?mt=8) by [Alberto Pasca](http://www.albertopasca.it/whiletrue)  
- [Vatomium](http://vatomium.com) by [Erik Telepovský](http://pragmaticmates.com)
- [Atmos](http://www.atmosapp.com) by [@shnhrrsn](https://github.com/shnhrrsn)
- [The Met Challenge](https://itunes.apple.com/us/app/the-met-challenge/id917662781) by [@lazerwalker](https://github.com/lazerwalker)
- [Uther](https://github.com/callmewhy/Uther) by [@callmewhy](https://github.com/callmewhy)
- [Reax](https://itunes.apple.com/us/app/reax-witness-2016-here.-now./id1076183758?ls=1&mt=8) by Reax Inc
- [Puzzpic](https://itunes.apple.com/us/app/puzzpic/id1092871121) by [Moath Othman](http://moathothman.com)
- [Drops](http://languagedrops.com) by [Mark Aron Szulyovszky](https://github.com/itchingpixels)
- [Setgraph Workout Log](https://itunes.apple.com/us/app/setgraph-workout-log/id1209781676?mt=8) by [Arturo Lee](https://github.com/ArturoLee)
- [Nihon](https://itunes.apple.com/app/id1315486029) by [KyXu](https://github.com/OpenMarshall)
- [Lightsync](https://itunes.apple.com/app/id1463390406?mt=8&ct=ghltml) by [Marcel Braun](https://github.com/thatmarcel)
- [Find](https://apps.apple.com/app/find-command-f-for-camera/id1506500202) by [A. Zheng](https://github.com/aheze)

## Third-Party Ports

### Android

The Android port of this library is available [here](https://github.com/hanks-zyh/HTextView).

### React Native

The React Native port of this library is available [here](https://github.com/prscX/react-native-morphing-text).

## License

This code is distributed under the terms and conditions of the MIT license.
