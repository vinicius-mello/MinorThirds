//
//  ChordTable.swift
//  MinorThirds
//
//  Created by Vinicius Mello on 02/07/15.
//  Copyright (c) 2015 Vinicius Mello. All rights reserved.
//

class ChordType {
    var name : String = ""
    var symbol : String = ""
    var tones : [Int] = []
    init(name: String, symbol: String, tones: [Int]) {
        self.name = name
        self.symbol = symbol
        self.tones = tones
    }
    func format(root: Int, bass: Int) -> String {
        if root==bass {
            return "\(noteName(root))\(self.symbol)"
        } else {
            return "\(noteName(root))\(self.symbol)/\(noteName(bass))"
        }
    }
}

let CM = ChordType(name: "major",
    symbol: "", tones: [0,4,7])
let Cm = ChordType(name: "minor",
    symbol: "m", tones: [0,3,7])
let C7 = ChordType(name: "seventh",
    symbol: "7", tones: [0,4,7,10])
let C7M = ChordType(name: "major seventh",
    symbol: "7M", tones: [0,4,7,11])
let C6 = ChordType(name: "",
    symbol: "6", tones: [0,4,7,9])
let Cm6 = ChordType(name: "",
    symbol: "m6", tones: [0,3,7,9])
let Cm7 = ChordType(name: "minor seventh",
    symbol: "m7", tones: [0,3,7,10])
let Cdim = ChordType(name: "diminished",
    symbol: "°", tones: [0,3,6,9])
let Cm7b5 = ChordType(name: "half diminished",
    symbol: "m7(b5)", tones: [0,3,6,10])
let Cm79 = ChordType(name: "minor ninth",
    symbol: "m7(9)", tones: [0,3,7,10,14])
let Cm69 = ChordType(name: "",
    symbol: "m6(9)", tones: [0,3,7,9,14])
let C713 = ChordType(name: "",
    symbol: "7(13)", tones: [0,4,7,10,21])
let C7b13 = ChordType(name: "",
    symbol: "7(b13)", tones: [0,4,7,10,20])
let C79 = ChordType(name: "",
    symbol: "7(9)", tones: [0,4,7,10,14])
let C7b9 = ChordType(name: "",
    symbol: "7(b9)", tones: [0,4,7,10,13])
let Cm711 = ChordType(name: "",
    symbol: "m7(11)", tones: [0,3,10,17])
let C749 = ChordType(name: "",
    symbol: "7(4)(9)", tones: [0,5,10,14])
let C7a11 = ChordType(name: "",
    symbol: "7(#11)", tones: [0,4,10,18])
let C71113 = ChordType(name: "",
    symbol: "7(11)(13)", tones: [0,10,17,21])
let C7Ma11 = ChordType(name: "",
    symbol: "7M(#11)", tones: [0,4,11,18])
let C69 = ChordType(name: "",
    symbol: "6(9)", tones: [0,4,7,9,14])
let C7Ma5 = ChordType(name: "",
symbol: "7M(#5)", tones: [0,4,8,11])
let C7a9 = ChordType(name: "",
    symbol: "7(#9)", tones: [0,4,10,15])
let C7M9 = ChordType(name: "",
    symbol: "7M(9)", tones: [0,4,11,14])
let C47 = ChordType(name: "",
    symbol: "4(7)", tones: [0,5,7,10])
let C9 = ChordType(name: "",
    symbol: "add9", tones: [0,4,7,14])
let Cm7b9 = ChordType(name: "",
    symbol: "m7(b9)", tones: [0,3,7,10,13])
let C7M6 = ChordType(name: "",
    symbol: "7M(6)", tones: [0,4,7,9,11])
let C7M69 = ChordType(name: "",
    symbol: "7M(6)(9)", tones: [0,4,7,9,11,14])
let C7M9a11 = ChordType(name: "",
    symbol: "7M(9)(#11)", tones: [0,4,11,14,18])
let C69a11 = ChordType(name: "",
    symbol: "6(9)(#11)", tones: [0,4,9,14,18])
let Ca5 = ChordType(name: "",
    symbol: "(#5)", tones: [0,4,8])
