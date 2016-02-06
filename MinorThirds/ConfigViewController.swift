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
    
    @IBOutlet weak var sliderTranspose: UISlider!
    @IBOutlet weak var labelTranspose: UILabel!
    
    @IBOutlet weak var sliderPB: UISlider!
    @IBOutlet weak var labelPB: UILabel!
    
    @IBOutlet weak var diagonalSlider: UISlider!
    
    let rangeVel = RangeSlider(frame: CGRectZero)
    
    let baseNote : [Int] = [31,33,35,36,38,40,41,43]
    let clr : [String] = ["Rose", "Green"]
    var centralViewController : CABTMIDILocalPeripheralViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segHeight.selectedSegmentIndex = gridHeight-7
        segWidth.selectedSegmentIndex = gridWidth-10
        segBaseNote.selectedSegmentIndex = baseNote.indexOf(baseMidiNote)!
        view.addSubview(rangeVel)
        rangeVel.minimumValue = 0
        rangeVel.maximumValue = 127
        rangeVel.lowerValue = Double(minVel)
        rangeVel.upperValue = Double(maxVel)
        segColorScheme.selectedSegmentIndex = clr.indexOf(currentColorScheme)!
        switchIncompleteChords.on = fillIncompletePositions
        switchSustain.on = autoSustain
        switchTriads.on = triads
        segAccidental.selectedSegmentIndex = accidental
        labelTranspose.text = "Transpose \(transposition)"
        sliderTranspose.value = Float(transposition)
        sliderPB.value = pitchBendRange
        labelPB.text = "PB Range \(Int(pitchBendRange))"
        segMIDIChannel.selectedSegmentIndex = Int(midiChannel)
        diagonalSlider.value = Float(diagonalSlide)
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
    
    @IBAction func returnToKeys(sender: AnyObject) {
        let nav = self.presentingViewController as! UINavigationController
        let main = nav.viewControllers[0] as! ViewController
        gridHeight = 7+segHeight.selectedSegmentIndex
        gridWidth = 10+segWidth.selectedSegmentIndex
        baseMidiNote = baseNote[segBaseNote.selectedSegmentIndex]
        maxVel = CGFloat(rangeVel.upperValue)
        minVel = CGFloat(rangeVel.lowerValue)
        currentColorScheme = clr[segColorScheme.selectedSegmentIndex]
        fillIncompletePositions = switchIncompleteChords.on
        autoSustain = switchSustain.on
        triads = switchTriads.on
        
        accidental = segAccidental.selectedSegmentIndex
        transposition = Int(floor(sliderTranspose.value))
        pitchBendRange = floor(sliderPB.value)
        midiChannel = UInt8(segMIDIChannel.selectedSegmentIndex)
        diagonalSlide = CGFloat(diagonalSlider.value)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(gridHeight, forKey: "gridHeight")
        defaults.setInteger(gridWidth, forKey: "gridWidth")
        defaults.setInteger(baseMidiNote, forKey: "baseMidiNote")
        defaults.setFloat(Float(minVel), forKey: "minVel")
        defaults.setFloat(Float(maxVel), forKey: "maxVel")
        defaults.setValue(currentColorScheme, forKey: "colorScheme")
        defaults.setBool(autoSustain, forKey: "autoSustain")
        defaults.setBool(triads, forKey: "triads")
        defaults.setBool(fillIncompletePositions, forKey: "incompleteChords")
        defaults.setInteger(accidental, forKey: "accidental")
        defaults.setInteger(transposition, forKey: "transposition")
        defaults.setFloat(pitchBendRange, forKey: "pitchBendRange")
        defaults.setInteger(Int(midiChannel), forKey: "midiChannel")
        defaults.setFloat(diagonalSlider.value, forKey: "diagonalSlide")
        
        main.generateGrid()
        nav.dismissViewControllerAnimated(true, completion: nil)
    }
   
    @IBAction func tranposeChange(sender: AnyObject) {
        let value = Int(floor(sliderTranspose.value))
        labelTranspose.text = "Transpose \(value)"
    }
    
    @IBAction func pbRangeChange(sender: AnyObject) {
        let value = Int(floor(sliderPB.value))
        labelPB.text = "PB Range \(value)"
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
