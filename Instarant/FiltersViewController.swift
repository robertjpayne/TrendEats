//
//  FiltersViewController.swift
//  Instarant
//
//  Created by Chris Dunaetz on 2/2/17.
//  Copyright © 2017 Chris Dunaetz. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var customSearchField: UITextField!
    @IBOutlet weak var numberOfDaysTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        
        categoryPicker.selectRow(Constants.selectedCategoryIndex, inComponent: 0, animated: false)
        numberOfDaysTextField.delegate = self
        numberOfDaysTextField.text = String(Constants.numberOfDaysToSearchForPosts)
        customSearchField.text = Constants.customQueryString
    }

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView,
                           numberOfRowsInComponent component: Int) -> Int {
        return Constants.categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let string = Constants.categories[row]
        return NSAttributedString(string: string, attributes: [NSForegroundColorAttributeName:UIColor.white])
    }
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        Constants.selectedCategoryIndex = row
        customSearchField.text = nil
        customSearchField.resignFirstResponder()
    }
    @IBAction func searchButtonTapped(_ sender: Any) {
        Constants.customQueryString = customSearchField.text
        //not sure if necessary:
        if customSearchField.text == "" {
            Constants.customQueryString = nil
        }
        
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadData"), object: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.numberOfDaysTextField {
            if let string = self.numberOfDaysTextField.text {
                if let int = Int(string) {
                    Constants.numberOfDaysToSearchForPosts = int
                }
            }
        }
    }
}
