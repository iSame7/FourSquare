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
        
        c.register(MapBuilding.self, factory: { r in
            MapBuilder(container: c)
        }).inObjectScope(.container)
        
        c.register(DetailsBuilding.self, factory: { r in
            DetailsBuilder(container: c)
        }).inObjectScope(.container)
        
        c.register(TipsBuilding.self, factory: { r in
            TipsBuilder(container: c)
        }).inObjectScope(.container)
        
        return c 
    }()
}
