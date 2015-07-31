//
//  MusicUtil.swift
//  MinorThirds
//
//  Created by Vinicius Mello on 03/07/15.
//  Copyright (c) 2015 Vinicius Mello. All rights reserved.
//

func noteName(note: Int) -> String {
    let notesFlat = ["C","Db","D","Eb","E","F","Gb","G","Ab","A","Bb","B"]
    let notesSharp = ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B"]
    let notesMixed = ["C","C#","D","Eb","E","F","F#","G","Ab","A","Bb","B"]
    switch accidental {
    case 0:
        return notesFlat[note % 12]
    case 1:
        return notesSharp[note % 12]
    case 2:
        return notesMixed[note % 12]
    default:
        println("Error noteName")
    }
    return "err"
}

func midiToName(note : Int) -> String {
    let oct : Int = note/12 - 1
    if note <= 0 {
        return "n/a"
    } else {
        return noteName(note % 12)+"\(oct)"
    }
}

func blackNote(i : Int) -> Bool {
    let r = i % 12
    switch r {
    case 1, 3, 6, 8, 10:
        return true
    default:
        return false
    }
}

func addCombo(prevCombo: [Int], var pivotList: [Int]) -> [([Int], [Int])] {
    
    return (0..<pivotList.count)
        .map {
            _ -> ([Int], [Int]) in
            (prevCombo + [pivotList.removeAtIndex(0)], pivotList)
    }
}

func combosOfLength(n: Int, m: Int) -> [[Int]] {
    
    return [Int](1...m)
        .reduce([([Int](), [Int](0..<n))]) {
            (accum, _) in
            accum.flatMap(addCombo)
        }.map {
            $0.0
    }
}

func chordScale(chord : ChordType, numNotes : Int) -> [[Bool]] {
    var tones : [Bool] = [Bool](count: 12, repeatedValue: false)
    for i in chord.tones {
        tones[i%12]=true
    }
    var nonTones : [Int] = []
    for i in 0..<12 {
        if !tones[i] {
            nonTones.append(i)
        }
    }
    let m : Int = numNotes - chord.tones.count
    let n : Int = nonTones.count
    if m<0 || n<m {
        return []
    }
    let combos = combosOfLength(n,m)
    var scales : [[Bool]] = []
    var minTritones : Int = 100
    var minSemi : Int = 100
    for comb in combos {
        for i in comb {
            tones[nonTones[i]]=true
        }
        var numberOfTritones : Int = 0
        var numberOfSemi : Int = 0
        for i in 0..<12 {
            if tones[i] {
                if tones[(i+6)%12] {
                    numberOfTritones = numberOfTritones + 1
                }
                if tones[(i+1)%12] {
                    numberOfSemi = numberOfSemi + 1
                }
            }
        }
        numberOfTritones = numberOfTritones / 2
        if numberOfSemi<minSemi {
            scales.removeAll(keepCapacity: true)
            scales.append(tones)
            minSemi=numberOfSemi
            minTritones=numberOfTritones
        } else if numberOfSemi==minSemi {
            if numberOfTritones<minTritones {
                scales.removeAll(keepCapacity: true)
                scales.append(tones)
                minTritones=numberOfTritones
            } else if numberOfTritones==minTritones {
                scales.append(tones)
            }
        }
        for i in comb {
            tones[nonTones[i]]=false
        }
    }
    return scales
}