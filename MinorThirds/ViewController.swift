//
//  ViewController.swift
//  MinorThirds
//
//  Created by Vinicius Mello on 01/07/15.
//  Copyright (c) 2015 Vinicius Mello. All rights reserved.
//

import QuartzCore
import CoreMIDI
import UIKit

struct ColorScheme {
    var C : CGColor
    var CFG : CGColor
    var BlackNote : CGColor
    var BlackNoteFG : CGColor
    var WhiteNote : CGColor
    var WhiteNoteFG : CGColor
    var Background : CGColor
}

let colorC = UIColor(rgba: "#FF9933").CGColor
let colorCFG = UIColor.whiteColor().CGColor
let colorBlackNote = UIColor(rgba: "#614051").CGColor // Eggplant
let colorBlackNoteFG = UIColor.whiteColor().CGColor
let colorWhiteNote = UIColor(rgba: "#FFFFF0").CGColor // Ivory
let colorWhiteNoteFG = UIColor.blackColor().CGColor

let colorSchemes : [String : ColorScheme] = [
    "Rose" : ColorScheme(
        C: UIColor(rgba: "#F1D4AF").CGColor
,
        CFG: UIColor(rgba: "#774F38").CGColor,
        BlackNote: UIColor(rgba: "#E08E79").CGColor,
        BlackNoteFG: UIColor(rgba: "#C5E0DC").CGColor,
        WhiteNote: UIColor(rgba: "#ECE5CE").CGColor,
        WhiteNoteFG: UIColor(rgba: "#E08E79").CGColor,
        Background: UIColor(rgba: "#774F38").CGColor
    ),
    "Green" : ColorScheme(
        C: UIColor(rgba: "#7C8A79").CGColor
        ,
        CFG: UIColor(rgba: "#FEFEFC").CGColor,
        BlackNote: UIColor(rgba: "#537B85").CGColor,
        BlackNoteFG: UIColor(rgba: "#FEFEFC").CGColor,
        WhiteNote: UIColor(rgba: "#C3D1D1").CGColor,
        WhiteNoteFG: UIColor(rgba: "#3C5760").CGColor,
        Background: UIColor(rgba: "#210A02").CGColor
    )
]

let allNotes = [Bool](count: 12, repeatedValue: true)

var midi = VirtualSourceMidi("MinorThirds")

var gridWidth : Int = 12
var gridHeight : Int = 9
var baseMidiNote : Int = 36
var minVel : CGFloat = 64
var maxVel : CGFloat = 110
var fillIncompletePositions : Bool = true
var autoSustain : Bool = true
var currentColorScheme : String = "Rose"
var accidental : Int = 0
var transposition : Int = 0
var midiChannel : UInt8 = 0


class ViewController: UIViewController {

