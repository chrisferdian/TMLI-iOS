//
//  DetailViewController.swift
//  TMLI-iOS
//
//  Created by Chris Ferdian on 16/04/20.
//  Copyright © 2020 Netzme. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class DetailViewController: UIViewController {
    /**
     - Personal Info
     */
    @IBOutlet weak var fieldName: UITextField!
    @IBOutlet weak var fieldDateOfBirth: DateTextField!
    @IBOutlet weak var viewPersonalInfo: UIView!
    /**
     -Products Selection
     */
    @IBOutlet weak var fieldProducts: OptionsTextField!
    @IBOutlet weak var viewProducts: UIView!
    /**
     -Product Info
     */
    @IBOutlet weak var fieldActivityType: OptionsTextField!
    @IBOutlet weak var fieldActivityDate: DateTextField!
    @IBOutlet weak var fieldStartTime: DateTextField!
    @IBOutlet weak var fieldEndTime: DateTextField!
    @IBOutlet weak var fieldPlace: UITextField!
    @IBOutlet weak var fieldProductCode: UITextField!
    @IBOutlet weak var fieldReason: UITextField!
    @IBOutlet weak var fieldPlanToStart: UITextField!
    @IBOutlet weak var fieldPrice: UITextField!
    @IBOutlet weak var fieldHowLong: OptionsTextField!
    @IBOutlet weak var viewProductInfo: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var viewModel: DetailViewModel!
    private let minimalUsernameLength = 5
    private let throttleIntervalInMilliseconds = 100
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupNavigationBar()
        fieldProducts.setCollectionsArray(with: [], with: viewModel.disposable)
        fieldActivityType.setCollectionsArray(with: ["---Select Activity---", "Meeting", "Call", "Email"], with: viewModel.disposable)
        fieldHowLong.setCollectionsArray(with: ["---Select How Long---", "12 Bulan", "24 Bulan", "36 Bulan", "48 Bulang"], with: viewModel.disposable)
        
        bind(textField: fieldName, to: viewModel.userName)
        bind(textField: fieldDateOfBirth, to: viewModel.userDoB)
        bind(textField: fieldProducts, to: viewModel.productSelection)
        bind(textField: fieldActivityType, to: viewModel.activityType)
        bind(textField: fieldActivityDate, to: viewModel.activityDate)
        bind(textField: fieldStartTime, to: viewModel.startTime)
        bind(textField: fieldEndTime, to: viewModel.endTime)
        bind(textField: fieldPlace, to: viewModel.place)
        bind(textField: fieldProductCode, to: viewModel.productCode)
        bind(textField: fieldReason, to: viewModel.reason)
        bind(textField: fieldPlanToStart, to: viewModel.planToStart)
        bind(textField: fieldPrice, to: viewModel.price)
        bind(textField: fieldHowLong, to: viewModel.howLong)
        
        bindProductSectionState()
        bindProductInfoState()
    }
    
    private func setupScrollView() {
        scrollView.keyboardDismissMode = .interactive
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShowOrHide(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShowOrHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    @objc func keyboardWillShowOrHide(notification: NSNotification) {
        
        // Pull a bunch of info out of the notification
        if let scrollView = scrollView, let userInfo = notification.userInfo, let endValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey], let durationValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] {
            
            // Transform the keyboard's frame into our view's coordinate system
            let endRect = view.convert((endValue as AnyObject).cgRectValue, from: view.window)
            
            // Find out how much the keyboard overlaps the scroll view
            // We can do this because our scroll view's frame is already in our view's coordinate system
            let keyboardOverlap = scrollView.frame.maxY - endRect.origin.y
            
            // Set the scroll view's content inset to avoid the keyboard
            // Don't forget the scroll indicator too!
            scrollView.contentInset.bottom = keyboardOverlap
            scrollView.scrollIndicatorInsets.bottom = keyboardOverlap
            
            guard let duration = (durationValue as AnyObject).doubleValue else { return }
            UIView.animate(withDuration: duration, delay: 0, options: .beginFromCurrentState, animations: {
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    private func bindProductInfoState() {
        let validProductSelection = fieldProducts.rx.text.map { $0?.count ?? 0 < 1 }
        validProductSelection
            .bind(to: viewProductInfo.rx.isHidden).disposed(by: disposeBag)
        
        let productSelectedAValid: Observable<Bool> = fieldProducts.rx.text
            .map { _ -> Bool in
                if self.fieldProducts.text?.elementsEqual("A") ?? true {
                    return false
                }
                return true
            }.share(replay: 1)
        productSelectedAValid
            .bind(to: fieldProductCode.rx.isHidden)
            .disposed(by: viewModel.disposable)
        productSelectedAValid
            .bind(to: fieldReason.rx.isHidden)
            .disposed(by: viewModel.disposable)
        productSelectedAValid
            .bind(to: fieldPlanToStart.rx.isHidden)
            .disposed(by: viewModel.disposable)
        
        let productSelectedBValid: Observable<Bool> = fieldProducts.rx.text
            .map { _ -> Bool in
                if self.fieldProducts.text?.elementsEqual("B") ?? true {
                    return false
                }
                return true
            }.share(replay: 1)
        productSelectedBValid
            .bind(to: fieldPrice.rx.isHidden)
            .disposed(by: viewModel.disposable)
        productSelectedBValid
            .bind(to: fieldHowLong.rx.isHidden)
            .disposed(by: viewModel.disposable)
        
        let activityValid: Observable<Bool> = fieldActivityType.rx.text
            .map { _ -> Bool in
                if self.fieldActivityType.text?.elementsEqual("Meeting") ?? true {
                    return false
                }
                return true
            }.share(replay: 1)
        activityValid
            .bind(to: fieldPlace.rx.isHidden)
            .disposed(by: viewModel.disposable)
    }
    
    private func bindProductSectionState() {
        let userAgeValid: Observable<Bool> = fieldDateOfBirth.rx.text
            .map { _ -> Bool in
                if let dateTemp =  self.viewModel.userDoB.value.toDate() {
                    self.fieldDateOfBirth.date = dateTemp
                }
                if self.fieldName.text?.isEmpty ?? true {
                    switch self.fieldDateOfBirth.asAge() {
                    case 18...23:
                        self.fieldProducts.updateCollectionArray(with: ["--Select Product---", "A"])
                        return true
                    case 25...30:
                        self.fieldProducts.updateCollectionArray(with: ["--Select Product---", "B"])
                        return true
                    default:
                        return true
                    }
                }
                switch self.fieldDateOfBirth.asAge() {
                case 0...18:
                    return true
                case 18...23:
                    self.fieldProducts.updateCollectionArray(with: ["--Select Product---", "A"])
                    return false
                case 24:
                    return true
                case 25...30:
                    self.fieldProducts.updateCollectionArray(with: ["--Select Product---", "B"])
                    return false
                default:
                    return true
                }
            }.share(replay: 1)
        
        let userNameValid: Observable<Bool> = fieldName.rx.text
            .map { text -> Bool in
                if self.fieldDateOfBirth.text?.isEmpty ?? true {
                    return true
                }
                if text?.isEmpty ?? true {
                    return true
                } else {
                    return false
                }
            }.share(replay: 1)
        
        userAgeValid
            .bind(to: viewProducts.rx.isHidden)
            .disposed(by: disposeBag)
        userNameValid
            .bind(to: viewProducts.rx.isHidden)
            .disposed(by: viewModel.disposable)
    }
    
    private func bind(textField: UITextField, to behaviorRelay: BehaviorRelay<String>) {
        behaviorRelay.asObservable()
            .bind(to: textField.rx.text)
            .disposed(by: disposeBag)
        textField.rx.text.orEmpty.bind(to: behaviorRelay)
            .disposed(by: disposeBag)
    }
    
    private func bindTextFieldProduct() {
        fieldProducts.rx.text.orEmpty
            .bind(to: viewModel.productSelection)
            .disposed(by: viewModel.disposable)
    }
    
    private func setupNavigationBar() {
        title = "Create / Update Data"
        let addBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(addHandler))
        self.setupNavigationBarRightItems(items: addBarButtonItem)
    }
    
    @objc func addHandler() {
        viewModel.user != nil ? viewModel.updateUser() : viewModel.addUser()
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    deinit {
        // Don't have to do this on iOS 9+, but it still works
        NotificationCenter.default.removeObserver(self)
    }
}
