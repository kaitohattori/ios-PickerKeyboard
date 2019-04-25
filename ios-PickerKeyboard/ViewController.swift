//
//  ViewController.swift
//  ios-PickerKeyboard
//
//  Created by kaichan on 4/25/19.
//  Copyright © 2019 Kaito Hattori. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PickerKeyboardDelegate {

    @IBOutlet weak var pickingView: PickerKeyboard!
    @IBOutlet weak var datePickingView: PickerKeyboard!
    @IBOutlet weak var mylabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var list = [
        "math", "science", "history", "programming", "english"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickingView.type = .normal
        self.pickingView.pickItems = self.list
        self.pickingView.scheme = .dark
        self.pickingView.unit = ""
        self.pickingView.delegate = self
        
        self.datePickingView.type = .date
        self.datePickingView.scheme = .white
        self.datePickingView.delegate = self
    }

    func pickerKeyboard(_ pickerKeyboard: PickerKeyboard, didPickRowAt row: Int) {
        self.mylabel.text = self.list[row]
    }
    
    func pickerKeyboard(_ pickerKeyboard: PickerKeyboard, didPickDate date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm"
        let date_str = formatter.string(from: date)
        self.dateLabel.text = date_str
    }
}

