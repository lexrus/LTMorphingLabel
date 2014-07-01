# LTMorphingLabel
A morphing UILabel subclass written in Swift.
The ```.Scale``` effect is originally introduced by Apple in WWDC 2014. New morphing effects are available as Swift extensions. 

## Demo:
<img src="https://cloud.githubusercontent.com/assets/219689/3426548/cdacb1b6-0023-11e4-9827-15901055c8d0.gif" width="313" height="230" alt="LTMorphingLabel"/>

<a href="https://dribbble.com/shots/1621547-LTMorphingLabel">And this is the ad on Dribbble</a>

<img src="https://d13yacurqjgara.cloudfront.net/users/67541/screenshots/1621547/ltmorphinglabeldribbble.gif" width="400" height="300" alt="Dribbble shot"/>

## Morphing effects
1. ```.Scale``` - default
2. ```.Evaporate``` - [LTMorphingLabel+Evaporate.swift](https://github.com/lexrus/LTMorphingLabel/blob/master/LTMorphingLabel/LTMorphingLabel%2BEvaporate.swift)
3. ```.Fall``` - [LTMorphingLabel+Fall.swift](https://github.com/lexrus/LTMorphingLabel/blob/master/LTMorphingLabel/LTMorphingLabel%2BFall.swift)
4. {Yours}

## TODOs & Known issues
- [ ] Improve diff performance
- [ ] Text kerning
- [ ] Align to pixel
- [ ] Text shadow
- [ ] Multiline
- [ ] How to fade in/out Emoji?
- [ ] ```.FallDownAndFade``` is buggy
- [ ] Delegates or callback closures

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
