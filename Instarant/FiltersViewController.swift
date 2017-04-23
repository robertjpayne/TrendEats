//
//  FiltersViewController.swift
//  Instarant
//
//  Created by Chris Dunaetz on 2/2/17.
//  Copyright © 2017 Chris Dunaetz. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var categoryPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryPicker.dataSource = self
        categoryPicker.delegate = self

    }

//    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//        
//        let string = "myString"
//        return NSAttributedString(string: string, attributes: [NSForegroundColorAttributeName:UIColor.white])
//    }
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    public func pickerView(_ pickerView: UIPickerView,
                           numberOfRowsInComponent component: Int) -> Int {
        return 8
    }
    
    public func pickerView(_ pickerView: UIPickerView,
                           titleForRow row: Int,
                           forComponent component: Int) -> String? {
        return "hello"
    }
}