    var extraKeys : [(Int,Int)] = []
    var incompletePosition : Bool = false
    var lastVel : UInt8 = 0
    var grid : [[CATextLayer]]?
    var width : CGFloat = 0.0
    var height : CGFloat = 0.0
    var noteWidth : CGFloat = 0.0
    var noteHeight : CGFloat = 0.0
    var notesCount : Int = 0
    var activeKeys : [UITouch : (Int,Int)] = [:]
    var currentChord : ChordType? = nil
    var currentRoot : Int = 0
    var currentBass : Int = 0
    var currentScale : [Bool] = allNotes
    var chordLabel : CATextLayer = CATextLayer()
    var pedalLabel : CALayer = CALayer()
    var chordLabelShadow : CATextLayer = CATextLayer()
    var pedalOn : Bool = false
    var activeNotes : [Bool] = [Bool](count: 128, repeatedValue: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarHidden = true
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let defaultGridHeight = defaults.objectForKey("gridHeight") as? Int {
            gridHeight = defaultGridHeight
        }
        if let defaultGridWidth = defaults.objectForKey("gridWidth") as? Int {
            gridWidth = defaultGridWidth
        }
        if let defaultBaseMidiNote = defaults.objectForKey("baseMidiNote") as? Int {
            baseMidiNote = defaultBaseMidiNote
        }
        if let defaultMinVel = defaults.objectForKey("minVel") as? Float {
            minVel = CGFloat(defaultMinVel)
        }
        if let defaultMaxVel = defaults.objectForKey("maxVel") as? Float {
            maxVel = CGFloat(defaultMaxVel)
        }
        if let defaultColorScheme = defaults.objectForKey("colorScheme") as? String {
            currentColorScheme = defaultColorScheme
        }
        if let defaultAutoSustain = defaults.objectForKey("autoSustain") as? Bool {
            autoSustain = defaultAutoSustain
        }
        if let defaultIncompleteChords = defaults.objectForKey("incompleteChords") as? Bool {
            fillIncompletePositions = defaultIncompleteChords
        }
        if let defaultAccidental = defaults.objectForKey("accidental") as? Int {
            accidental = defaultAccidental
        }
        if let defaultTransposition = defaults.objectForKey("transposition") as? Int {
            transposition = defaultTransposition
        }
        if let defaultMidiChannel = defaults.objectForKey("midiChannel") as? Int {
            midiChannel = UInt8(defaultMidiChannel)
        }
        
        setupGrid()
        showGrid()
        setupNotes()
        
        let l = self.view.layer
        l.backgroundColor = colorSchemes[currentColorScheme]?.Background
        l.addSublayer(chordLabelShadow)
        chordLabelShadow.frame = CGRectMake(53,52,900,300)
        chordLabelShadow.fontSize = 108
        chordLabelShadow.string = ""
        chordLabelShadow.alignmentMode = kCAAlignmentLeft
        chordLabelShadow.backgroundColor = UIColor.clearColor().CGColor
        chordLabelShadow.foregroundColor = UIColor.blackColor().CGColor
        chordLabelShadow.opacity = 0.9
        l.addSublayer(chordLabel)
        chordLabel.frame = CGRectMake(50,50,900,300)
        chordLabel.fontSize = 108
        chordLabel.string = ""
        chordLabel.alignmentMode = kCAAlignmentLeft
        chordLabel.backgroundColor = UIColor.clearColor().CGColor
        chordLabel.foregroundColor = UIColor.whiteColor().CGColor
        chordLabel.opacity = 1.0
        
        let pedalImage = UIImage(named: "Pedal.png")!
        //println(pedalImage)
        pedalLabel.contents = pedalImage.CGImage!
        pedalLabel.frame = CGRectMake(860,86,90,59)
        pedalLabel.opacity=1.0
        pedalLabel.hidden = true
        //pedalLabel.backgroundColor = UIColor.redColor().CGColor
        l.addSublayer(pedalLabel)
    }
    
    func setupGrid() {
        var gi = [[CATextLayer]]()
        for i in 0..<16 {
            var gj = [CATextLayer]()
            for j in 0..<16 {
                let g = CATextLayer()
                self.view.layer.addSublayer(g)
                gj.append(g)
            }
            gi.append(gj)
        }
        grid = gi
    }

    func showGrid() {
        for i in 0..<16 {
            for j in 0..<16 {
                if i<gridHeight && j<gridWidth {
                    grid![i][j].hidden = false
                } else {
                    grid![i][j].hidden = true
                }
            }
        }
    }
    
    func setupNotes() {
        let l = self.view.layer
        l.backgroundColor = colorSchemes[currentColorScheme]?.Background
        width = self.view.bounds.width
        height = self.view.bounds.height
        noteWidth = floor(width/CGFloat(gridWidth))
        noteHeight = floor(height/CGFloat(gridHeight))
        
        let colorC = colorSchemes[currentColorScheme]?.C
        let colorCFG = colorSchemes[currentColorScheme]?.CFG
        let colorBlackNote = colorSchemes[currentColorScheme]?.BlackNote
        let colorBlackNoteFG = colorSchemes[currentColorScheme]?.BlackNoteFG
        let colorWhiteNote = colorSchemes[currentColorScheme]?.WhiteNote
        let colorWhiteNoteFG = colorSchemes[currentColorScheme]?.WhiteNoteFG
        
        for i in 0..<gridHeight {
            for j in 0..<gridWidth {
                let g=grid![i][j]
                g.frame = CGRectMake(CGFloat(j)*noteWidth+2.0,  CGFloat(gridHeight-1-i)*noteHeight+2.0, noteWidth,  noteHeight)
                let m = midiNote(i,j)
                g.string = midiToName(m)
                g.fontSize = 20
                
                if blackNote(m) {
                    g.backgroundColor = colorBlackNote
                    g.foregroundColor = colorBlackNoteFG
                } else if m%12 == 0 {
                    g.backgroundColor = colorC
                    g.foregroundColor = colorCFG
                } else {
                    g.backgroundColor = colorWhiteNote
                    g.foregroundColor = colorWhiteNoteFG
                }
                g.borderWidth = 1.0
                g.borderColor = UIColor.blackColor().CGColor
                g.alignmentMode = kCAAlignmentCenter
                //g.opaque = true
            }
        }
    }

