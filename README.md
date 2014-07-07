# LTMorphingLabel
A morphing UILabel subclass written in Swift.
The ```.Scale``` effect is originally introduced by Apple in WWDC 2014. New morphing effects are available as Swift extensions. 

## Demo:
<img src="https://cloud.githubusercontent.com/assets/219689/3466547/9828c2f8-0282-11e4-9bcf-04592a0aa1c5.gif" width="315" height="265" alt="LTMorphingLabel"/>

<a href="https://dribbble.com/shots/1621547-LTMorphingLabel">And an ad on Dribbble</a>

## Morphing effects
1. ```.Scale``` - default
2. ```.Evaporate``` - [LTMorphingLabel+Evaporate.swift](https://github.com/lexrus/LTMorphingLabel/blob/master/LTMorphingLabel/LTMorphingLabel%2BEvaporate.swift)
3. ```.Fall``` - [LTMorphingLabel+Fall.swift](https://github.com/lexrus/LTMorphingLabel/blob/master/LTMorphingLabel/LTMorphingLabel%2BFall.swift)
4. ```.Pixelate``` - [LTMorphingLabel+Pixelate.swift](https://github.com/lexrus/LTMorphingLabel/blob/master/LTMorphingLabel/LTMorphingLabel%2BPixelate.swift)
5. ```.Sparkle``` - [LTMorphingLabel+Sparkle.swift](https://github.com/lexrus/LTMorphingLabel/blob/master/LTMorphingLabel/LTMorphingLabel%2BSparkle.swift)

## TODOs & Known issues
- [ ] Improve diff performance
- [ ] Text kerning
- [ ] Align to pixel
- [ ] Text shadow
- [ ] Multiline
- [ ] How to fade in/out Emoji?
- [ ] ```.FallDownAndFade``` is buggy
- [ ] Docs

## Usage
1. Copy LTMorphingLabel folder to your iOS 8 project;
2. Change the class of a label from UILabel to LTMorphingLabel;
3. Programatically set a new String to its text property.

## Unit tests
Open the project with Xcode 6 then press command + u.

## Contacts
Follow [Lex Tang](https://github.com/lexrus/) ([@lexrus on Twitter](https://twitter.com/lexrus/))

## License
This code is distributed under the terms and conditions of the MIT license.
