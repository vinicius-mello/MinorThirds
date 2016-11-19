//
//  ConfigViewController.swift
//  MinorThirds
//
//  Created by Vinicius Mello on 07/07/15.
//  Copyright (c) 2015 Vinicius Mello. All rights reserved.
//

import UIKit
import CoreAudioKit

class ConfigViewController: UIViewController {
    
    @IBOutlet weak var segWidth: UISegmentedControl!
    @IBOutlet weak var segHeight: UISegmentedControl!
    @IBOutlet weak var segBaseNote: UISegmentedControl!
    @IBOutlet weak var segColorScheme: UISegmentedControl!
    
    @IBOutlet weak var segAccidental: UISegmentedControl!
    @IBOutlet weak var switchIncompleteChords: UISwitch!
    @IBOutlet weak var switchSustain: UISwitch!
    @IBOutlet weak var switchTriads: UISwitch!
    
    @IBOutlet weak var segMIDIChannel: UISegmentedControl!
    
    @IBOutlet weak var segBassMIDIChannel: UISegmentedControl!
    
    @IBOutlet weak var sliderTranspose: UISlider!
    @IBOutlet weak var labelTranspose: UILabel!
    
    @IBOutlet weak var sliderPB: UISlider!
    @IBOutlet weak var labelPB: UILabel!
    
    @IBOutlet weak var labelCorner: UILabel!
    @IBOutlet weak var sliderCornerI: UISlider!
    @IBOutlet weak var sliderCornerJ: UISlider!
    
    @IBOutlet weak var diagonalSlider: UISlider!
    
    let rangeVel = RangeSlider(frame: CGRect.zero)
    
    let baseNote : [Int] = [31,33,35,36,38,40,41,43]
    let clr : [String] = ["Rose", "Green", "Blue"]
    var centralViewController : CABTMIDILocalPeripheralViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0...3 {
        segHeight.setTitle("\(gridHeightBase+i)", forSegmentAt: i)
            segWidth.setTitle("\(gridWidthBase+i)", forSegmentAt: i)
        }
        
        segHeight.selectedSegmentIndex = gridHeight-gridHeightBase
        segWidth.selectedSegmentIndex = gridWidth-gridWidthBase
        segBaseNote.selectedSegmentIndex = baseNote.index(of: baseMidiNote)!
        view.addSubview(rangeVel)
        rangeVel.minimumValue = 0
        rangeVel.maximumValue = 127
        rangeVel.lowerValue = Double(minVel)
        rangeVel.upperValue = Double(maxVel)
        segColorScheme.selectedSegmentIndex = clr.index(of: currentColorScheme)!
        switchIncompleteChords.isOn = fillIncompletePositions
        switchSustain.isOn = autoSustain
        switchTriads.isOn = triads
        segAccidental.selectedSegmentIndex = accidental
        labelTranspose.text = "Transpose \(transposition)"
        sliderTranspose.value = Float(transposition)
        sliderPB.value = pitchBendRange
        labelPB.text = "PB Range \(Int(pitchBendRange))"
        segMIDIChannel.selectedSegmentIndex = Int(midiChannel)
        segBassMIDIChannel.selectedSegmentIndex = Int(midiBassChannel)
        diagonalSlider.value = Float(diagonalSlide)
        sliderCornerI.value = Float(cornerI)/Float(gridHeight)
        sliderCornerJ.value = Float(cornerJ)/Float(gridWidth)
        labelCorner.text = "Split Corner (\(cornerI),\(cornerJ))"
// Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        rangeVel.frame = CGRect(x: 207, y: 366,
            width: 416, height: 30.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func returnToKeys(_ sender: AnyObject) {
        let nav = self.presentingViewController as! UINavigationController
        let main = nav.viewControllers[0] as! ViewController
        gridHeight = gridHeightBase+segHeight.selectedSegmentIndex
        gridWidth = gridWidthBase+segWidth.selectedSegmentIndex
        baseMidiNote = baseNote[segBaseNote.selectedSegmentIndex]
        maxVel = CGFloat(rangeVel.upperValue)
        minVel = CGFloat(rangeVel.lowerValue)
        currentColorScheme = clr[segColorScheme.selectedSegmentIndex]
        fillIncompletePositions = switchIncompleteChords.isOn
        autoSustain = switchSustain.isOn
        triads = switchTriads.isOn
        
        accidental = segAccidental.selectedSegmentIndex
        transposition = Int(floor(sliderTranspose.value))
        pitchBendRange = floor(sliderPB.value)
        midiChannel = UInt8(segMIDIChannel.selectedSegmentIndex)
        midiBassChannel = UInt8(segBassMIDIChannel.selectedSegmentIndex)
        diagonalSlide = CGFloat(diagonalSlider.value)
        
        let defaults = UserDefaults.standard
        defaults.set(gridHeight, forKey: "gridHeight")
        defaults.set(gridWidth, forKey: "gridWidth")
        defaults.set(baseMidiNote, forKey: "baseMidiNote")
        defaults.set(Float(minVel), forKey: "minVel")
        defaults.set(Float(maxVel), forKey: "maxVel")
        defaults.setValue(currentColorScheme, forKey: "colorScheme")
        defaults.set(autoSustain, forKey: "autoSustain")
        defaults.set(triads, forKey: "triads")
        defaults.set(fillIncompletePositions, forKey: "incompleteChords")
        defaults.set(accidental, forKey: "accidental")
        defaults.set(transposition, forKey: "transposition")
        defaults.set(pitchBendRange, forKey: "pitchBendRange")
        defaults.set(Int(midiChannel), forKey: "midiChannel")
        defaults.set(Int(midiBassChannel), forKey: "midiBassChannel")
        defaults.set(diagonalSlider.value, forKey: "diagonalSlide")
        defaults.set(cornerI, forKey: "cornerI")
        defaults.set(cornerJ, forKey: "cornerJ")
        main.generateGrid()
        nav.dismiss(animated: true, completion: nil)
    }
   
    @IBAction func tranposeChange(_ sender: AnyObject) {
        let value = Int(floor(sliderTranspose.value))
        labelTranspose.text = "Transpose \(value)"
    }
    
    @IBAction func pbRangeChange(_ sender: AnyObject) {
        let value = Int(floor(sliderPB.value))
        labelPB.text = "PB Range \(value)"
    }
    
    @IBAction func cornerIChanged(_ sender: AnyObject) {
        cornerI = Int(floor(sliderCornerI.value*Float(gridHeight)))
        labelCorner.text = "Split Corner (\(cornerI),\(cornerJ))"
    }
    
    @IBAction func cornerJChanged(_ sender: AnyObject) {
        cornerJ = Int(floor(sliderCornerJ.value*Float(gridWidth)))
        labelCorner.text = "Split Corner (\(cornerI),\(cornerJ))"
    }
    /*
    @objc func doneAction() {
        //midi = VirtualSourceMidi("MinorThirds")
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func searchBluetoothMIDI(sender: UIButton) {
        centralViewController = CABTMIDILocalPeripheralViewController()
        var navController : UINavigationController =
        UINavigationController(rootViewController: centralViewController!)
        centralViewController!.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector("doneAction"))
        navController.modalPresentationStyle = UIModalPresentationStyle.Popover
        var popC : UIPopoverPresentationController = navController.popoverPresentationController!
        popC.permittedArrowDirections = UIPopoverArrowDirection.Any
        
        popC.sourceRect = sender.frame
        popC.sourceView = sender.superview
        self.presentViewController(navController, animated: true, completion: nil)
    }
    */
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
