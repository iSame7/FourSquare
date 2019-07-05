//
//  DetailsViewable.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 04/07/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

protocol DetailsViewable: class {
    var presenter: DetailsPresenting?  { get set }
    func updateWith(viewModel: DetailsViewController.ViewModel)
    func updateWith(error: FoursquareError)
}
