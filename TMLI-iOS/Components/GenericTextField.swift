//
//  GenericTextField.swift
//  TMLI-iOS
//
//  Created by Chris Ferdian on 16/04/20.
//  Copyright © 2020 Netzme. All rights reserved.
//

import UIKit

@IBDesignable
class GenericTextField: UITextField, UITextFieldDelegate {
    /**
     * Bottom line at the bottom of textField
     */
    var fieldBorderColor = UIColor.hexStringToUIColor(hex: "#E0E0E0")
//
    /**
     * Width of bottom line
     */
    var fieldBorderWidth: Double = 1.0
    let labelError = UILabel()
    
    /**
     * Call designated initializer
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
        setupUI()
        self.font = UIFont.systemFont(ofSize: 12)
        self.textColor = UIColor.hexStringToUIColor(hex: "#212121")
    }
    
    /**
     * Initialize for programmatically
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        setupUI()
        self.font = UIFont.systemFont(ofSize: 12)
        self.textColor = UIColor.hexStringToUIColor(hex: "#212121")
    }
    
    /**
     * This function called when user start editing textField
     */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        fieldBorderColor = UIColor.hexStringToUIColor(hex: "#333366")
        setupUI()
        removeError()
    }
    
    /**
     * This function called when user finish editing textField
     */
    func textFieldDidEndEditing(_ textField: UITextField) {
        fieldBorderColor = UIColor.hexStringToUIColor(hex: "#E0E0E0")
        setupUI()
    }
    
    /** this function responsible to draw line to the view without change a class of the view.
     * - author: Chris Ferdian <chrisferdian@onoff.insure>
     */
    func setupUI() {
        borderStyle = .none
        let lineView = UIView()
        lineView.backgroundColor = borderColor
        lineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(lineView)
        
        let metrics = ["width": NSNumber(value: fieldBorderWidth)]
        let views = ["lineView": lineView]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: views))
        createLabelFloating()
        // Write toolbar code for done button
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onClickDoneButton))
        toolBar.setItems([space, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        inputAccessoryView = toolBar
    }
    
    //Toolbar done button function
    @objc func onClickDoneButton() {
        self.endEditing(true)
    }
    /**
     * Create label on top of textField
     * - author: Chris Ferdian <chrisferdian@onoff.insure>
     */
    private func createLabelFloating() {
        let label = UILabel()
        let placeholderText = placeholder
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = placeholderText
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.hexStringToUIColor(hex: "#9E9E9E")
        addSubview(label)
        label.bottomAnchor.constraint(equalTo: topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        placeholder = ""
    }
    
    /**
     * Create label at the bottom
     */
    public func createBottomNote(message: String) {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = message
        label.textColor = UIColor.hexStringToUIColor(hex: "#9E9E9E")
        addSubview(label)
        label.topAnchor.constraint(equalTo: bottomAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    }
    
    /**
     * Create error message at the bottom
     */
    public func setErrorNote(message: String) {
        labelError.font = UIFont.systemFont(ofSize: 12)
        labelError.translatesAutoresizingMaskIntoConstraints = false
        labelError.text = message
        labelError.textColor = .red
        addSubview(labelError)
        labelError.topAnchor.constraint(equalTo: bottomAnchor, constant: 2).isActive = true
        labelError.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        UIView.animate(withDuration: 0.2, animations: {
            self.setupUI()
        })
    }
    
    public func removeError() {
        fieldBorderColor = UIColor.hexStringToUIColor(hex: "#E0E0E0")
        setErrorNote(message: "")
    }
}
