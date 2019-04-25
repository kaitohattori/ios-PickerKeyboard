import UIKit

protocol PickerKeyboardDelegate: class {
    func pickerKeyboard(_ pickerKeyboard: PickerKeyboard, didPickRowAt row: Int)
    func pickerKeyboard(_ pickerKeyboard: PickerKeyboard, didPickDate date: Date)
}

class PickerKeyboard: UIControl {
    
    weak var delegate: PickerKeyboardDelegate!
    
    private var pickerView: UIPickerView!
    
    private var datePickerView: UIDatePicker!
    
    /// set pickerView type (normal or date)
    var type: PickerKeyboardType = .normal
    
    /// set picking items
    var pickItems: [String] = []
    
    /// set an unit of values in pickerView
    var unit: String = ""
    
    /// set a scheme of pickerView
    var scheme: PickerKeyboardScheme = .white
    
    /// picked item
    private var pickedItem: String = ""
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addTarget(self, action: #selector(tappedPickerKeyboard(_:)), for: .touchUpInside)
    }
    
    @objc private func tappedPickerKeyboard(_ sender: PickerKeyboard) {
        becomeFirstResponder()
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var inputAccessoryView: UIView? {
        
        let view = UIVisualEffectView(effect: UIBlurEffect(style: self.scheme.colors.toolbar))
        view.frame = CGRect(x: 0, y: 0, width: frame.width, height: 44)
        
        let doneButton = UIButton(type: .custom)
        doneButton.setTitle("Done", for: .normal)
        doneButton.sizeToFit()
        doneButton.addTarget(self, action: #selector(tappedCloseButton(_:)), for: .touchUpInside)
        doneButton.setTitleColor(UIColor(red: 0, green: 122/255, blue: 1, alpha: 1.0), for: .normal)
        view.contentView.addSubview(doneButton)
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.widthAnchor.constraint(equalToConstant: doneButton.frame.size.width).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: doneButton.frame.size.height).isActive = true
        doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        return view
    }
    
    override var inputView: UIView? {
        
        let view = UIView()
        
        if self.type == .normal {
            self.pickerView = UIPickerView()
            self.pickerView.delegate = self
            self.pickerView.dataSource = self
            self.pickerView.autoresizingMask = [.flexibleHeight]
            self.pickerView.backgroundColor = self.scheme.colors.background
            
            
            view.backgroundColor = self.scheme.colors.background
            view.autoresizingMask = [.flexibleHeight]
            view.addSubview(self.pickerView)
            
            self.pickerView.translatesAutoresizingMaskIntoConstraints = false
            self.pickerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            self.pickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            self.pickerView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
            
            self.autoSelectItem()
        }
        else if self.type == .date {
            self.datePickerView = UIDatePicker()
            self.datePickerView.datePickerMode = .dateAndTime
            self.datePickerView.autoresizingMask = [.flexibleHeight]
            self.datePickerView.backgroundColor = self.scheme.colors.background
            self.datePickerView.locale = Locale(identifier: "en_GB")
            self.datePickerView.setValue(self.scheme.colors.text, forKeyPath: "textColor")
            self.datePickerView.addTarget(self,
                                          action: #selector(datePickerValueChanged(_:)),
                                          for: .valueChanged)
            
            
            view.backgroundColor = self.scheme.colors.background
            view.autoresizingMask = [.flexibleHeight]
            view.addSubview(self.datePickerView)
            
            self.datePickerView.translatesAutoresizingMaskIntoConstraints = false
            self.datePickerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            self.datePickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            self.datePickerView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        }
        
        return view
    }
    
    private func autoSelectItem() {
        let index = self.pickItems.firstIndex(of: self.pickedItem) ?? 0
        self.pickerView.selectRow(index, inComponent: 0, animated: false)
        if delegate != nil {
            delegate.pickerKeyboard(self, didPickRowAt: index)
        }
    }
    
    @objc private func tappedCloseButton(_ sender: UIButton) {
        resignFirstResponder()
    }
}

extension PickerKeyboard: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickItems.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: self.pickItems[row], attributes: [NSAttributedString.Key.foregroundColor : self.scheme.colors.text])
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickItems[row] + " " + self.unit
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pickedItem = self.pickItems[row]
        if delegate != nil {
            delegate.pickerKeyboard(self, didPickRowAt: row)
        }
    }
}

extension PickerKeyboard {
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        if delegate != nil {
            delegate.pickerKeyboard(self, didPickDate: sender.date)
        }
    }
}

enum PickerKeyboardScheme {
    case white, black, dark
    
    var colors: PickerKeyboardSchemeColors {
        switch self {
        case .white: return PickerKeyboardSchemeColors(background: .white, text: .black, toolbar: .extraLight)
        case .black: return PickerKeyboardSchemeColors(background: .black, text: .white, toolbar: .regular)
        case .dark:  return PickerKeyboardSchemeColors(background: UIColor(red: 28/255, green: 29/255,  blue: 32/255, alpha: 1.0), text: .white, toolbar: .regular)
        }
    }
}

struct PickerKeyboardSchemeColors {
    var background: UIColor
    var text: UIColor
    var toolbar: UIBlurEffect.Style
}

enum PickerKeyboardType {
    case normal
    case date
}