    func generateGrid() {
        setupNotes()
        showGrid()
    }
    
    func midiNote( i : Int, _ j : Int) -> Int {
        return 3*j+i+baseMidiNote
    }
    
    func locationToGrid(pt : CGPoint) -> (Int,Int) {
        var j : Int = Int((pt.x-2.0)/noteWidth)
        var i : Int = gridHeight-1-Int((pt.y-2.0)/noteHeight)
        i = min(max(0,i),gridHeight-1)
        j = min(max(0,j),gridWidth-1)
        return (i,j)
    }
    
    func locationToVel(pt : CGPoint) -> UInt8 {
        let i : Int = gridHeight-1-Int((pt.y-2.0)/noteHeight)
        let vel = (noteHeight-(pt.y-CGFloat(gridHeight-1-i)*noteHeight+2.0))/noteHeight
        return UInt8(minVel+(maxVel-minVel)*vel)
    }
    
    func pressPedal() {
        if autoSustain {
            if !pedalOn {
                midi.sendBytes([0xB0|midiChannel,0x40,0x40])
                pedalOn = true
                pedalLabel.hidden = false
            } else {
                midi.sendBytes([0xB0|midiChannel,0x40,0x00])
                pedalLabel.hidden = true
                midi.sendBytes([0xB0|midiChannel,0x40,0x40])
                pedalLabel.hidden = false
            }
        }
    }
    
    func releasePedal() {
        if autoSustain {
            if pedalOn {
                midi.sendBytes([0xB0|midiChannel,0x40,0x00])
                pedalOn = false
                pedalLabel.hidden = true
            }
        }
    }
    
    func pressKey(i : Int, _ j : Int, _ vel : UInt8) {
        let m = midiNote(i, j)
        if (i>=0 && i<gridHeight) && (j>=0 && j<gridWidth) {
            grid![i][j].opacity = 0.5
        }
        if activeNotes[m] {
            midiNoteOff(m)
        } else {
            activeNotes[m]=true
        }
        midiNoteOn(m,vel)
    }

    func releaseKey(i : Int, _ j : Int) {
        let m = midiNote(i, j)
        if (i>=0 && i<gridHeight) && (j>=0 && j<gridWidth) {
            grid![i][j].opacity = 1.0
        }
        if activeNotes[m] {
            midiNoteOff(m)
            activeNotes[m]=false
        }
    }
    
    func isScaleNote(m : Int) -> Bool {
        return currentScale[(m+(12-currentRoot))%12]
    }
    
    func midiNoteOn(m : Int, _ vel : UInt8) {
            //println("midi on: \(midiToName(m)),\(vel)")
        midi.sendBytes([0x90|midiChannel,UInt8(m+transposition),vel])
        lastVel = vel
    }
    
    func midiNoteOff(m : Int) {
            //println("midi off: \(midiToName(m))")
        midi.sendBytes([0x80|midiChannel,UInt8(m+transposition),0])
    }
    
    func activateChord() {
        let chordName = currentChord!.format(currentRoot, bass: currentBass)
        //println(chordName)
        chordLabelShadow.string = chordName
        chordLabel.string = chordName
        pressPedal()
        //            println(currentScale)
        //            blockScaleNotes()

    }
    
    func releaseChord() {
        if fillIncompletePositions {
            for k in extraKeys {
                let (i,j)=k
                releaseKey(i,j)
            }
        }
        extraKeys = []
        releasePedal()
        currentChord = nil
        //            currentScale = allNotes
        chordLabel.string = ""
        chordLabelShadow.string = ""
        //            unblockScaleNotes()
    }

    func pressExtraKeys() {
        for k in extraKeys {
            let (i,j)=k
            pressKey(i,j,lastVel)
        }
    }
    
