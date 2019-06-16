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
    func fetchVenues(coordinate: String, completion: @escaping ([Venue]?, FoursquareError?) -> Void)
    func fetchVenuePhotos(venueId: String, completion: @escaping ([Photo]) -> Void)
    func fetchVenueDetails(venueId: String, completion: @escaping ((Venue?, FoursquareError?) -> Void ))
}

class VenuService: VenueFetching {
    let sessionManager: SessionManager
    let requestRetrier: RequestRetrier
    let networkRechabilityManager: NetworkReachabilityManager
    
    init(sessionManager: SessionManager, requestRetrier: RequestRetrier, networkRechabilityManager: NetworkReachabilityManager) {
        self.sessionManager = sessionManager
        self.requestRetrier = requestRetrier
        self.networkRechabilityManager = networkRechabilityManager
        
        self.sessionManager.retrier = self.requestRetrier
    }
    
    func fetchVenues(coordinate: String, completion: @escaping ([Venue]?, FoursquareError?) -> Void) {
        sessionManager.request(Router.fetchRestaurants(coordinates: coordinate)).responseJSON { [weak self] (response) in
            
            if response.result.isSuccess {
                if let data = response.data {
                    do {
                        let JSON = try JSONDecoder().decode(SearchResult.self, from: data)
                        let venues = JSON.response.venues
                        completion(venues, nil)
                    }
                    catch {
                        print("Error processing data \(error)")
                        completion(nil, .JSONParsing)
                    }
                }
            } else {
                print("Error\(String(describing: response.result.error))")
                if response.result.error?.code == -1009 {
                    completion(nil, .noInternetConnection)
                } else {
                    completion(nil, .noResponse)
                }
            }
        }
    }
    
    func fetchVenuePhotos(venueId: String, completion: @escaping ([Photo]) -> Void) {
        sessionManager.request(Router.fetchPhotos(venueId: venueId)).responseJSON { (response) in
            
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
    
    func fetchVenueDetails(venueId: String, completion: @escaping ((Venue?, FoursquareError?) -> Void)) {
        sessionManager.request(Router.fetchDetails(venueId: venueId)).responseJSON { [weak self] (response) in
            
            if response.result.isSuccess {
                if let data = response.data {
                    do {
                        let JSON = try JSONDecoder().decode(DetailsResult.self, from: data)
                        let venue = JSON.response.venue
                        completion(venue, nil)
                    }
                    catch {
                        print("Error processing data \(error)")
                        completion(nil, .JSONParsing)
                    }
                }
            } else {
                completion(nil, .noResponse)
            }
        }
    }
}
