//
//  DashboardViewController.swift
//  TMLI-iOS
//
//  Created by Chris Ferdian on 16/04/20.
//  Copyright © 2020 Netzme. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol DashboardViewControllerDelegate: AnyObject {
    func userDidRequestItemDetail(userProduct: ProductUser?, index: Int?)
}

class DashboardViewController: UIViewController {
    weak var delegate: DashboardViewControllerDelegate?
    var viewModel: DashboardViewModel!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        bindSearchBar()
        populateUserListTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewModel.getUsers().value.count > 0 {
            viewModel.reload()
        }
    }

    private func setupNavigationBar() {
        title = "Dashboard"
        navigationController?.navigationBar.setBarColor(UIColor.hexStringToUIColor(hex: "#007AFF"))
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addHandler))
        setupNavigationBarRightItems(items: addBarButtonItem)
    }

    private func bindSearchBar() {
        searchBar.rx.text.orEmpty
            .subscribe(onNext: { [unowned self] query in
                if query.isEmpty {
                    self.viewModel.reload()
                } else {
                    let filtered = self.viewModel.getUsers().value.filter { (user) -> Bool in
                        (user.name?.hasPrefix(query, caseSensitive: false) ?? false)
                    }
                    self.viewModel.getUsers().accept(filtered)
                }
            }).disposed(by: viewModel.disposeBag)
        
        searchBar.rx.textDidBeginEditing.subscribe(onNext: { () in
            self.searchBar.showsCancelButton = true
        }).disposed(by: viewModel.disposeBag)
        
        searchBar.rx.cancelButtonClicked.subscribe(onNext: { () in
            self.searchBar.text = ""
            self.view.endEditing(true)
            self.searchBar.showsCancelButton = false
        }).disposed(by: viewModel.disposeBag)
    }
    // MARK: - perform a binding from observableUsers from ViewModel to tableView

    private func populateUserListTableView() {
        tableView.register(cellType: DashboardTableViewCell.self)
        tableView
            .rx.setDelegate(self)
            .disposed(by: viewModel.disposeBag)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300

        let observableUsers = viewModel.getUsers().asObservable()
        observableUsers.bind(to: tableView.rx.items(cellIdentifier: "DashboardTableViewCell", cellType: DashboardTableViewCell.self)) { row, element, cell in
            cell.bind(with: element)
            cell.deleteHandler = {
                self.viewModel.removeUser(withIndex: row)
            }
        }
        .disposed(by: viewModel.disposeBag)
    }

    @objc func addHandler() {
        delegate?.userDidRequestItemDetail(userProduct: nil, index: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension DashboardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.viewModel.getUsers().value[indexPath.row]
        self.delegate?.userDidRequestItemDetail(userProduct: user, index: indexPath.row)
    }
}
