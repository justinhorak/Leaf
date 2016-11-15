//
//  TestViewController.swift
//  Leaf
//
//  Created by Justin  on 11/13/16.
//  Copyright © 2016 Leaf. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    @IBOutlet weak var button: UIButton!
    
   var segmentView: SMSegmentView!
    override func viewDidLoad() {
        super.viewDidLoad()
        buildSegement()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func buildSegement(){
        let appearance = SMSegmentAppearance()
        appearance.segmentOnSelectionColour = UIColor(red: 245.0/255.0, green: 174.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        appearance.segmentOffSelectionColour = UIColor.white
        appearance.titleOnSelectionFont = UIFont.systemFont(ofSize: 12.0)
        appearance.titleOffSelectionFont = UIFont.systemFont(ofSize: 12.0)
        appearance.contentVerticalMargin = 10.0
        let segmentFrame = CGRect(x: 120, y: 120.0, width: self.view.frame.size.width, height: 40.0)
        segmentView = SMSegmentView(frame: segmentFrame, dividerColour: UIColor(white: 0.95, alpha: 0.3), dividerWidth: 1.0, segmentAppearance: appearance)
        
        self.view.addSubview(self.segmentView)
        
        
        
        
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            button.setTitle("Get Started", for: UIControlState.normal)
        case 1:
            button.setTitle("Log In", for: UIControlState.normal)
        default:
            break; 
        }
        
        
        
        
        
    }

  

}
