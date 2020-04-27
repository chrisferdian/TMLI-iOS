
//
//  OptionsTextField.swift
//  TMLI-iOS
//
//  Created by Chris Ferdian on 25/04/20.
//  Copyright © 2020 Netzme. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OptionsTextField: GenericTextField {
    var selectedData: String?
    let items = BehaviorRelay(value: [String]())
    var pickerView = UIPickerView()

    /**
     * Call designated initializer
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    /**
     * Initialize for programmatically
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    func createPickerView() {
//        pickerView.delegate = self
        inputView = pickerView
    }
    
    private func initialize() {
        createPickerView()
    }
    
    func updateCollectionArray(with data:[String]) {
        self.items.accept(data)
        
    }
    
    func setCollectionsArray(with data: [String], with dispose: DisposeBag) {
        self.items.accept(data)
        items.asObservable()
        .bind(to: pickerView.rx.itemTitles) { (row, element) in
            return element
        }
        .disposed(by: dispose)
        
        pickerView.rx.itemSelected.asObservable().subscribe(onNext: {item in
            if item.row != 0 {
                self.text = self.items.value[item.row]
            }
        }).disposed(by: dispose)
        
//        pickerView.rx.modelSelected(String.self)
//        .subscribe(onNext: { models in
//            
//        })
//        .disposed(by: dispose)
    }
}
