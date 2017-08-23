//
//  LTCharacterDiffResult.swift
//  https://github.com/lexrus/LTMorphingLabel
//
//  The MIT License (MIT)
//  Copyright (c) 2017 Lex Tang, http://lexrus.com
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

public enum LTCharacterDiffResult: CustomDebugStringConvertible, Equatable {
    
    case same
    case add
    case delete
    case move(offset: Int)
    case moveAndAdd(offset: Int)
    case replace
    
    public var debugDescription: String {
        switch self {
        case .same:
            return "The character is unchanged."
        case .add:
            return "A new character is ADDED."
        case .delete:
            return "The character is DELETED."
        case .move(let offset):
            return "The character is MOVED to \(offset)."
        case .moveAndAdd(let offset):
            return "The character is MOVED to \(offset) and a new character is ADDED."
        case .replace:
            return "The character is REPLACED with a new character."
        }
    }
    
}

public func == (lhs: LTCharacterDiffResult, rhs: LTCharacterDiffResult) -> Bool {
    switch (lhs, rhs) {
    case (.move(let offset0), .move(let offset1)):
        return offset0 == offset1
    
    case (.moveAndAdd(let offset0), .moveAndAdd(let offset1)):
        return offset0 == offset1
    
    case (.add, .add):
        return true
        
    case (.delete, .delete):
        return true
    
    case (.replace, .replace):
        return true
    
    case (.same, .same):
        return true
    
    default: return false
    }
}
