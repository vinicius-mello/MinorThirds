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
        CFG: UIColor(rgba: "#000000").CGColor,
        BlackNote: UIColor(rgba: "#E08E79").CGColor,
        BlackNoteFG: UIColor(rgba: "#000000").CGColor,
        WhiteNote: UIColor(rgba: "#ECE5CE").CGColor,
        WhiteNoteFG: UIColor(rgba: "#000000").CGColor,
        Background: UIColor(rgba: "#774F38").CGColor
    ),
    "Green" : ColorScheme(
        C: UIColor(rgba: "#7C8A79").CGColor
        ,
        CFG: UIColor(rgba: "#000000").CGColor,
        BlackNote: UIColor(rgba: "#537B85").CGColor,
        BlackNoteFG: UIColor(rgba: "#000000").CGColor,
        WhiteNote: UIColor(rgba: "#C3D1D1").CGColor,
        WhiteNoteFG: UIColor(rgba: "#000000").CGColor,
        Background: UIColor(rgba: "#210A02").CGColor
    ),
    "Blue" : ColorScheme(
        C: UIColor(rgba: "#7094B8").CGColor
        ,
        CFG: UIColor(rgba: "#000000").CGColor,
        BlackNote: UIColor(rgba: "#4C7AB9").CGColor,
        BlackNoteFG: UIColor(rgba: "#000000").CGColor,
        WhiteNote: UIColor(rgba: "#B3C7EB").CGColor,
        WhiteNoteFG: UIColor(rgba: "#000000").CGColor,
        Background: UIColor(rgba: "#363E52").CGColor
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
var triads : Bool = false
var currentColorScheme : String = "Rose"
var accidental : Int = 0
var transposition : Int = 0
var midiChannel : UInt8 = 0
var midiBassChannel : UInt8 = 1
var _bending = false
var bendingBase : CGFloat = 0
var _bendingDelta : CGFloat = 0
var pitchBendRange : Float = 0
var diagonalSlide : CGFloat = 0.15
var cornerI : Int = 6
var cornerJ : Int = 5

func pitchWheel(channel : Int, delta : Float) {
    //print("pw: \(delta)")
    let pitchbend = UInt16(0.5*(1.0+max(-1.0,min(1.0,delta/pitchBendRange)))*0b0011111111111111)
    let pitchbendMSB = UInt8((pitchbend&0b0011111110000000) >> 7)
    let pitchbendLSB = UInt8(pitchbend&0b0000000001111111)
    midi.sendBytes([0xE0+UInt8(channel),
        pitchbendLSB,pitchbendMSB], size: 3)
}

var bending : Bool {
get {
    return _bending
}
set {
    if (_bending != newValue) && pitchBendRange>0 {
        pitchWheel(Int(midiChannel), delta: 0.0)
    }
    _bending = newValue
}
}

var bendingDelta : CGFloat {
get {
    return _bendingDelta
}
set {
    _bendingDelta = newValue
    if pitchBendRange>0 {
        pitchWheel(Int(midiChannel), delta: Float(_bendingDelta))
    }
}
}

class ViewController: UIViewController {
    
    @IBOutlet weak var chordsButton: UIButton!
    var extraKeys : [(Int,Int)] = []
    var incompletePosition : Bool = false
    var lastVel : UInt8 = 0
    var grid : [[CAShapeLayer]]?
    var width : CGFloat = 0.0
    var height : CGFloat = 0.0
    var noteWidth : CGFloat = 0.0
    var noteHeight : CGFloat = 0.0
    var gap : CGFloat = 0.0
    var notesCount : Int = 0
    var activeKeys : [UITouch : (Int,Int)] = [:]
    var timeKey : [UITouch : NSTimeInterval ] = [:]
    var currentChord : ChordType? = nil
    var currentRoot : Int = 0
    var currentBass : Int = 0
    var bassNote : Int = 0
    var currentScale : [Bool] = allNotes
    var chordLabel : CATextLayer = CATextLayer()
    var pedalLabel : CALayer = CALayer()
    var chordLabelShadow : CATextLayer = CATextLayer()
    var pedalOn : Bool = false
    var octaveShift : Int = 0
    var activeNotes : [Bool] = [Bool](count: 128, repeatedValue: false)
    var gridNote : [[Int]]! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //genChordTable()
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
        if let defaultTriads = defaults.objectForKey("triads") as? Bool {
            triads = defaultTriads
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
        if let defaultPBRange = defaults.objectForKey("pitchBendRange") as? Float {
            pitchBendRange = defaultPBRange
        }
        if let defaultMidiChannel = defaults.objectForKey("midiChannel") as? Int {
            midiChannel = UInt8(defaultMidiChannel)
        }
        if let defaultMidiBassChannel = defaults.objectForKey("midiBassChannel") as? Int {
            midiBassChannel = UInt8(defaultMidiBassChannel)
        }
        if let defaultDiagonalSlide = defaults.objectForKey("diagonalSlide") as? Float {
            diagonalSlide = CGFloat(defaultDiagonalSlide)
        }
        if let defaultCornerI = defaults.objectForKey("cornerI") as? Int {
            cornerI = defaultCornerI
        }
        if let defaultCornerJ = defaults.objectForKey("cornerJ") as? Int {
            cornerJ = defaultCornerJ
        }
        setupGrid()
        showGrid()
        setupNotes()
        
        let l = self.view.layer
        l.backgroundColor = colorSchemes[currentColorScheme]?.Background
        l.addSublayer(chordLabelShadow)
        chordLabelShadow.frame = CGRectMake(53,52,900,300)
        chordLabelShadow.fontSize = 108
        chordLabelShadow.font = "Verdana"
        chordLabelShadow.string = ""
        chordLabelShadow.alignmentMode = kCAAlignmentLeft
        chordLabelShadow.backgroundColor = UIColor.clearColor().CGColor
        chordLabelShadow.foregroundColor = UIColor.blackColor().CGColor
        chordLabelShadow.opacity = 0.9
        l.addSublayer(chordLabel)
        chordLabel.frame = CGRectMake(50,50,900,300)
        chordLabel.fontSize = 108
        chordLabel.font = "Verdana"
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
        var gni = [[Int]]()
        var gi = [[CAShapeLayer]]()
        for _ in 0..<16 {
            var gnj = [Int]()
            var gj = [CAShapeLayer]()
            for _ in 0..<16 {
                let g = CAShapeLayer()
                self.view.layer.addSublayer(g)
                let text = CATextLayer()
                g.addSublayer(text)
                gj.append(g)
                gnj.append(0)
            }
            gi.append(gj)
            gni.append(gnj)
        }
        grid = gi
        gridNote = gni
    }
    
    func showGrid() {
        for i in 0..<16 {
            for j in 0..<16 {
                if i<gridHeight && j<gridWidth {
                    grid![i][j].hidden = false
                } else {
                    grid![i][j].hidden = true
                }
                if i<cornerI && j<cornerJ {
                    grid![i][j].opacity = 0.7
                } else {
                    grid![i][j].opacity = 1.0
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
        gap = diagonalSlide * min(noteHeight,noteWidth)
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: gap, y: 0))
        path.addLineToPoint(CGPoint(x: noteWidth-gap, y:0))
        let pi : CGFloat = 3.14159
        path.addArcWithCenter(CGPoint(x: noteWidth,y: 0), radius: gap, startAngle: pi, endAngle: pi/2, clockwise: false)
        path.addLineToPoint(CGPoint(x: noteWidth, y:noteHeight-gap))
        //path.addArcWithCenter(CGPoint(x: noteWidth,y: noteHeight), radius: gap, startAngle: 3*pi/2, endAngle: pi, clockwise: true)
        path.addArcWithCenter(CGPoint(x: noteWidth,y: noteHeight), radius: gap, startAngle: 3*pi/2, endAngle: 0, clockwise: true)
        path.addLineToPoint(CGPoint(x: noteWidth, y:noteHeight+gap))
        path.addArcWithCenter(CGPoint(x: noteWidth,y: noteHeight), radius: gap, startAngle: pi/2, endAngle: pi, clockwise: true)
        path.addLineToPoint(CGPoint(x: gap, y:noteHeight))
        path.addArcWithCenter(CGPoint(x: 0,y: noteHeight), radius: gap, startAngle: 0.0, endAngle: 3*pi/2, clockwise: false)
        path.addLineToPoint(CGPoint(x: 0, y: gap))
//        path.addArcWithCenter(CGPoint(x: 0,y: 0), radius: gap, startAngle: pi/2, endAngle: 0, clockwise: false)
  
        path.closePath()

        
        let colorC = colorSchemes[currentColorScheme]?.C
        let colorCFG = colorSchemes[currentColorScheme]?.CFG
        let colorBlackNote = colorSchemes[currentColorScheme]?.BlackNote
        let colorBlackNoteFG = colorSchemes[currentColorScheme]?.BlackNoteFG
        let colorWhiteNote = colorSchemes[currentColorScheme]?.WhiteNote
        let colorWhiteNoteFG = colorSchemes[currentColorScheme]?.WhiteNoteFG
        
        for i in 0..<gridHeight {
            for j in 0..<gridWidth {
                let g=grid![i][j]
                g.path = path.CGPath
                g.transform = CATransform3DMakeTranslation(CGFloat(j)*noteWidth+2.0, CGFloat(gridHeight-1-i)*noteHeight+2.0, 0)
                let m = midiNote(i,j)
                let text : CATextLayer = g.sublayers!.first as! CATextLayer
                text.string = midiToName(m)
                text.fontSize = 20
                text.font = "Verdana"
                text.backgroundColor = UIColor.clearColor().CGColor
                text.frame = CGRect(x: 0, y: gap, width: noteWidth, height: noteHeight-gap)
                text.alignmentMode = kCAAlignmentCenter
                g.strokeColor = UIColor.blackColor().CGColor
                g.lineWidth = 3.0
                if blackNote(m) {
                    g.fillColor = colorBlackNote
                    text.foregroundColor = colorBlackNoteFG
                } else if m%12 == 0 {
                    g.fillColor = colorC
                    text.foregroundColor = colorCFG
                } else {
                    g.fillColor = colorWhiteNote
                    text.foregroundColor = colorWhiteNoteFG
                }
                //g.opaque = true
            }
        }
        let gd=grid![gridHeight-1][0]
        let textd : CATextLayer = gd.sublayers!.first as! CATextLayer
        textd.fontSize = 28
        textd.string = "▼"
        textd.foregroundColor = UIColor.blackColor().CGColor
        gd.fillColor = UIColor(rgba: "#DFDFDF").CGColor
        let gu=grid![gridHeight-1][1]
        let textu : CATextLayer = gu.sublayers!.first as! CATextLayer
        textu.fontSize = 28
        textu.string = "▲"
        textu.foregroundColor = UIColor.blackColor().CGColor
        gu.fillColor = UIColor(rgba: "#DFDFDF").CGColor
    }
    
    func generateGrid() {
        setupNotes()
        showGrid()
    }
    
    func midiNote( i : Int, _ j : Int) -> Int {
        return 3*j+i+baseMidiNote+octaveShift
    }
    
    func locationToGrid(pt : CGPoint) -> (Int,Int) {
        var j : Int = Int((pt.x-2.0)/noteWidth)
        var i : Int = gridHeight-1-Int((pt.y-2.0)/noteHeight)
        i = min(max(0,i),gridHeight-1)
        j = min(max(0,j),gridWidth-1)
        if diagonalSlide>0 {
            let y = (pt.y-(CGFloat(gridHeight-1-i)*noteHeight+2.0))
            let x = (pt.x-(CGFloat(j)*noteWidth+2.0))
            //print(i,j,x,y)
            if sqrt((x-0.0)*(x-0.0)+(y-noteHeight)*(y-noteHeight))<gap {
                j=j-1
            } else if (abs(x-0.0)+abs(y-0.0))<gap {
                j=j-1
                i=i+1
            } else if sqrt((x-noteWidth)*(x-noteWidth)+(y-0.0)*(y-0.0))<gap {
                i=i+1
            }
            i = min(max(0,i),gridHeight-1)
            j = min(max(0,j),gridWidth-1)
        }
        return (i,j)
    }
    
    func locationToVel(pt : CGPoint) -> UInt8 {
        let i : Int = gridHeight-1-Int((pt.y-2.0)/noteHeight)
        let j : Int = Int((pt.x-2.0)/noteWidth)
        let x = (pt.x-(CGFloat(j)*noteWidth+2.0))
        let y = (pt.y-(CGFloat(gridHeight-1-i)*noteHeight+2.0))
        let c1 = (abs(x-0.0)+abs(y-0.0))<gap
        let c2 = sqrt((x-noteWidth)*(x-noteWidth)+(y-0.0)*(y-0.0))<gap
        if c1 || c2 {
            return UInt8(minVel)
        }
        let vel = max(0.0,1.0-(pt.y-(CGFloat(gridHeight-1-i)*noteHeight+2.0))/noteHeight)
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
    
    func octaveUp() {
        if octaveShift < 24 {
            octaveShift = octaveShift + 12
            setupNotes()
        }
    }
    
    func octaveDown() {
        if octaveShift > -24 {
            octaveShift = octaveShift - 12
            setupNotes()
        }
    }
    func pressKey(i : Int, _ j : Int, _ vel : UInt8) {
        if (i>=0 && i<gridHeight) && (j>=0 && j<gridWidth) {
            grid![i][j].opacity = 0.5
        }
        if j==0 && i==(gridHeight-1) {
            octaveDown()
            return
        } else if j==1 && i==(gridHeight-1) {
            octaveUp()
            return
        }
        let m = midiNote(i, j)
        gridNote[i][j] = m
        let channel = keyChannel(i,j)
        if activeNotes[m] {
            midiNoteOff(m, channel: channel)
        } else {
            activeNotes[m]=true
        }
        midiNoteOn(m, channel: channel, vel)
    }
    
    func keyChannel(i : Int, _ j : Int) -> UInt8 {
        if(i<cornerI && j<cornerJ) {
            return midiBassChannel
        } else {
            return midiChannel
        }
    }
    
    func releaseKey(i : Int, _ j : Int) {
        let m = gridNote[i][j]
        gridNote[i][j] = 0
        if (i>=0 && i<gridHeight) && (j>=0 && j<gridWidth) {
            if i<cornerI && j<cornerJ {
                grid![i][j].opacity = 0.7
            } else {
                grid![i][j].opacity = 1.0
            }
        }
        let channel = keyChannel(i,j)
        if activeNotes[m] {
            midiNoteOff(m, channel: channel)
            activeNotes[m]=false
        }
    }
    
    func isScaleNote(m : Int) -> Bool {
        return currentScale[(m+(12-currentRoot))%12]
    }
    
    func midiNoteOn(m : Int, channel : UInt8, _ vel : UInt8) {
        //println("midi on: \(midiToName(m)),\(vel)")
        midi.sendBytes([0x90|channel,UInt8(m+transposition),vel])
        lastVel = vel
    }
    
    func midiNoteOff(m : Int, channel : UInt8) {
        //println("midi off: \(midiToName(m))")
        midi.sendBytes([0x80|channel,UInt8(m+transposition),0])
    }
    
    
    func activateChord() {
        let chordName = currentChord!.format(currentRoot, bass: currentBass )
        //println(chordName)
        CATransaction.begin()
        chordLabelShadow.string = chordName
        chordLabel.string = chordName
        CATransaction.commit()
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
        CATransaction.begin()
        chordLabel.string = ""
        chordLabelShadow.string = ""
        CATransaction.commit()

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
        if (activeKeys.count>=4) || (triads && (activeKeys.count>=3)) {
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
        var notes : [Int] = []
        for (_,k) in activeKeys {
            if (k.0==(gridHeight-1)&&(k.1==0)) ||
                (k.0==(gridHeight-1)&&(k.1==1)) {
                    continue
            }
            keys.append(k)
            notes.append(midiNote(k.0,k.1))
        }
        notes = listChord(notes)
        keys.sortInPlace { $0.1 == $1.1 ? $0.0 < $1.0 : $0.1 < $1.1 }
        var strKeys : String = ""
        let bass = keys[0]
        if (keys[1].0-keys[0].0)>2 {
            keys[0].0=(keys[0].0)+3
            keys[0].1=(keys[0].1)-1
            if (keys[1].0-keys[0].0)>2 {
                keys[0].0=(keys[0].0)+3
                keys[0].1=(keys[0].1)-1
            }
        }
        if (keys[1].1-keys[0].1)>4 {
            keys[0].1=(keys[0].1)+4
            if (keys[1].1-keys[0].1)>4 {
                keys[0].1=(keys[0].1)+4
            }
        }
        for k in keys {
            strKeys = strKeys+"(\(k.0-keys[0].0),\(k.1-keys[0].1))"
        }
        //print(strKeys)
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
        /*if triads {
            if let chord = triadTable[strKeys] {
                currentChord = chord.0
                let (ri,rj) = keys[chord.1]
                currentRoot = midiNote(ri,rj) % 12
                currentBass = midiNote(bass.0,bass.1) % 12
                //currentScale = chordScale(currentChord!,7)[0]
                return true
            }
        }*/
        /*if let chord = positionTable[strKeys] {
            currentChord = chord.0
            let (ri,rj) = keys[chord.1]
            currentRoot = midiNote(ri,rj) % 12
            currentBass = midiNote(bass.0,bass.1) % 12
            //currentScale = chordScale(currentChord!,7)[0]
            return true
        }*/
        print(notesToString(notes))
        if let chord = chordTable[notesToString(notes)] {
            currentChord = chord.0
            currentBass = midiNote(bass.0,bass.1) % 12
            currentRoot = (currentBass + notes[chord.1]) % 12
            //currentScale = chordScale(currentChord!,7)[0]
            return true
        }
        else {
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
                //   let m = midiNote(i,j)
                g.opacity = 1.0
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        bending = false
        for t: NSObject in touches {
            let touch = t as? UITouch
            let pt = touch!.locationInView(self.view)
            let (i,j) = locationToGrid(pt)
            let vel = locationToVel(pt)
            activeKeys[touch!]=(i,j)
            timeKey[touch!]=touch!.timestamp
            pressKey(i,j,vel)
        }
        detectedChord()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        bending = false
        for t: NSObject in touches {
            let touch = t as? UITouch
            //let pt = touch!.locationInView(self.view)
            let (i,j) = activeKeys[touch!]!
            activeKeys[touch!]=nil
            timeKey[touch!]=nil
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
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if pitchBendRange>0 && activeKeys.count == 1 {
            let touch = touches.first! as UITouch
            let pt = touch.locationInView(self.view)
            if !bending {
                bending = true
                bendingBase = pt.y
            }
            bendingDelta = (bendingBase - pt.y)/noteHeight
            return
        }
        var flag = false
        for t: NSObject in touches {
            let touch = t as? UITouch
            let pt = touch!.locationInView(self.view)
            let ppt = touch!.previousLocationInView(self.view)
            let delta = touch!.timestamp-timeKey[touch!]!
            //print(floor(100.0*abs(pt.x-ppt.x)/CGFloat(delta)))
            let (i,j) = locationToGrid(pt)
            let (ai,aj) = activeKeys[touch!]!
            if i != ai || j != aj {
                activeKeys[touch!]=nil
                timeKey[touch!]=nil
                
                activeKeys[touch!]=(i,j)
                timeKey[touch!]=touch!.timestamp
                pressKey(i,j,lastVel)
                releaseKey(ai,aj)
                flag = true
            }
        }
        if flag {
            detectedChord()
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        //println("CANCEL")
        bending = false
        for t: NSObject in touches! {
            let touch = t as? UITouch
            //let pt = touch!.locationInView(self.view)
            let (i,j) = activeKeys[touch!]!
            activeKeys[touch!]=nil
            timeKey[touch!]=nil
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

