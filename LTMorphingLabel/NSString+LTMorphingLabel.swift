//
//  NSString+LTMorphingLabel.swift
//  https://github.com/lexrus/LTMorphingLabel
//
//  The MIT License (MIT)
//  Copyright (c) 2014 Lex Tang, http://LexTang.com
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the “Software”), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation


enum LTCharacterDiffType: Int, DebugPrintable {
    
    case Same = 0
    case Add = 1
    case Delete
    case Move
    case MoveAndAdd
    case Replace
    
    var debugDescription: String {
    get {
        switch self {
        case .Same:
            return "Same"
        case .Add:
            return "Add"
        case .Delete:
            return "Delete"
        case .Move:
            return "Move"
        case .MoveAndAdd:
            return "MoveAndAdd"
        default:
            return "Replace"
        }
    }
    }
    
}


struct LTCharacterDiffResult: DebugPrintable {
    
    var diffType: LTCharacterDiffType
    var moveOffset: Int
    var skip: Bool
    
    var debugDescription: String {
    get {
        switch diffType {
        case .Same:
            return "The character is unchanged."
        case .Add:
            return "A new character is ADDED."
        case .Delete:
            return "The character is DELETED."
        case .Move:
            return "The character is MOVED to \(moveOffset)."
        case .MoveAndAdd:
            return "The character is MOVED to \(moveOffset) and a new character is ADDED."
        default:
            return "The character is REPLACED with a new character."
        }
    }
    }
    
}


func >>(lhs: String, rhs: String) -> Array<LTCharacterDiffResult> {
    
    var diffResults = Array<LTCharacterDiffResult>()
    let newChars = enumerate(rhs)
    let lhsLength = countElements(lhs)
    let rhsLength = countElements(rhs)
    var skipIndexes = Array<Int>()
    
    for i in 0..<(max(lhsLength, rhsLength) + 1) {
        var result = LTCharacterDiffResult(diffType: .Add, moveOffset: 0, skip: false)
        
        // If new string is longer than the original one
        if i > lhsLength - 1 {
            result.diffType = .Add
            diffResults.append(result)
            continue
        }
        
        let leftChar = Array(lhs)[i]
        
        // Search left character in the new string
        var foundCharacterInRhs = false
        for (j, newChar) in newChars {
            let currentCharWouldBeReplaced = {
                (index: Int) -> Bool in
                for k in skipIndexes {
                    if index == k {
                        return true
                    }
                }
                return false
                }(j)
            
            if currentCharWouldBeReplaced {
                continue
            }
            
            if leftChar == newChar {
                skipIndexes.append(j)
                foundCharacterInRhs = true
                if i == j {
                    // Character not changed
                    result.diffType = .Same
                } else {
                    // foundCharacterInRhs and move
                    result.diffType = .Move
                    if i <= rhsLength - 1 {
                        // Move to a new index and add a new character to new original place
                        result.diffType = .MoveAndAdd
                    }
                    result.moveOffset = j - i
                }
                break
            }
        }
        
        if !foundCharacterInRhs {
            if i < countElements(rhs) - 1 {
                result.diffType = .Replace
            } else {
                result.diffType = .Delete
            }
        }
        if i > lhsLength - 1 {
            result.diffType = .Add
        }
        
        diffResults.append(result)
    }
    
    var i = 0
    for result in diffResults {
        switch result.diffType {
        case .Move, .MoveAndAdd:
            diffResults[i + result.moveOffset].skip = true
        default:
            ()
        }
        i++
    }
    
    return diffResults
    
}
