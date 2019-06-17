//
//  MockVenueService.swift
//  FourSquareTests
//
//  Created by Sameh Mabrouk on 17/06/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import Foundation
@testable import FourSquare

class MockVenueService: VenueFetching {
    let mockPhoto1 = Photo(id: "4fe03279e4b0690a86767319", prefix: "https://fastly.4sqi.net/img/general/", suffix: "/WfIypTz_PxPvh75QSIBwomCu-jK_72UDiBauHc6L1dU.jpg", width: 720, height: 540, visibility: "public", source: Source(name: "Foursquare for iOS", url: "https://foursquare.com/download/#/iphone"))
    let mockPhoto2 = Photo(id: "51dbe1e9498e361de7fccbb7", prefix: "https://fastly.4sqi.net/img/general/", suffix: "/9664729_cr9GMPE2yxpPO_e4CFx5xtyNdjWqNQa06SZBO3aFbio.jpg", width: 720, height: 720, visibility: "public", source: Source(name: "Foursquare for iOS", url: "https://foursquare.com/download/#/iphone"))
    
    let mockVenue1 = Venue(id: "123", name: "Restaurant A", contact: nil, location: Location(lat: 52.36795609763071, lng: 4.895555168247901, address: "Nieuwe Doelenstraat 20-22", crossStreet: nil, distance: nil, postalCode: "1012 CP", cc: nil, city: "Amsterdam", state: "North Holland", country: "Netherlands"), categories: [Category(id: "4bf58dd8d48988d16d941735", name: "Café", pluralName: "Cafés", shortName: "Café", icon: Category.Icon(prefix: "https://fastly.4sqi.net/img/general/", suffix: "/WfIypTz_PxPvh75QSIBwomCu-jK_72UDiBauHc6L1dU.jpg"), primary: nil)], verified: false, url: nil, stats: nil, likes: nil, rating: nil, hours: nil, photos: nil, tips: Tips(count: 200, groups: [TipsGroup(type: "others", name: "All tips", count: 200, items: [TipItem(createdAt: "51ff9e94498e0b4338baae56", text: "There is simply nowhere else in Europe where you can get clover coffee. The clover (brewing vacuum system) is a true innovation that would be the envy of any caffeineomaniac.", user: User(firstName: "citizenM", photo: UserPhoto(prefix: "https://fastly.4sqi.net/img/user/", suffix: "/EYAWFQEUSYQ0TE5Y.jpg")))])]))
    
    let mockVenue2 = Venue(id: "4f019124a69d45461f2458e7", name: "Starbucks", contact: nil, location: Location(lat: 52.36607678472145, lng: 4.897430803910262, address: "Utrechtsestraat 9", crossStreet: nil, distance: nil, postalCode: "1017 CV", cc: nil, city: "Amsterdam", state: "North Holland", country: "Netherlands"), categories: [Category(id: "4bf58dd8d48988d16d941735", name: "Coffee Shops", pluralName: "Coffee Shops", shortName: "Coffee Shops", icon: Category.Icon(prefix: "https://ss3.4sqi.net/img/categories_v2/food/coffeeshop_", suffix: ".png"), primary: nil)], verified: false, url: nil, stats: nil, likes: nil, rating: nil, hours: nil, photos: nil, tips: Tips(count: 200, groups: [TipsGroup(type: "others", name: "All tips", count: 200, items: [TipItem(createdAt: "51ff9e94498e0b4338baae56", text: "There is simply nowhere else in Europe where you can get clover coffee. The clover (brewing vacuum system) is a true innovation that would be the envy of any caffeineomaniac.", user: User(firstName: "citizenM", photo: UserPhoto(prefix: "https://fastly.4sqi.net/img/user/", suffix: "/EYAWFQEUSYQ0TE5Y.jpg")))])]))
    func fetchVenuePhotos(venueId: String, completion: @escaping ([Photo]) -> Void) {
        completion([mockPhoto1, mockPhoto2])
    }
    
    func fetchVenues(coordinate: String, completion: @escaping ([Venue]?, FoursquareError?) -> Void) {
        if !coordinate.isEmpty {
            completion([mockVenue1, mockVenue2], nil)
        } else {
            completion(nil, .noResponse)
        }
    }
    
    func fetchVenueDetails(venueId: String, completion: @escaping ((Venue?, FoursquareError?) -> Void)) {
        if !venueId.isEmpty {
            completion(mockVenue1, nil)
        } else {
            completion(nil, .noResponse)
        }
    }
}
