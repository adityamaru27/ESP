//
//  CustomizMenuTableViewController.swift
//  Proto-UNDO
//
//  Created by Santu C on 20/09/16.
//  Copyright © 2016 Curly Brackets. All rights reserved.
//

import UIKit

class CustomizMenuTableViewController: UITableViewController {
    @IBOutlet weak var lblMeasurementValue: UILabel!
    @IBOutlet weak var lblCustomizeViewValue: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "dismiss")

        
    }

    
    
    
    override func viewWillAppear(animated: Bool) {
            super.viewWillAppear(animated) // No need for semicolon
    
        if ((NSUserDefaults.standardUserDefaults().objectForKey("Measurements")?.isEqualToString("oz")) == true) {
        
        lblMeasurementValue.text = "ounces"
        }
        else
        {
            lblMeasurementValue.text = "milliliters"
        }
        
        var flag : Bool = true
        
        for i in 0..<DataSource.sharedDataSouce.allEvents.count {
        
          if  DataSource.sharedDataSouce.isEventIndexActive(i) == false
          {
            flag = false ;
            break;
           }
        }
        
        
        if (!flag)
        {
            lblCustomizeViewValue.text = "Modified"
        }
        else
        {
            lblCustomizeViewValue.text = "Not Modified"
        }
        
        
        
      //  DataSource.sharedDataSouce.isEventIndexActive
        
    }
    
    
    func dismiss() {
        self.navigationController?.popViewControllerAnimated(true)
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return "You can customize Eat Sleep Poop."
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if ( indexPath.row == 0 )
        {
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("showCustomize")
            vc.modalTransitionStyle = .CrossDissolve
            presentViewController(vc, animated: true, completion: nil)
        }
        else if ( indexPath.row == 1)
        {
            let storyboard : UIStoryboard = UIStoryboard(name: "Story", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("Measurement")
            // vc.modalTransitionStyle = .CrossDissolve
            //presentViewController(vc, animated: true, completion: nil)
            
            self.navigationController!.pushViewController(vc, animated: true)
        }
           
    }
    
    /*
         
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
*/
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
