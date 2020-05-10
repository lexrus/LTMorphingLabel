//
//  MorphingText.swift
//  LTMorphingLabel
//
//  Created by Lex on 2020/5/10.
//  Copyright © 2020 lexrus.com. All rights reserved.
//

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13.0.0, *)
public struct MorphingText: UIViewRepresentable {
    public typealias UIViewType = LTMorphingLabel
    
    var text: String
    var morphingEffect: LTMorphingEffect
    var moprhingEnabled: Bool = true
    var font: UIFont
    var textColor: UIColor
    var textAlignment: NSTextAlignment
    
    public init(_ text: String,
                effect: LTMorphingEffect = .scale,
                font: UIFont = .systemFont(ofSize: 16),
                textColor: UIColor = .black,
                textAlignment: NSTextAlignment = .center
    ) {
        self.text = text
        self.morphingEffect = effect
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
    }

    public func makeUIView(context: Context) -> UIViewType {
        let label = LTMorphingLabel(frame: CGRect(origin: .zero, size: CGSize(width: 200, height: 50)))
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }

    public func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.text = text
        uiView.font = font
        uiView.morphingEnabled = moprhingEnabled
        uiView.morphingEffect = morphingEffect
        uiView.textColor = textColor
        uiView.textAlignment = textAlignment
    }
}

@available(iOS 13.0.0, *)
struct MorphingText_Previews: PreviewProvider {
    
    static var previews: some View {
        PreviewWrapper()
            .previewDevice("iPhone SE")
            .environment(\.colorScheme, .dark)
    }

    struct PreviewWrapper: View {
        @State var morphingEnabled = true
        @State var textIndex: Double = 0
        @State var effectIndex: Double = 0
        
        private var textArray = [
            "Supercalifragilisticexpialidocious",
            "Stay hungry, stay foolish.",
            "Love what you do and do what you love.",
            "Apple doesn't do hobbies as a general rule.",
            "iOS",
            "iPhone",
            "iPhone 11",
            "iPhone 11 Pro",
            "iPhone 11 Pro Max",
            "$9995.00",
            "$9996.00",
            "$9997.00",
            "$9998.00",
            "$9999.00",
            "$10000.00"
        ]
        
        public var body: some View {
            VStack {
                Spacer()
                Text("LTMorphingLabel").font(.largeTitle)
                Text("for SwiftUI").font(.title)
                
                MorphingText(
                    textArray[Int(round(textIndex))],
                    effect: LTMorphingEffect.allCases[Int(round(effectIndex))],
                    font: UIFont.systemFont(ofSize: 20),
                    textColor: .white
                )
                    .frame(maxWidth: 200, maxHeight: 100)
                
                Text("Effect: \(LTMorphingEffect.allCases[Int(round(effectIndex))].description)").font(.title)
                Slider(value: $effectIndex, in: 0...Double(LTMorphingEffect.allCases.count - 1))
                
                Slider(value: $textIndex, in: 0...Double(textArray.count - 1))
                
                Toggle("MorphingEnabled", isOn: $morphingEnabled)
                Spacer()
            }
            .padding(20)
            .foregroundColor(Color.white)
            .background(Color.black)
        }
    }
}