let Cm7911 = ChordType(name: "",
    symbol: "m7(9)(11)", tones: [0,3,10,14,17])
let Cm6911 = ChordType(name: "",
    symbol: "m6(9)(11)", tones: [0,3,9,14,17])
let Cm7M = ChordType(name: "",
    symbol: "m(7M)", tones: [0,3,7,11])
let Cm7M9 = ChordType(name: "",
    symbol: "m(7M)(9)", tones: [0,3,7,11,14])
let Cm7M6 = ChordType(name: "",
    symbol: "m(7M)(6)", tones: [0,3,7,9,11])
let Cm7M911 = ChordType(name: "",
    symbol: "m(7M)(9)(11)", tones: [0,3,11,14,17])
let Cm9 = ChordType(name: "",
    symbol: "m(add9)", tones: [0,3,7,14])
let C4 = ChordType(name: "",
    symbol: "4", tones: [0,5,7])
let C7913 = ChordType(name: "",
    symbol: "7(9)(13)", tones: [0,4,10,14,21])
let C79a11 = ChordType(name: "",
    symbol: "7(9)(#11)", tones: [0,4,10,14,18])
let C7a1113 = ChordType(name: "",
    symbol: "7(#11)(13)", tones: [0,4,10,18,21])
let C7a5 = ChordType(name: "",
    symbol: "7(#5)", tones: [0,4,8,10])
let C7b5 = ChordType(name: "",
    symbol: "7(b5)", tones: [0,4,6,10])
let C7a59 = ChordType(name: "",
    symbol: "7(#5)(9)", tones: [0,4,8,10,14])
let C7b59 = ChordType(name: "",
    symbol: "7(b5)(9)", tones: [0,4,6,10,14])
let C7b913 = ChordType(name: "",
    symbol: "7(b9)(13)", tones: [0,4,7,10,13,21])
let C7a5b9 = ChordType(name: "",
    symbol: "7(#5)(b9)", tones: [0,4,8,10,13])
let C7a5a9 = ChordType(name: "",
    symbol: "7(#5)(#9)", tones: [0,4,8,10,15])
let C7b5b9 = ChordType(name: "",
    symbol: "7(b5)(b9)", tones: [0,4,6,10,13])
let C7b5a9 = ChordType(name: "",
    symbol: "7(b5)(#9)", tones: [0,4,6,10,15])
let C47913 = ChordType(name: "",
    symbol: "4(7)(9)(13)", tones: [0,5,10,14,21])
let C47b9 = ChordType(name: "",
    symbol: "4(7)(b9)", tones: [0,5,10,13])
let C7b9a11 = ChordType(name: "",
    symbol: "7(b9)(#11)", tones: [0,4,10,13,18])
let C7b9a1113 = ChordType(name: "",
    symbol: "7(b9)(#11)(13)", tones: [0,4,10,13,18,21])
let Cm7b59 = ChordType(name: "",
    symbol: "m7(b5)(9)", tones: [0,3,6,10,14])
let C7b9b13 = ChordType(name: "",
    symbol: "7(b9)(b13)", tones: [0,4,7,10,13,20])
let C7a9a11 = ChordType(name: "",
    symbol: "7(#9)(#11)", tones: [0,4,7,10,15,18])
let Cmb6 = ChordType(name: "",
    symbol: "m(b6)", tones: [0,3,7,8])
let Cm5 = ChordType(name: "",
    symbol: "m(5)", tones: [0,3,7])
let C59 = ChordType(name: "",
    symbol: "5(9)", tones: [0,7,14])

let Cdimb13 = ChordType(name: "",
    symbol: "°(b13)", tones: [0,3,6,9,20])
let Cdim7M = ChordType(name: "",
    symbol: "°(7M)", tones: [0,3,6,9,11])
let Cdim9 = ChordType(name: "",
    symbol: "°(9)", tones: [0,3,6,9,14])
let Cdim11 = ChordType(name: "",
    symbol: "°(11)", tones: [0,3,6,9,17])

