//
//  SettingsViewController.swift
//  tipME
//
//  Created by Derek Chang on 12/17/18.
//  Copyright © 2018 Derek Chang. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    
    @IBOutlet weak var default_tipSegment: UISegmentedControl!
    
    @IBOutlet weak var customTip1: UITextField!
    @IBOutlet weak var customTip2: UITextField!
    @IBOutlet weak var customTip3: UITextField!
   
    @IBOutlet weak var sliderSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //Updates the UserDefaults when the default tip is changed
    @IBAction func indexChanged(_ sender: AnyObject) {
        
        let defaults = UserDefaults.standard
        defaults.set(default_tipSegment.selectedSegmentIndex, forKey: "defaultTip")
    }
    
    @IBAction func updateDefaultTips(_ sender: Any) {
        //Actions after pressing the save button
        
        //Update defaults according to the text inputs
        let defaults = UserDefaults.standard
        
        //If the text field is not empty, update the default with the new value
        if !(customTip1.text?.isEmpty)! {
            defaults.set(Int(customTip1.text!), forKey: "customTip1")
        }
        if !(customTip2.text?.isEmpty)! {
            defaults.set(Int(customTip2.text!), forKey: "customTip2")
        }
        if !(customTip3.text?.isEmpty)!{
            defaults.set(Int(customTip3.text!), forKey: "customTip3")
        }
       
        
        
        //update the seg. control panel on top of the screen
        default_tipSegment.setTitle(defaults.string(forKey: "customTip1")! + "%", forSegmentAt: 0)
        default_tipSegment.setTitle(defaults.string(forKey: "customTip2")! + "%", forSegmentAt: 1)
        default_tipSegment.setTitle(defaults.string(forKey: "customTip3")! + "%", forSegmentAt: 2)
    }
    
    //When the screen is tapped, the keyboard goes away
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    //Update the settings based on the switch state
    @IBAction func switchChanged(_ sender: Any) {
        
        let defaults = UserDefaults.standard
        
        defaults.set(sliderSwitch.isOn, forKey: "switchBool")
        
        //print("changed" + "  " + String(sliderSwitch.isOn))
        
        print("Set:  " + String(defaults.bool(forKey: "switchBool")))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear")
        
        
        let defaults = UserDefaults.standard
        //corrects the starting index of the seg. control
        default_tipSegment.selectedSegmentIndex = defaults.integer(forKey: "defaultTip")
        
        //updates the seg. control according to the defaults
        default_tipSegment.setTitle(defaults.string(forKey: "customTip1")! + "%", forSegmentAt: 0)
        default_tipSegment.setTitle(defaults.string(forKey: "customTip2")! + "%", forSegmentAt: 1)
        default_tipSegment.setTitle(defaults.string(forKey: "customTip3")! + "%", forSegmentAt: 2)
        
        //Handles placerholders of the text fields
        customTip1.placeholder = String(defaults.integer(forKey: "customTip1"))
        customTip2.placeholder = String(defaults.integer(forKey: "customTip2"))
        customTip3.placeholder = String(defaults.integer(forKey: "customTip3"))
        
        
        sliderSwitch.isOn = defaults.bool(forKey: "switchBool")
        //print(defaults.bool(forKey: "switchBool"))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("view did appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("view will disappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("view did disappear")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
