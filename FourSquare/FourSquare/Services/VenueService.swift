//
//  VenueService.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 14/04/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import Foundation
import Alamofire

protocol VenueFetching {
    func fetchVenues(coordinate: String, completion: @escaping ([Venue]) -> Void)
    func fetchVenuePhotos(venueId: String, completion: @escaping ([Photo]) -> Void)
}

class VenuService: VenueFetching {
    func fetchVenues(coordinate: String, completion: @escaping ([Venue]) -> Void) {
        Alamofire.request(Router.fetchRestaurants(coordinates: coordinate)).responseJSON { (response) in
         
            if response.result.isSuccess {
                if let data = response.data {
                    do {
                        let JSON = try JSONDecoder().decode(SearchResult.self, from: data)
                        let venues = JSON.response.venues
                        completion(venues)
                    }
                    catch {print("Error processing data \(error)")}
                }
            } else {
                print("Error\(String(describing: response.result.error))")
                completion([Venue]())
            }
        }
    }
    
    func fetchVenuePhotos(venueId: String, completion: @escaping ([Photo]) -> Void) {
        Alamofire.request(Router.fetchPhotos(venueId: venueId)).responseJSON { (response) in
            
            if response.result.isSuccess {
                if let data = response.data {
                    do {
                        let JSON = try JSONDecoder().decode(VenuePhotoResponse.self, from: data)
                        let photos = JSON.response.photos?.items
                        completion(photos ?? [Photo]())
                    }
                    catch {print("Error processing data \(error)")}
                }
            } else {
                print("Error\(String(describing: response.result.error))")
                completion([Photo]())
            }
        }
    }
}
