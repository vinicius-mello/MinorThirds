//
//  DetailViewController.swift
//  MinorThirds
//
//  Created by Vinicius Mello on 11/07/15.
//  Copyright (c) 2015 Vinicius Mello. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    let size : CGFloat = 60

    var keys : [CATextLayer] = [
        CATextLayer(),
        CATextLayer(),
        CATextLayer(),
        CATextLayer(),
        CATextLayer(),
        CATextLayer(),
        CATextLayer(),
        CATextLayer()
    ]
    var position: Position! {
        didSet (newPosition) {
            self.refreshUI()
        }
    }
    
    func refreshUI() {
        //println(position.keys)
        
        let colorC = colorSchemes[currentColorScheme]?.C
        let colorCFG = colorSchemes[currentColorScheme]?.CFG
        let colorBlackNote = colorSchemes[currentColorScheme]?.BlackNote
        let colorBlackNoteFG = colorSchemes[currentColorScheme]?.BlackNoteFG
        let colorWhiteNote = colorSchemes[currentColorScheme]?.WhiteNote
        let colorWhiteNoteFG = colorSchemes[currentColorScheme]?.WhiteNoteFG
        
        var index : Int = 0
        for k in position.keys {
            let g = keys[index]
            g.frame = CGRect(x: CGFloat(k.1)*size+size,  y: 400-CGFloat(k.0)*size, width: size, height: size)
            let m = midiNoteRelative(position.keys[position.root], key: k)
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
            g.borderColor = UIColor.black.cgColor
            g.alignmentMode = CATextLayerAlignmentMode.center
            g.isHidden = false
            index = index + 1
        }
        for k in position.extraKeys {
            let g = keys[index]
            g.frame = CGRect(x: CGFloat(k.1)*size+size,  y: 400-CGFloat(k.0)*size, width: size, height: size)
            let m = midiNoteRelative(position.keys[position.root], key: k)
            g.string = midiToName(m)+"\nauto"
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
            g.borderWidth = 4.0
            g.borderColor = UIColor.black.cgColor
            g.alignmentMode = CATextLayerAlignmentMode.center
            g.isHidden = false
            index = index + 1
        }
        for i in index..<keys.count {
            keys[i].isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for k in keys {
            self.view.layer.addSublayer(k)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        position = allPositions[0]
        //println(masterViewController)
        masterViewController?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func returnToKeys(_ sender: AnyObject) {
        let nav = self.presentingViewController
        nav!.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DetailViewController: PositionSelectionDelegate {
    func positionSelected(_ newPosition: Position) {
        position = newPosition
    }
}
