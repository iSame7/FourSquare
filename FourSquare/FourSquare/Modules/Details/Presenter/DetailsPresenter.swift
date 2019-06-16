//
//  DetailsPresenter.swift
//  FourSquare
//
//  Created Sameh Mabrouk on 25/05/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//
//  Template generated by Sameh Mabrouk https://github.com/iSame7
//

class DetailsPresenter: DetailsPresenting {
    weak private var view: DetailsViewable?
    var interactor: DetailsInteracting?
    let mapURLHandler: MapURLHandling
    let router: DetailsRouting

    init(view: DetailsViewable, interactor: DetailsInteracting?, mapURLHandler: MapURLHandling, router: DetailsRouting) {
        self.view = view
        self.interactor = interactor
        self.mapURLHandler = mapURLHandler
        self.router = router
    }

    func getVenueDetails(venueId: String) {
        interactor?.fetchVenueDetails(venueId: venueId, completion: { [weak self] (venue, error) in
            if let venue = venue {
                self?.view?.updateWith(viewModel: DetailsViewController.ViewModel(venue: venue, venuePhotoURL: nil))
            } else if let error = error {
                self?.view?.updateWith(error: error)
            }
        })
    }
    
    func showMap(type: MapType, location: Location) {
        mapURLHandler.openMap(location: location, type: type)
    }
    
    func showTipsViewController(tips: [TipItem], venuePhotoURL: String?) {
        guard let detailsViewController = view as? DetailsViewController else { return }

        router.navigateToTipsModule(viewController: detailsViewController, tips: tips, venuePhotoURL: venuePhotoURL)
    }
    
    func dismiss() {
        guard let detailsViewController = view as? DetailsViewController else { return }

        router.navigateToMapModule(navController: detailsViewController.navigationController)
    }
}
