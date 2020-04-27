//
//  TextViewPlaceholder.swift
//  TMLI-iOS
//
//  Created by Chris Ferdian on 26/04/20.
//  Copyright © 2020 Netzme. All rights reserved.
//

import Foundation
import UIKit

open class TextViewPlaceholder: UITextView {
    // MARK: - Properties
    public var resignFirstResponderTimeAnimate: TimeInterval = 0.25
    public var becomeFirstResponderTimeAnimate: TimeInterval = 0.25
    /**
         * Bottom line at the bottom of textField
         */
        var fieldBorderColor = UIColor.hexStringToUIColor(hex: "#E0E0E0")
    //
        /**
         * Width of bottom line
         */
    var fieldBorderWidth: Double = 1.0
    /// A UILabel that holds the InputTextView's placeholder text
    open var placeholderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.text = "Aa"
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// The placeholder text that appears when there is no text
    @IBInspectable open var placeholder: String? = "Aa" {
        didSet {
            if attributedPlaceholder == nil {
                placeholderLabel.text = placeholder
            }
        }
    }
    
    /// The placeholderLabel's textColor
    @IBInspectable open var placeholderTextColor: UIColor? = .lightGray {
        didSet {
            placeholderLabel.textColor = placeholderTextColor
        }
    }
    
    /// The attributed placeholder
    open var attributedPlaceholder: NSAttributedString? {
        didSet {
            placeholderLabel.attributedText = attributedPlaceholder
        }
    }
    
    /// The text of the UITextView.
    open override var text: String! {
        didSet {
            textDidChange()
        }
    }
    
    /// The attributed text of the UITextView.
    open override var attributedText: NSAttributedString! {
        didSet {
            textDidChange()
        }
    }
    
    /// The font of the UITextView. When set the placeholderLabel's font is also updated
    open override var font: UIFont! {
        didSet {
            placeholderLabel.font = font
        }
    }
    
    /// The textAlignment of the InputTextView. When set the placeholderLabel's textAlignment is also updated
    open override var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }
    
    /// The Text Container Inset.  When update textContainerInset we will update placholer constaints
    open override var textContainerInset: UIEdgeInsets {
        didSet {
            updatePlaceholderLabelConstraints()
        }
    }
    
    open var textContainerLineFragmentPadding: CGFloat = 5 {
        didSet {
            textContainer.lineFragmentPadding = textContainerLineFragmentPadding
            updatePlaceholderLabelConstraints()
        }
    }
    
    /// The constraints of the placeholderLabel
    private var placeholderLabelTopConstraint: NSLayoutConstraint!
    private var placeholderLabelBottomConstraint: NSLayoutConstraint!
    private var placeholderLabelLeadingConstraint: NSLayoutConstraint!
    private var placeholderLabelTrailingConstraint: NSLayoutConstraint!
    private var placeholderLabelWidthConstraint: NSLayoutConstraint!
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    open override func becomeFirstResponder() -> Bool {
        if !canBecomeFirstResponder { return false }
        
        UIView.animate(withDuration: becomeFirstResponderTimeAnimate, animations: {
            super.becomeFirstResponder()
        })
        
        return true
    }
    
    // Override resignFirstResponder to set animation duration to zero
    open override func resignFirstResponder() -> Bool {
        if !canResignFirstResponder { return false }
        
        UIView.animate(withDuration: resignFirstResponderTimeAnimate, animations: {
            super.resignFirstResponder()
        })
        
        return true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: nil)
    }
}

extension TextViewPlaceholder {
    /// Sets up the default properties
    fileprivate func setup() {
        setupUI()
        isEditable = true
        isSelectable = true
        isScrollEnabled = true
        scrollsToTop = false
        isDirectionalLockEnabled = true
        backgroundColor = .clear
        layoutManager.allowsNonContiguousLayout = false
        translatesAutoresizingMaskIntoConstraints = false
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange),
                                               name: UITextView.textDidChangeNotification,
                                               object: nil)
        
        scrollIndicatorInsets = UIEdgeInsets(top: .leastNonzeroMagnitude,
                                             left: .leastNonzeroMagnitude,
                                             bottom: .leastNonzeroMagnitude,
                                             right: .leastNonzeroMagnitude)
        
        placeholderLabel.font = font
        placeholderLabel.textColor = placeholderTextColor
        placeholderLabel.textAlignment = textAlignment
        placeholderLabel.text = placeholder
        placeholderLabel.numberOfLines = 0
        addSubview(placeholderLabel)
        setPlaceholderLabelConstraints()
    }
    
    /// Set up constraints for placeholderLabel
    private func setPlaceholderLabelConstraints() {
        placeholderLabelTopConstraint = placeholderLabel.topAnchor
            .constraint(equalTo: topAnchor, constant: textContainerInset.top)
        placeholderLabelBottomConstraint = placeholderLabel.bottomAnchor
            .constraint(equalTo: bottomAnchor, constant: -textContainerInset.bottom)
        placeholderLabelLeadingConstraint = placeholderLabel.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: textContainerInset.left + textContainer.lineFragmentPadding)
        placeholderLabelTrailingConstraint = placeholderLabel.trailingAnchor
            .constraint(equalTo: trailingAnchor, constant: -(textContainerInset.right + textContainer.lineFragmentPadding))
        
        placeholderLabelWidthConstraint = placeholderLabel.widthAnchor
            .constraint(equalTo: widthAnchor, multiplier: 1.0,
                        constant: -(textContainerInset.left + textContainerInset.right + textContainer.lineFragmentPadding * 2))
        
        placeholderLabelTopConstraint.isActive = true
        placeholderLabelBottomConstraint.isActive = true
        placeholderLabelLeadingConstraint.isActive = true
        placeholderLabelTrailingConstraint.isActive = true
        placeholderLabelWidthConstraint.isActive = true
    }
    
    /// Updates the placeholderLabel constraints constants to match the textContainerInset and textContainer
    private func updatePlaceholderLabelConstraints() {
        placeholderLabelTopConstraint.constant = textContainerInset.top
        placeholderLabelBottomConstraint.constant = -textContainerInset.bottom
        placeholderLabelLeadingConstraint.constant = textContainerInset.left + textContainer.lineFragmentPadding
        placeholderLabelTrailingConstraint.constant = -(textContainerInset.right + textContainer.lineFragmentPadding)
        placeholderLabelWidthConstraint.constant = -(textContainerInset.left + textContainerInset.right + textContainer.lineFragmentPadding * 2)
    }
    /** this function responsible to draw line to the view without change a class of the view.
     * - author: Chris Ferdian <chrisferdian@onoff.insure>
     */
    func setupUI() {
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
    @objc private func textDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
}
