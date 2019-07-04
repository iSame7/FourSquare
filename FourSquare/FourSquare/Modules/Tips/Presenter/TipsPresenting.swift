//
//  TipsPresenting.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 05/07/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

protocol TipsPresenting: class {
    func buildVenueTableHeaderViewModel(title: String, description: String, imageURL: String?) -> VenueUITableHeaderView.ViewModel
    func buildTipTableCellViewModel(userName: String, userImageURL: String, createdAt: String, tipText: String) -> TipTableViewCell.ViewModel
    func dismiss()
}
