//
//  VaccineSelectionTableViewController.swift
//  Proto-UNDO
//
//  Created by Tomasz on 11/9/15.
//  Copyright © 2015 Curly Brackets. All rights reserved.
//

import UIKit

class VaccineSelectionTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var vaccineListPicker: UIPickerView!
    @IBOutlet weak var txtSelectedVaccine: UITextField!
    
    var selectedVaccine : String!
    
    let vaccineList = [ "HepatitisB (HepB)",
                        "Rotavirus (RV)RV1(2-dose series); RV5 (3-dose series)",
                        "Diphtheria, tetanus, & acellular pertussis (DTaP:<7yrs)",
                        "Tetanus, diphtheria, & acellular pertussis (Tdap: >7 yrs)",
                        "Haemophilus ifluenzae type b (Hib)",
                        "Pneumococcal conjugate (PCV13)",
                        "Pneumococcal polysaccharide (PPSV23)",
                        "Inactivated poliovirus (IPV: <18 yrs)",
                        "In uenza (IIV; LAIV) 2 doses for some",
                        "Measles,mumps,rubella (MMR)",
                        "Varicella (VAR)",
                        "Hepatitis A (HepA)",
                        "Human papillomavirus (HPV2: females only; HPV4: males and females)",
                        "Meningococcal (Hib-MenCY > 6 weeks; MenACWY-D >9 mos; MenACWY-CRM ≥ 2 mos)"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(nil, forKey: "SelectedVaccine")
        userDefaults.synchronize()
        
        txtSelectedVaccine.font = UIFont(name: "Helvetica Neue", size: 13)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if selectedVaccine != nil && selectedVaccine != ""
        {
            if vaccineList.indexOf(selectedVaccine) == nil
            {
                txtSelectedVaccine.text = vaccineList[0]
            }
            else
            {
                txtSelectedVaccine.text = selectedVaccine
                vaccineListPicker.selectRow(vaccineList.indexOf(selectedVaccine)!, inComponent: 0, animated: false)
            }
        }
        else
        {
            txtSelectedVaccine.text = vaccineList[0]
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - PickerView
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return vaccineList.count;
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        
        var pickerLabel = view as? UILabel;
        
        if (pickerLabel == nil)
        {
            pickerLabel = UILabel()
            
            pickerLabel?.font = UIFont(name: "Helvetica Neue", size: 13)
            pickerLabel?.textAlignment = NSTextAlignment.Center
        }
        
        pickerLabel?.text = vaccineList[row]
        
        return pickerLabel!;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return vaccineList[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtSelectedVaccine.text = vaccineList[row]
    }
    
    // MARK: - Actions
    
    @IBAction func onPressCancel(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func onPressAdd(sender: AnyObject) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(txtSelectedVaccine.text, forKey: "SelectedVaccine")
        userDefaults.synchronize()
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
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
