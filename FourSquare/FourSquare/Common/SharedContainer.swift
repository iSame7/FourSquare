//
//  SharedContainer.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 02/04/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import Swinject

extension Container {
    static let shared: Container = {
        let c = Container()
        
        c.register(MapView.self, factory: { _ in
            MapViewController()
        }).inObjectScope(.container)
        
        c.register(MapInteracting.self, factory: { _ in
            MapInteractor()
        }).inObjectScope(.container)

        c.register(MapPresenting.self, factory: { r in
                MapPresenter(view: r.resolve(MapView.self)!, mapInteractor: r.resolve(MapInteracting.self)!)

        }).inObjectScope(.container)

        return c 
    }()
}
