//
//  LTStringDiffResult.swift
//  https://github.com/lexrus/LTMorphingLabel
//
//  The MIT License (MIT)
//  Copyright (c) 2016 Lex Tang, http://lexrus.com
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files
//  (the “Software”), to deal in the Software without restriction,
//  including without limitation the rights to use, copy, modify, merge,
//  publish, distribute, sublicense, and/or sell copies of the Software,
//  and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included
//  in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
//  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
//  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
//  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Foundation


public typealias LTStringDiffResult = ([LTCharacterDiffResult], skipDrawingResults: [Bool])


public extension String {
    
    public func diffWith(anotherString: String?) -> LTStringDiffResult {
        
        guard let anotherString = anotherString else {
            let diffResults: [LTCharacterDiffResult] =
                Array(count: characters.count, repeatedValue: .Delete)
            let skipDrawingResults: [Bool] = Array(count: characters.count, repeatedValue: false)
            return (diffResults, skipDrawingResults)
        }
        
        let newChars = anotherString.characters.enumerate()
        let lhsLength = characters.count
        let rhsLength = anotherString.characters.count
        var skipIndexes = [Int]()
        let leftChars = Array(characters)
        
        let maxLength = max(lhsLength, rhsLength)
        var diffResults: [LTCharacterDiffResult] = Array(count: maxLength, repeatedValue: .Add)
        var skipDrawingResults: [Bool] = Array(count: maxLength, repeatedValue: false)
        
        for i in 0..<maxLength {
            // If new string is longer than the original one
            if i > lhsLength - 1 {
                continue
            }
            
            let leftChar = leftChars[i]
            
            // Search left character in the new string
            var foundCharacterInRhs = false
            for (j, newChar) in newChars {
                if skipIndexes.contains(j) || leftChar != newChar {
                    continue
                }
                
                skipIndexes.append(j)
                foundCharacterInRhs = true
                if i == j {
                    // Character not changed
                    diffResults[i] = .Same
                } else {
                    // foundCharacterInRhs and move
                    let offset = j - i
                    
                    if i <= rhsLength - 1 {
                        // Move to a new index and add a new character to new original place
                        diffResults[i] = .MoveAndAdd(offset: offset)
                    } else {
                        diffResults[i] = .Move(offset: offset)
                    }
                    
                    skipDrawingResults[j] = true
                }
                break
            }
            
            if !foundCharacterInRhs {
                if i < rhsLength - 1 {
                    diffResults[i] = .Replace
                } else {
                    diffResults[i] = .Delete
                }
            }
        }
        
        return (diffResults, skipDrawingResults)
        
    }
    
}
