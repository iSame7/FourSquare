//
//  MapPresenter.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 26/03/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

class MapPresenter: MapPresenting {
    private weak var view: MapView?
    private let mapInteractor: MapInteracting
    
    init(view: MapView, mapInteractor: MapInteracting) {
        self.view = view
        self.mapInteractor = mapInteractor
    }
    
    func viewDidLoad() {
        
    }
}