let chordTypes : [ChordType] = [
    CM,Cm,C7,C7M,C6,Cm6,Cm7,
    Cdim,Cm7b5,Cm79,Cm69,
    C713,C7b13,C79,C7b9,
    Cm711,C749,C7a11,C71113,C7Ma11,
    C69,C7Ma5,C7a9,C7M9,C47,C9,
    Cm7b9,C7M6,C7M69,C7M9a11,C69a11,
    Ca5,Cm7911,Cm6911,Cm7M,Cm7M9,
    Cm7M6,Cm7M911,Cm9,C4,C7913,
    C79a11,C7a1113,C7a5,C7b5,C7a59,
    C7b59,C7b913,C7a5b9,C7a5a9,
    C7b5b9,C7b5a9,C47913,C47b9,
    C7b9a11,C7b9a1113,Cm7b59,Cm7b59,C7b9b13,C7a9a11,
    Cmb6,Cm5,
    Cdimb13,Cdim7M,Cdim9,Cdim11,C59]


let positionTable : [String : (ChordType,Int)] = [
    "(0,0)(0,4)(1,5)(1,6)" : (CM,0),
    "(0,0)(1,1)(1,2)(0,4)" : (CM,0),
    "(0,0)(1,2)(0,4)(1,5)" : (CM,0),
    "(0,0)(-1,3)(0,4)(0,5)" : (CM,1),
    "(0,0)(-1,3)(0,5)(-1,7)" : (CM,1),
    "(0,0)(-1,2)(0,3)(0,4)" : (CM,1),
    "(0,0)(0,3)(0,4)(-1,6)" : (CM,3),
    "(0,0)(1,2)(2,3)(2,4)" : (CM,1),
    "(0,0)(-2,3)(-1,4)(-1,5)" : (CM,1),
    "(0,0)(0,1)(-1,3)(0,4)" : (CM,2),
    "(0,0)(0,4)(-1,6)(0,7)" : (CM,2),
    "(0,0)(1,0)(2,1)(2,2)" : (CM,1),
    "(0,0)(1,4)(2,5)(2,6)" : (CM,1),
    "(0,0)(2,2)(1,4)(2,5)" : (CM,2),
    "(0,0)(2,1)(2,2)(1,4)" : (CM,3),
    
    "(0,0)(0,1)(1,2)(0,4)" : (Cm,0),
    "(0,0)(1,2)(0,4)(0,5)" : (Cm,0),
    "(0,0)(0,4)(0,5)(1,6)" : (Cm,0),
    "(0,0)(0,3)(1,5)(0,7)" : (Cm,1),
    "(0,0)(-1,2)(-1,3)(0,4)" : (Cm,1),
    "(0,0)(-1,3)(0,4)(-1,6)" : (Cm,3),
    "(0,0)(0,4)(-1,6)(-1,7)" : (Cm,2),
    
    "(0,0)(1,1)(1,2)(1,3)" : (C7,0),
    "(0,0)(1,3)(1,5)(1,6)" : (C7,0),
    "(0,0)(1,1)(1,3)(0,4)" : (C7,0),
    "(0,0)(0,3)(-1,5)(0,6)" : (C7,2),
    "(0,0)(-1,3)(0,5)(0,6)" : (C7,1),
    "(0,0)(-1,2)(0,3)(0,5)" : (C7,1),
    "(0,0)(0,3)(0,5)(-1,6)" : (C7,3),
    "(0,0)(-1,1)(0,2)(0,3)" : (C7,1),
    "(0,0)(0,1)(-1,2)(0,3)" : (C7,2),
    
    "(0,0)(1,1)(1,2)(2,3)" : (C7M,0),
    "(0,0)(2,3)(1,5)(1,6)" : (C7M,0),
    "(0,0)(1,2)(2,3)(1,5)" : (C7M,0),
    "(0,0)(-1,3)(0,5)(1,6)" : (C7M,1),
    "(0,0)(-1,2)(0,3)(1,5)" : (C7M,1),
    "(0,0)(0,3)(1,5)(-1,6)" : (C7M,3),
    "(0,0)(-1,2)(1,5)(0,7)" : (C7M,1),
    "(0,0)(-1,4)(1,5)(1,6)" : (C7M,0),
    
    "(0,0)(0,1)(1,2)(1,3)" : (Cm7,0),
    "(0,0)(1,3)(0,5)(1,6)" : (Cm7,0),
    "(0,0)(0,3)(-1,5)(-1,6)" : (Cm7,2),
    "(0,0)(1,2)(1,3)(0,5)" : (Cm7,0),
    "(0,0)(-1,2)(-1,3)(0,5)" : (Cm7,1),
    "(0,0)(0,1)(1,3)(0,4)" : (Cm7,0),
    

    "(0,0)(0,1)(0,2)(0,3)" : (Cdim,0),
    "(0,0)(0,3)(0,5)(0,6)" : (Cdim,0),
//    "(0,0)(0,5)(0,6)(0,7)" : (Cdim,0),
    
    "(0,0)(0,1)(0,2)(1,3)" : (Cm7b5,0),
//    "(0,0)(0,5)(0,6)(1,7)" : (Cm7b5,0),
    "(0,0)(1,3)(0,5)(0,6)" : (Cm7b5,0),

    "(0,0)(0,1)(1,3)(2,4)" : (Cm79,0),
    
    "(0,0)(1,3)(1,5)(0,7)" : (C713,0),
    
    "(0,0)(1,3)(1,5)(2,6)" : (C7b13,0),

    "(0,0)(1,3)(2,4)(1,5)" : (C79,0),
    "(0,0)(1,1)(1,3)(2,4)" : (C79,0),

    "(0,0)(1,3)(1,4)(1,5)" : (C7b9,0),
    "(0,0)(1,1)(1,3)(1,4)" : (C7b9,0),

    "(0,0)(0,1)(1,3)(2,5)" : (Cm711,0),
    "(0,0)(1,3)(0,5)(-1,6)" : (Cm711,0),

    "(0,0)(1,3)(2,4)(2,5)" : (C749,0),
    "(0,0)(2,1)(1,3)(2,4)" : (C749,0),

    "(0,0)(1,3)(1,5)(0,6)" : (C7a11,0),

    "(0,0)(1,3)(2,5)(3,6)" : (C71113,0),

    "(0,0)(2,3)(1,5)(0,6)" : (C7Ma11,0),
    "(0,0)(-1,4)(1,5)(0,6)" : (C7Ma11,0),

    "(0,0)(1,1)(0,3)(-1,5)" : (C69,0),
    "(0,0)(-2,2)(0,3)(-1,5)" : (C69,0),
    "(0,0)(0,3)(-1,5)(-2,6)" : (C69,0),
    "(0,0)(0,3)(2,4)(1,5)" : (C69,0),
    "(0,0)(2,1)(2,2)(1,3)" : (C69,2),
    "(0,0)(2,4)(1,5)(0,7)" : (C69,0),
    "(0,0)(2,4)(1,5)(1,6)(0,7)" : (C69,0),

    "(0,0)(-1,2)(-1,3)(-2,4)" : (C69,2),
//    "(0,0)(2,5)(2,6)(1,7)" : (C69,2),
    "(0,0)(0,3)(-1,5)(-1,6)(-2,7)" : (C69,3),
    "(0,0)(-1,2)(0,3)(-1,5)(-2,7)" : (C69,1),
    "(0,0)(2,4)(2,5)(1,6)(0,7)" : (C69,2),

    "(0,0)(1,1)(2,2)(2,3)" : (C7Ma5,0),
    "(0,0)(2,2)(2,3)(1,5)" : (C7Ma5,0),
    "(0,0)(2,3)(1,5)(2,6)" : (C7Ma5,0),
    "(0,0)(-1,3)(1,5)(1,6)" : (C7Ma5,1),

    "(0,0)(1,1)(1,3)(0,5)" : (C7a9,0),
//    "(0,0)(1,5)(1,7)(0,9)" : (C7a9,0),

    "(0,0)(1,1)(2,3)(2,4)" : (C7M9,0),
    "(0,0)(1,2)(2,3)(2,4)(1,5)" : (C7M9,0),
    "(0,0)(2,3)(2,4)(1,5)" : (C7M9,0),
    "(0,0)(1,1)(1,2)(2,3)(2,4)" : (C7M9,0),
    "(0,0)(-1,3)(0,5)(1,6)(1,7)" : (C7M9,1),
    "(0,0)(-1,3)(1,6)(1,7)" : (C7M9,1),
    "(0,0)(-1,2)(0,3)(1,5)(1,6)" : (C7M9,1),
    
    "(0,0)(1,1)(1,2)(0,3)" : (C6,0),
    "(0,0)(0,3)(1,5)(1,6)" : (C6,0),
    "(0,0)(1,1)(0,3)(0,4)" : (C6,0),
    "(0,0)(-1,3)(0,5)(-1,6)" : (C6,1),
    "(0,0)(-1,2)(0,3)(-1,5)" : (C6,1),
    "(0,0)(0,3)(0,4)(1,5)" : (C6,0),
    "(0,0)(1,2)(0,3)(1,5)" : (C6,0),
 //   "(0,0)(-1,6)(0,7)(-1,9)" : (C6,1),

    "(0,0)(0,1)(1,2)(0,3)" : (Cm6,0),
    "(0,0)(0,3)(0,5)(1,6)" : (Cm6,0),
    "(0,0)(0,4)(0,5)(0,7)" : (Cm6,0),
//    "(0,0)(0,5)(1,6)(0,7)" : (Cm6,0),
    "(0,0)(0,1)(0,3)(0,4)" : (Cm6,0),
    "(0,0)(0,3)(1,5)(0,6)" : (Cm6,1),
    "(0,0)(-1,2)(-1,3)(-1,5)" : (Cm6,1),
    "(0,0)(-1,1)(-1,2)(-1,3)" : (Cm6,2),
    "(0,0)(0,3)(0,4)(0,5)" : (Cm6,0),
//    "(0,0)(-1,5)(-1,6)(-1,7)" : (Cm6,2),

    
    "(0,0)(0,1)(0,3)(-1,5)" : (Cm69,0),
    "(0,0)(0,1)(0,3)(0,4)(-1,5)" : (Cm69,0),
    "(0,0)(0,2)(0,3)(-1,4)" : (Cm69,2),
//    "(0,0)(0,6)(0,7)(-1,8)" : (Cm69,2),
    "(0,0)(0,3)(-1,4)(0,6)" : (Cm69,1),
    "(0,0)(-1,4)(0,6)(0,7)" : (Cm69,3),
    "(0,0)(-1,2)(-1,3)(-1,5)(-2,7)" : (Cm69,1),

    "(0,0)(1,3)(2,5)(1,6)" : (C47,0),
    "(0,0)(2,1)(1,3)(0,4)" : (C47,0),
    
    "(0,0)(1,2)(2,4)(1,5)" : (C9,0),
    "(0,0)(2,4)(1,5)(1,6)" : (C9,0),
    "(0,0)(1,1)(1,2)(2,4)" : (C9,0),
    "(0,0)(-1,2)(0,3)(1,6)" : (C9,1),
    "(0,0)(-1,3)(0,5)(1,7)" : (C9,1),

    "(0,0)(0,1)(1,3)(1,4)" : (Cm7b9,0),
    "(0,0)(1,3)(1,4)(0,5)" : (Cm7b9,0),
    
    "(0,0)(1,1)(0,3)(2,3)" : (C7M6,0),
    "(0,0)(0,3)(2,3)(1,5)" : (C7M6,0),
    "(0,0)(0,3)(1,5)(2,7)" : (C7M6,0),
    "(0,0)(1,1)(0,3)(-1,4)" : (C7M6,0),
    
    "(0,0)(1,1)(3,2)(2,3)(2,4)" : (C7M69,0),
    "(0,0)(1,1)(0,3)(-1,4)(-1,5)" : (C7M69,0),
    "(0,0)(0,3)(-1,4)(-1,5)(-2,6)" : (C7M69,0),
    "(0,0)(3,2)(2,3)(2,4)(1,5)" : (C7M69,0),
    "(0,0)(-2,2)(0,3)(-1,4)(-1,5)" : (C7M69,0),
    
    "(0,0)(2,3)(2,4)(1,5)(0,6)" : (C7M9a11,0),
    
    "(0,0)(0,3)(-1,5)(-2,6)(-3,7)" : (C69a11,0),
    "(0,0)(0,3)(2,4)(1,5)(0,6)" :(C69a11,0),
    
    "(0,0)(1,1)(2,2)(3,3)" : (Ca5,0),
    "(0,0)(1,1)(2,2)(0,4)" : (Ca5,0),
    "(0,0)(-2,2)(-1,3)(0,4)" : (Ca5,0),
    "(0,0)(-1,3)(0,4)(1,5)" : (Ca5,0),
    "(0,0)(0,4)(1,5)(2,6)" : (Ca5,0),
//    "(0,0)(1,5)(2,6)(3,7)" : (Ca5,0),
 
    "(0,0)(0,1)(1,3)(2,4)(2,5)" : (Cm7911,0),
    
    "(0,0)(0,1)(0,3)(-1,5)(-1,6)" : (Cm6911,0),
    
    "(0,0)(0,1)(1,2)(2,3)" : (Cm7M,0),
//    "(0,0)(0,5)(1,6)(2,7)" : (Cm7M,0),
    "(0,0)(-1,4)(0,5)(1,6)" : (Cm7M,0),
    "(0,0)(-2,3)(-1,4)(0,5)" : (Cm7M,0),
    "(0,0)(1,2)(2,3)(3,4)" : (Cm7M,0),
    "(0,0)(2,3)(3,4)(4,5)" : (Cm7M,0),
    
    "(0,0)(0,1)(1,2)(2,3)(2,4)" : (Cm7M9,0),
//    "(0,0)(0,5)(1,6)(2,7)(2,8)" : (Cm7M9,0),
    "(0,0)(0,1)(2,3)(2,4)" : (Cm7M9,0),
    "(0,0)(0,1)(-1,4)(-1,5)" : (Cm7M9,0),

    
    "(0,0)(0,1)(0,3)(-1,4)" : (Cm7M6,0),
//    "(0,0)(0,5)(0,7)(-1,8)" : (Cm7M6,0),
    "(0,0)(0,3)(-1,4)(0,5)" : (Cm7M6,0),
    "(0,0)(-1,4)(0,5)(0,7)" : (Cm7M6,0),
    
    "(0,0)(0,1)(2,3)(2,4)(2,5)" : (Cm7M911,0),
    "(0,0)(0,1)(-1,4)(-1,5)(-1,6)" : (Cm7M911,0),
    
    "(0,0)(0,1)(1,2)(2,4)" : (Cm9,0),
    "(0,0)(0,1)(2,4)(1,6)" : (Cm9,0),
    "(0,0)(1,2)(2,4)(0,5)" : (Cm9,0),
    "(0,0)(2,1)(2,4)(1,5)" : (Cm9,2),
    "(0,0)(-1,2)(-1,5)(-2,6)" : (Cm9,2),
    
    "(0,0)(2,1)(1,2)(0,4)" : (C4,0),
    "(0,0)(1,2)(0,4)(2,5)" : (C4,0),
    "(0,0)(1,2)(0,4)(-1,6)" : (C4,0),
    "(0,0)(1,2)(2,5)(1,6)" : (C4,0),
    "(0,0)(-1,2)(0,4)(1,6)" : (C4,0),
    "(0,0)(0,4)(2,5)(1,6)" : (C4,0),
    //"(0,0)(-1,2)(0,4)(1,5)" : (C4,0),
    //"(0,0)(-1,2)(0,4)(1,5)(1,6)" : (C4,0),
    //"(0,0)(2,1)(1,2)(1,5)" : (C4,0),
    
    "(0,0)(1,3)(2,4)(1,5)(0,7)" : (C7913,0),
    
    "(0,0)(1,3)(2,4)(1,5)(0,6)" : (C79a11,0),
    
    "(0,0)(1,3)(1,5)(0,6)(0,7)" : (C7a1113,0),
    
    "(0,0)(0,2)(1,3)(1,5)" : (C7b5,0),
    "(0,0)(1,1)(0,2)(1,3)" : (C7b5,0),
//    "(0,0)(1,5)(0,6)(1,7)" : (C7b5,0),
    
    "(0,0)(1,1)(2,2)(1,3)" : (C7a5,0),
//    "(0,0)(1,5)(2,6)(1,7)" : (C7a5,0),
    "(0,0)(2,2)(1,3)(1,5)" : (C7a5,0),
    
    "(0,0)(2,2)(2,4)(1,5)(1,7)" : (C7a59,0),
    "(0,0)(1,1)(2,2)(1,3)(2,4)" : (C7a59,0),
    "(0,0)(2,2)(1,3)(2,4)(1,5)" : (C7a59,0),

    "(0,0)(0,2)(1,3)(2,4)(1,5)" : (C7b59,0),
    
    "(0,0)(1,3)(1,4)(1,5)(0,7)" : (C7b913,0),
    
    "(0,0)(2,2)(1,3)(1,4)(1,5)" : (C7a5b9,0),
    "(0,0)(1,1)(2,2)(1,3)(1,4)" : (C7a5b9,0),
    
    "(0,0)(1,1)(2,2)(1,3)(0,5)" : (C7a5a9,0),

    "(0,0)(0,2)(1,3)(1,4)(1,5)" : (C7b5b9,0),
    
    "(0,0)(1,1)(0,2)(1,3)(0,5)" : (C7b5a9,0),
    
    "(0,0)(1,3)(2,4)(2,5)(3,6)" : (C47913,0),
    
    "(0,0)(2,1)(1,3)(1,4)" : (C47b9,0),
    "(0,0)(1,3)(1,4)(2,5)" : (C47b9,0),

    "(0,0)(0,1)(0,2)(1,3)(-1,5)" : (Cm7b59,0),
    "(0,0)(0,1)(0,2)(1,3)(2,4)" : (Cm7b59,0),
    
    "(0,0)(1,3)(1,4)(1,5)(2,6)" : (C7b9b13,0),
    
    "(0,0)(1,3)(1,4)(1,5)(0,6)" : (C7b9a11,0),

    "(0,0)(1,1)(1,3)(0,5)(0,6)" : (C7a9a11,0),
    
    "(0,0)(0,1)(1,2)(-1,3)" : (Cmb6,0),
    "(0,0)(0,4)(0,5)(-1,7)" : (Cmb6,0),

    "(0,0)(0,1)(1,2)(-2,3)" : (Cm5,0),
    
    "(0,0)(0,3)(0,5)(0,6)(-1,7)" : (Cdimb13,0),
    
    "(0,0)(0,1)(0,2)(0,3)(-1,4)" : (Cdim7M,0),
    "(0,0)(0,3)(0,5)(0,6)(-1,8)" : (Cdim7M,0),

    "(0,0)(0,1)(0,2)(0,3)(-1,5)" : (Cdim9,0),
    "(0,0)(0,1)(0,3)(-1,5)(0,6)" : (Cdim9,0),
    
    "(0,0)(0,2)(0,3)(0,5)(-1,6)" : (Cdim11,0),
    "(0,0)(1,2)(0,4)(-1,5)" : (C59,0),

]

