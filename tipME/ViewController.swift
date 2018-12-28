//
//  ViewController.swift
//  tipME
//
//  Created by Derek Chang on 12/17/18.
//  Copyright © 2018 Derek Chang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    @IBOutlet weak var tipSlider: UISlider!
    @IBOutlet weak var sliderTipLabel: UILabel!
    @IBOutlet weak var multPersonTotalLabel: UILabel!
    
    @IBOutlet weak var personCount: UITextField!
    
    @IBOutlet weak var remiander: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the min and max for the slider
        tipSlider.maximumValue = 100
        tipSlider.minimumValue = 0
        
        //Set the slider label to the value of the slider
        sliderTipLabel.text = String(tipSlider.value)
        
        //Displays the keyboard on start up
        self.billField.becomeFirstResponder()
        
    }
    
    //Dismiss keyboard after tapping anywhere not on the keyboard
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
        
    }
    
    //Erases the text in the field before they input new value
    @IBAction func touchDownPersonCount(_ sender: Any) {
        personCount.text = ""
    }
    
    //Updates the value of the total when there are multiple people
    func changeNewTotal(){
        let defaults = UserDefaults.standard
        let numPeople =  Float(personCount.text!) ?? 0
        
        let regularTotal = defaults.float(forKey: "total")
        
        
        var dividedTotal = regularTotal / numPeople
        
        dividedTotal = Float(String(format: "%.2f" ,dividedTotal))!
        multPersonTotalLabel.text = String(format: "%.2f", dividedTotal)
        
        
        //If the dividedTotal * numPeople is less than the bill, add 0.01 to the dividel Total to bring it above the bill
        if  dividedTotal * numPeople < regularTotal {
            dividedTotal = dividedTotal + 0.01
            multPersonTotalLabel.text = String(format: "%.2f" , dividedTotal)
        }
        
        //Calculates the extraneous payment
        if dividedTotal * numPeople > regularTotal{
            //Add .0005 to avoid a rounding issue
            let remainderFloat = Float( dividedTotal * numPeople - regularTotal + 0.005) * 100
            let newRemiander = Float(Int(remainderFloat))
            let remainder = String(format: "%.2f" , newRemiander / 100)
            remiander.text =  remainder + "  Extra"
        }
        //If the payment and bill match, then there is no extraneous payment
        else{
            remiander.text = ""
        }
    }
    
    @IBAction func personCountChanged(_ sender: Any) {
        changeNewTotal()
    }
    
    //Adjusts the apprpriate values when the tip slider changes
    @IBAction func tipSliderValueChanged(_ sender: Any) {
       
        tipSlider.value = tipSlider.value.rounded()
        
        //update the label next to the slider when the slider changes value
        sliderTipLabel.text = String(format: "%.0f", tipSlider.value) + "%"
        
        createTip()
        changeNewTotal()
    }
    
    /*Takes the default tips, the selected tip, the input value and
    outputs a tip and total*/
    func createTip(){
        let defaults = UserDefaults.standard
        
        let tipPercentages = [defaults.float(forKey: "customTip1") / 100,
                              defaults.float(forKey: "customTip2") / 100,
                              defaults.float(forKey: "customTip3") / 100] as [Float]
        
        let bill = Float(billField.text!) ?? 0
        var tip = Float(0)
        if defaults.bool(forKey: "switchBool"){
            tip = bill * tipSlider.value / 100
        }
        else{
            tip = bill * Float(tipPercentages[tipControl.selectedSegmentIndex])
        }
        
        let total = tip + bill
        
        let truncatedTotal = Float(String(format: "%.2f", total))
        defaults.set(truncatedTotal, forKey: "total")
        
        
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
    }
    
    
    //When the value of the bill is changed, the tip and total values are changed and displayed
    @IBAction func calculateTip(_ sender: Any) {
        createTip()
        changeNewTotal()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
        //highlights the appropriate index according to the default tip
        let defaults = UserDefaults.standard
        tipControl.selectedSegmentIndex = defaults.integer(forKey: "defaultTip")
        
        
        
        //Changes the title of the tip %'s based on the default tips
        var defualtCustomTip1 = defaults.integer(forKey: "customTip1")
        if defualtCustomTip1 == 0 {
            defaults.set(10, forKey: "customTip1")
            defualtCustomTip1 = defaults.integer(forKey: "customTip1")
        }
        tipControl.setTitle(String(defualtCustomTip1) + "%", forSegmentAt: 0)
        
        var defualtCustomTip2 = defaults.integer(forKey: "customTip2")
        if defualtCustomTip2 == 0 {
            defaults.set(15, forKey: "customTip2")
            defualtCustomTip2 = defaults.integer(forKey: "customTip2")
        }
        tipControl.setTitle(String(defualtCustomTip2) + "%", forSegmentAt: 1)
        
        var defualtCustomTip3 = defaults.integer(forKey: "customTip3")
        if defualtCustomTip3 == 0 {
            defaults.set(20, forKey: "customTip3")
            defualtCustomTip3 = defaults.integer(forKey: "customTip3")
        }
        tipControl.setTitle(String(defualtCustomTip3) + "%", forSegmentAt: 2)
        
        
        //update the tip slider value
        let tipPercentages = [defaults.float(forKey: "customTip1") / 100,
                              defaults.float(forKey: "customTip2") / 100,
                              defaults.float(forKey: "customTip3") / 100] as [Float]
        tipSlider.setValue(tipPercentages[tipControl.selectedSegmentIndex] * 100, animated: true)
        
        //update the label next to the slider
        sliderTipLabel.text = String(format: "%.0f", tipSlider.value) + "%"
       
        
        
        /*updates the tip value when the view is loaded
        Addresses the scenario when the user changes the settings and looks back at the tip. this will make sure the tip relfects the new settings*/
        createTip()
        
        
        changeNewTotal()
        
        
        
        //If the user wants the slider, then it will hide the seg. control
        tipControl.isHidden = defaults.bool(forKey: "switchBool")
        tipSlider.isHidden = !defaults.bool(forKey: "switchBool")
        sliderTipLabel.isHidden = !defaults.bool(forKey: "switchBool")
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
}

