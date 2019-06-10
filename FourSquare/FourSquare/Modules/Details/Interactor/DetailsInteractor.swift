//
//  DetailsInteractor.swift
//  FourSquare
//
//  Created Sameh Mabrouk on 25/05/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//
//  Template generated by Sameh Mabrouk https://github.com/iSame7
//

class DetailsInteractor: DetailsInteracting {
    weak var presenter: DetailsPresenting?
    private let venueService: VenueFetching
    
    init(venueService: VenueFetching) {
        self.venueService = venueService
    }

}