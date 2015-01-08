# LTMorphingLabel
A morphing UILabel subclass written in Swift.
The ```.Scale``` effect is originally introduced by Apple in WWDC 2014. New morphing effects are available as Swift extensions. 

## enum LTMorphingEffect: Int, Printable

#### .Scale - _default_
<img src="https://cloud.githubusercontent.com/assets/219689/3491822/96bf5de6-059d-11e4-9826-a6f82025d1af.gif" width="300" height="70" alt="LTMorphingLabel"/>

#### [.Evaporate](https://github.com/lexrus/LTMorphingLabel/blob/master/LTMorphingLabel/LTMorphingLabel%2BEvaporate.swift)
<img src="https://cloud.githubusercontent.com/assets/219689/3491838/ffc5aff2-059d-11e4-970c-6e2d7664785a.gif" width="300" height="70" alt="LTMorphingLabel-Evaporate"/>

#### [.Fall](https://github.com/lexrus/LTMorphingLabel/blob/master/LTMorphingLabel/LTMorphingLabel%2BFall.swift)
<img src="https://cloud.githubusercontent.com/assets/219689/3491840/173c2238-059e-11e4-9b33-dcd21edae9e2.gif" width="300" height="70" alt="LTMorphingLabel-Fall"/>

#### [.Pixelate](https://github.com/lexrus/LTMorphingLabel/blob/master/LTMorphingLabel/LTMorphingLabel%2BPixelate.swift)
<img src="https://cloud.githubusercontent.com/assets/219689/3491845/29bb0f8c-059e-11e4-9ef8-de56bec1baba.gif" width="300" height="70" alt="LTMorphingLabel-Pixelate"/>

#### [.Sparkle](https://github.com/lexrus/LTMorphingLabel/blob/master/LTMorphingLabel/LTMorphingLabel%2BSparkle.swift)
<img src="https://cloud.githubusercontent.com/assets/219689/3508789/31e9fafe-0690-11e4-9a76-ba3ef45eb53a.gif" width="300" height="70" alt="LTMorphingLabel-Sparkle"/>

```.Sparkle``` is built on top of QuartzCore.CAEmitterLayer. There's also a [SpriteKit powered version here](https://github.com/lexrus/LTMorphingLabel/blob/spritekit-sparkle/LTMorphingLabel/LTMorphingLabel%2BSparkle.swift).

#### [.Burn](https://github.com/lexrus/LTMorphingLabel/blob/master/LTMorphingLabel/LTMorphingLabel%2BBurn.swift)
<img src="https://cloud.githubusercontent.com/assets/219689/3582586/4fb8c52e-0bfe-11e4-9b6f-f070f7f3ab55.gif" width="300" height="70" alt="LTMorphingLabel-Burn"/>

#### [.Anvil](https://github.com/lexrus/LTMorphingLabel/blob/master/LTMorphingLabel/LTMorphingLabel%2BAnvil.swift)
<img src="https://cloud.githubusercontent.com/assets/219689/3594949/815cd3e8-0caa-11e4-9738-278a9c959478.gif" width="300" height="70" alt="LTMorphingLabel-Anvil"/>

## Requirements
1. Xcode 6.1
2. iOS 7.0+

## TODOs & Known issues
- [ ] Improve diff performance
- [ ] Text kerning
- [ ] Text shadow
- [ ] Multiline
- [ ] Particles of `.Burn` is weired
- [ ] Docs

## Installation

### [Carthage](https://github.com/Carthage/Carthage)

1. Add this line to your Cartfile: `github "lexrus/LTMorphingLabel"`
2. Run `carthage update` to fetch and build the `LTMorphingLabel.framework`
3. Drag `LTMorphingLabel.framework` into your iOS 8 project

### [CocoaPods](http://cocoapods.org)

1. Install the latest preview release of CocoaPods: `gem install cocoapods --pre`
2. Add this line to your Podfile: `pod 'LTMorphingLabel', '~> 0.0.3'`
3. Install the pod: `pod install`

## Usage

1. Change the class of a label from UILabel to LTMorphingLabel;
2. Programatically set a new String to its text property.

## Unit tests
Open the project with Xcode 6 then press command + u.

## Contacts
Follow [Lex Tang](https://github.com/lexrus/) ([@lexrus on Twitter](https://twitter.com/lexrus/))

## License
This code is distributed under the terms and conditions of the MIT license.