    func releaseExtraKeys() {
        for k in extraKeys {
            let (i,j)=k
            releaseKey(i,j)
        }
        extraKeys = []
    }
    
    func detectedChord() {
        if activeKeys.count>=4 {
            if identifyChord() {
                if incompletePosition {
                    pressExtraKeys()
                } else {
                    releaseExtraKeys()
                }
                activateChord()
            }
        }
    }
    
    func identifyChord() -> Bool {
        var keys : [(Int,Int)] = []
        for (t,k) in activeKeys {
            keys.append(k)
        }
        keys.sort { $0.1 == $1.1 ? $0.0 < $1.0 : $0.1 < $1.1 }
        var strKeys : String = ""
        let bass = keys[0]
        if (keys[1].1-bass.1)>4 {
            keys[0].1=(keys[0].1)+4
        }
        for k in keys {
            strKeys = strKeys+"(\(k.0-keys[0].0),\(k.1-keys[0].1))"
        }
        println(strKeys)
        incompletePosition = false
        if fillIncompletePositions {
            if let incompleteChord = incompletePositionTable[strKeys] {
                currentChord = incompleteChord.0
                let (ri,rj) = keys[incompleteChord.1]
                currentRoot = midiNote(ri,rj) % 12
                currentBass = midiNote(bass.0,bass.1) % 12
                incompletePosition = true
                for k in incompleteChord.2 {
                    var (ki,kj)=k
                    ki=keys[0].0+ki
                    kj=keys[0].1+kj
                    let nk : (Int,Int) = (ki,kj)
                    extraKeys.append(nk)
                }
                return true
            }
        }
        if let chord = positionTable[strKeys] {
            currentChord = chord.0
            let (ri,rj) = keys[chord.1]
            currentRoot = midiNote(ri,rj) % 12
            currentBass = midiNote(bass.0,bass.1) % 12
            //currentScale = chordScale(currentChord!,7)[0]
            return true
        } else {
            currentChord = nil
            currentRoot = 0
            currentBass = 0
            currentScale = allNotes
//            unblockScaleNotes()
            return false
        }
    }
    
    func blockScaleNotes() {
        for i in 0..<gridHeight {
            for j in 0..<gridWidth {
                let g=grid![i][j]
                let m = midiNote(i,j)
                if !isScaleNote(m) {
                    g.opacity = 0.0
                }
            }
        }
    }
    
    func unblockScaleNotes() {
        for i in 0..<gridHeight {
            for j in 0..<gridWidth {
                let g=grid![i][j]
                let m = midiNote(i,j)
                g.opacity = 1.0
            }
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for t: NSObject in touches {
            let touch = t as? UITouch
            let pt = touch!.locationInView(self.view)
            let (i,j) = locationToGrid(pt)
            let vel = locationToVel(pt)
            activeKeys[touch!]=(i,j)
            pressKey(i,j,vel)
        }
        detectedChord()
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        for t: NSObject in touches {
            let touch = t as? UITouch
            //let pt = touch!.locationInView(self.view)
            let (i,j) = activeKeys[touch!]!
            activeKeys[touch!]=nil
            releaseKey(i,j)
        }
        let count = activeKeys.count
        if count == 0 {
            releaseChord()
        } else {
            if incompletePosition {
                releaseExtraKeys()
            }
            detectedChord()
        }
    }
  
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        var flag = false
        for t: NSObject in touches {
            let touch = t as? UITouch
            let pt = touch!.locationInView(self.view)
            let (i,j) = locationToGrid(pt)
            let (ai,aj) = activeKeys[touch!]!
            if i != ai || j != aj {
                activeKeys[touch!]=nil
                releaseKey(ai,aj)
                activeKeys[touch!]=(i,j)
                pressKey(i,j,86)
                flag = true
            }
        }
        if flag {
            detectedChord()
        }
    }

    override func touchesCancelled(touches: Set<NSObject>, withEvent event: UIEvent) {
        //println("CANCEL")
        for t: NSObject in touches {
            let touch = t as? UITouch
            //let pt = touch!.locationInView(self.view)
            let (i,j) = activeKeys[touch!]!
            activeKeys[touch!]=nil
            releaseKey(i,j)
        }
        if activeKeys.isEmpty {
            releaseChord()
        } else {
            if incompletePosition {
                releaseExtraKeys()
            }
            detectedChord()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

