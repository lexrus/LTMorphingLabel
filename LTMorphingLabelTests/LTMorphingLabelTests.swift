//
//  LTMorphingLabelTests.swift
//  LTMorphingLabelTests
//
//  Created by Lex Tang on 1/12/15.
//  Copyright (c) 2015 lexrus.com. All rights reserved.
//

import XCTest
import LTMorphingLabel

class LTMorphingLabelTests : XCTestCase {
    
    func testStringDiff1() {
        let diffResults = "he".diffWith("hello")
        XCTAssert(
            diffResults.0[0] == .same,
            "First character isn't changed."
        )
        XCTAssert(diffResults.0[2] == .add, "Third character is added.")
    }
    
    func testStringDiff2() {
        let diffResults = "news".diffWith("westen")
        if case .moveAndAdd(let offset) = diffResults.0[0] {
            XCTAssert(
                offset == 5,
                "n is moved right for 5 steps, not \(offset)."
            )
        } else {
            XCTFail()
        }
        
        if case .moveAndAdd(let offset) = diffResults.0[2] {
            XCTAssert(
                offset == -2,
                "w is moved left for 2 steps, not \(offset)."
            )
        } else {
            XCTFail()
        }
        
        XCTAssert(diffResults.0[4] == .add, "2nd e is added.")
        XCTAssert(diffResults.1[5], "The last n was moved in.")
    }
    
    func testStringDiff3() {
        let diffResults = "Enchanté".diffWith("Swifter")
        
        XCTAssert(diffResults.0[4] == .replace, "a is deleted.")
    }
    
    func testStringDiff4() {
        let diffResults = "wo".diffWith("ox")
        XCTAssert(diffResults.0[0] == .replace, "w is replaced.")
        XCTAssert(
            diffResults.0[1] == .moveAndAdd(offset: -1),
            "o is moved and add a new character."
        )
    }
    
    func testStringDiff5() {
        let diffResults = "Objective-C".diffWith("iPhone")
        XCTAssert(diffResults.0[0] == .replace, "w is replaced.")
        XCTAssert(
            diffResults.0[3] == .moveAndAdd(offset: 2),
            "e is moved and add a new character."
        )
        XCTAssert(diffResults.0[8] == .delete, "2nd e is deleted.")
    }
    
    func testStringDiff6() {
        let diffResults = "wow".diffWith("newwow")
        XCTAssert(diffResults.0[2] == .moveAndAdd(offset: 1), "2nd. w is moved.")
    }
    
    func testEmojiDiff7() {
        let diffResults = "1️⃣2️⃣3️⃣".diffWith("3️⃣1️⃣2️⃣")
        XCTAssert(diffResults.0[0] == .moveAndAdd(offset: 1), "1st. 1 is moved.")
    }
    
    func testEmptyDiff8() {
        let diffResults0 = "".diffWith("hello")
        XCTAssert(diffResults0.0[0] == .add, "Every characters must be added.")
        let diffResults1 = "".diffWith("")
        XCTAssert(diffResults1.0.count == 0, "Must be empty.")
        let diffResults2 = "Hello".diffWith("")
        XCTAssert(diffResults2.0[0] == .delete, "Must be empty.")
    }

    func testLongDiffPerformance() {
        measure {
            let lhs =
                "Design is not just what it looks like and feels like."
                + "Design is how it works."
            let rhs =
                "Innovation distinguishes between a leader and a follower."
            _ = lhs.diffWith(rhs)
        }
    }

}