let incompletePositionTable : [String : (ChordType,Int,[(Int,Int)])] = [
    "(0,0)(0,3)(-1,4)(-1,5)" : (C7M69,0,[(-2,2)]),
    "(0,0)(0,3)(0,4)(-1,5)" : (C69,0,[(-2,2)]),
    "(0,0)(2,2)(2,4)(1,5)" : (C7a59,0,[(1,3)]),
    "(0,0)(1,3)(0,4)(1,5)" : (C7,0,[(1,2)]),
    "(0,0)(-1,4)(-1,5)(0,6)" : (C7M9a11,0,[(1,5)]),
    "(0,0)(2,3)(2,4)(3,5)" : (C7M9a11,0,[(1,5)]),
    "(0,0)(0,1)(0,3)(-1,6)" : (Cm6911,0,[(-1,5)]),
    "(0,0)(-1,4)(-1,5)(-1,6)" : (Cm7M911,0,[(0,1)]),
    "(0,0)(1,3)(2,4)(3,6)" : (C7913,0,[(1,1)]),
    "(0,0)(0,2)(2,4)(1,5)" : (C7b59,0,[(1,3)]),
    "(0,0)(0,2)(1,3)(2,4)" : (C7b59,0,[(1,5)]),
    "(0,0)(1,4)(1,5)(0,7)" : (C7b913,0,[(1,3)]),
    "(0,0)(1,1)(2,2)(1,4)" : (C7a5b9,0,[(1,3)]),
    "(0,0)(2,2)(1,3)(1,4)" : (C7a5b9,0,[(1,1)]),
    "(0,0)(2,2)(1,4)(1,5)" : (C7a5b9,0,[(1,3)]),
    "(0,0)(1,2)(1,4)(0,6)" : (C7a5b9,0,[(1,1),(1,3)]),
    "(0,0)(1,1)(2,2)(0,5)" : (C7a5a9,0,[(1,3)]),
    "(0,0)(1,1)(2,2)(3,4)" : (C7a5a9,0,[(1,3)]),
    "(0,0)(0,2)(1,4)(1,5)" : (C7b5b9,0,[(1,3)]),
    "(0,0)(0,2)(1,3)(1,4)" : (C7b5b9,0,[(1,5)]),
    "(0,0)(0,2)(1,3)(0,5)" : (C7b5a9,0,[(1,1)]),
    "(0,0)(-1,1)(-1,2)(0,3)" : (C47913,0,[(1,-1)]),
    "(0,0)(2,4)(2,5)(3,6)" : (C47913,0,[(1,3)]),
    "(0,0)(1,2)(1,4)(1,5)" : (C7b9,0,[(1,3)]),
    "(0,0)(1,4)(1,5)(1,6)" : (C7b9,0,[(1,3)]),
    "(0,0)(1,2)(1,4)(0,5)" : (C7a9,0,[(1,1),(1,3)]),
    "(0,0)(0,4)(0,5)(-1,6)" : (Cm711,0,[(1,3)]),
    "(0,0)(1,4)(0,6)(0,7)" : (C7b9a1113,0,[(1,1),(1,3)]),
    "(0,0)(0,1)(0,2)(-1,5)" : (Cm7b59,0,[(1,3)]),
    "(0,0)(0,1)(0,2)(2,4)" : (Cm7b59,0,[(1,3)]),
    "(0,0)(1,4)(1,5)(2,6)" : (C7b9b13,0,[(1,3)]),
    "(0,0)(1,1)(0,5)(0,6)" : (C7a9a11,0,[(1,3)]),
    "(0,0)(2,4)(1,5)(0,6)" : (C79a11,0,[(1,3)]),
    //    "(0,0)(1,1)(2,3)(2,4)" : (C7M9,0,[(1,2)])
]

