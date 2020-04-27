//
//  DashboardTableViewCell.swift
//  TMLI-iOS
//
//  Created by Chris Ferdian on 16/04/20.
//  Copyright © 2020 Netzme. All rights reserved.
//

import UIKit

class DashboardTableViewCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelActivityType: UILabel!
    @IBOutlet weak var labelProductName: UILabel!
    
    var deleteHandler:(()->Void)!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func bind(with user: ProductUser) {
        self.labelName.text = user.name
        self.labelDate.text = user.date?.toString()
        self.labelActivityType.text = user.productType
        self.labelProductName.text = user.product
    }
    
    @IBAction func deleteTapped() {
        self.deleteHandler()
    }
}
