//
//  InviteEmailInputTableViewCell.swift
//  Proto-UNDO
//
//  Created by Tomasz on 10/28/15.
//  Copyright © 2015 Curly Brackets. All rights reserved.
//

import UIKit

class InviteEmailInputTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var btnInvite: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    
    var inviteButtonPressed:((isEmailValidation : Bool)->())!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        txtEmail.clearButtonMode = UITextFieldViewMode.WhileEditing
//        setInviteButtonEnabled(txtEmail.text!)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    
    @IBAction func onPressInvite(sender: AnyObject) {
        txtEmail.resignFirstResponder()
        if inviteButtonPressed != nil
        {            
            if validateEmail(txtEmail.text!) == false
            {
                inviteButtonPressed(isEmailValidation: false)
            }
            else
            {
                inviteButtonPressed(isEmailValidation: true)
            }
        }
    }
    
    // MARK: - TextFieldDelegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        var txtAfterUpdate : String = textField.text!
        txtAfterUpdate = txtAfterUpdate.stringByReplacingCharactersInRange((textField.text?.rangeFromNSRange(range))!, withString: string)
        
//        setInviteButtonEnabled(txtAfterUpdate)
        
        return true
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        
//        btnInvite.enabled = false
//        btnInvite .setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        return true;
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text == ""
        {
            textField.clearButtonMode = UITextFieldViewMode.WhileEditing
        }
        else
        {
            textField.clearButtonMode = UITextFieldViewMode.Always
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - General Methods
    
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluateWithObject(candidate)
    }
    
    func setInviteButtonEnabled(emailString : String)
    {
        if validateEmail(emailString)
        {
            btnInvite.enabled = true
            btnInvite .setTitleColor(UIColor(red: 0, green: 122.0 / 255.0, blue: 1.0, alpha: 1.0), forState: UIControlState.Normal)
        }
        else
        {
            btnInvite.enabled = false
            btnInvite .setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        }
    }
}