class Position {
    var chord : ChordType
    var keys : [(Int,Int)]
    var extraKeys : [(Int,Int)]
    var root : Int
    init(chord: ChordType, keys: [(Int,Int)], extraKeys : [(Int,Int)], root : Int) {
        self.chord = chord
        self.keys = keys
        self.extraKeys = extraKeys
        self.root = root
    }
}

var allPositions : [Position] = []

func parseKeys(keys : String) -> [(Int,Int)] {
    let woutlast = String(keys.characters.dropLast())
    let woutfirst = String(woutlast.characters.dropFirst())
    let akeys = woutfirst.componentsSeparatedByString(")(")
    var result : [(Int,Int)] = []
    for i in akeys {
        let p=i.componentsSeparatedByString(",")
        let pa : (Int,Int) = (Int(p[0])!,Int(p[1])!)
        result.append(pa)
    }
    return result
}

func fillAllPositions() {
    for (k,t) in positionTable {
        allPositions.append(Position(chord: t.0, keys: parseKeys(k), extraKeys: [], root: t.1))
    }
    for (k,t) in incompletePositionTable {
        allPositions.append(Position(chord: t.0, keys: parseKeys(k), extraKeys: t.2, root: t.1))
    }
    allPositions.sortInPlace { $0.0.chord.symbol < $0.1.chord.symbol }
}
