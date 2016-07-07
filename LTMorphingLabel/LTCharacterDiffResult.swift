//
//  LTCharacterDiffResult.swift
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


public enum LTCharacterDiffResult: CustomDebugStringConvertible, Equatable {
    
    case Same
    case Add
    case Delete
    case Move(offset: Int)
    case MoveAndAdd(offset: Int)
    case Replace
    
    public var debugDescription: String {
        switch self {
        case .Same:
            return "The character is unchanged."
        case .Add:
            return "A new character is ADDED."
        case .Delete:
            return "The character is DELETED."
        case .Move(let offset):
            return "The character is MOVED to \(offset)."
        case .MoveAndAdd(let offset):
            return "The character is MOVED to \(offset) and a new character is ADDED."
        case .Replace:
            return "The character is REPLACED with a new character."
        }
    }
    
}

public func == (lhs: LTCharacterDiffResult, rhs: LTCharacterDiffResult) -> Bool {
    switch (lhs, rhs) {
    case (.Move(let offset0), .Move(let offset1)):
        return offset0 == offset1
    
    case (.MoveAndAdd(let offset0), .MoveAndAdd(let offset1)):
        return offset0 == offset1
    
    case (.Add, .Add):
        return true
        
    case (.Delete, .Delete):
        return true
    
    case (.Replace, .Replace):
        return true
    
    case (.Same, .Same):
        return true
    
    default: return false
    }
}
