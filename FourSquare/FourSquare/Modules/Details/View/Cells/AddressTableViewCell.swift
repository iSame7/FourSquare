//
//  AddressTableViewCell.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 02/06/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import UIKit

class AddressTableViewCell: UITableViewCell {
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var postalCodeLabel: UILabel!
    
    struct ViewModel {
        let address: String
        let categories: String
        let hours: String
        let postalCode: String
    }
    
    func setup(with viewModel: ViewModel) {
        addressLabel.text = viewModel.address
        categoriesLabel.text = viewModel.categories
        hoursLabel.text = viewModel.hours
        postalCodeLabel.text = viewModel.postalCode
    }
}
