//
//  MapViewController.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 26/03/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var presenter: MapPresenting!
    var venues = [Venue]()
    var venuePhotos : [String: String] = [:]
    var indexOfCellBeforeDragging = 0
    var scrollToItem = true
    var selectedItemIndex: Int = 0 {
        didSet {
            selectAnnotation(atIndext: selectedItemIndex)
        }
    }
    
    private var annotationsForVenues = [MKAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureCollectionViewLayoutItemSize()
    }
}

// MARK: - MapViewable
extension MapViewController: MapViewable {
    func updateUserLocation(_ locationViewModel: MapViewController.LocationViewModel) {
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let coordinates = CLLocationCoordinate2D(latitude: locationViewModel.lat, longitude: locationViewModel.lng)
        let viewRegion = MKCoordinateRegion(center: coordinates, span: span)
        mapView.setRegion(viewRegion, animated: true)
        
        let coordinate = "\(locationViewModel.lat),\(locationViewModel.lng)"
        presenter.getRestaurantsAround(coordinate: coordinate)
    }
    
    func showError(error: FoursquareError) {
        if let errorDescription = error.errorDescription, let errorTitle = error.errorUserInfo[NSLocalizedDescriptionKey] as? String {
            InAppNotifications.showNotification(type: InAppNotifications.error, title: errorTitle, message: errorDescription, dismissDelay: 3)
        }
    }
    func update(_ model: [Venue]) {
        print("Add venues on map")
        venues = model
        addAnnotationsToMap(venues: model)
        for venue in venues {
            print("get photo for venueId: \(venue.id)")
//            presenter.getPhotos(venueId: venue.id)
        }
        collectionView.reloadData()
    }
    
    func update(with photo: String, for venueId: String) {
        venuePhotos[venueId] = photo
    }
    
    private func addAnnotationsToMap(venues: [Venue]){
        mapView.delegate = self
        venues.forEach { (venue) in
            let venueAnnotation = VenueAnnotation(coordinate: CLLocationCoordinate2D(latitude: venue.location.lat, longitude: venue.location.lng), title: venue.name, subtitle: venue.contact?.formattedPhone ?? "", category: venue.categories.first?.id ?? "")
            annotationsForVenues.append(venueAnnotation)
        }
        DispatchQueue.main.async {
            self.mapView.addAnnotations(self.annotationsForVenues)
        }
    }
}

// MARK: MapView Delegate
extension MapViewController : MKMapViewDelegate {
    //view for each annotation
    internal func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //this keeps the user location point as a default blue dot.
        if annotation is MKUserLocation { return nil }
        
        //setup annotation view for map - we can fully customize the marker
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "PlaceAnnotationView") as? MKMarkerAnnotationView
        
        //setup annotation view
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "PlaceAnnotationView")
            if let venueAnnotation = annotation as? VenueAnnotation, let imageType = ImageType(rawValue: venueAnnotation.category ?? "")  {
                annotationView?.glyphImage = UIImage.glyphFor(imageType: imageType)
            } else {
                annotationView?.glyphImage = #imageLiteral(resourceName: "restaurant")
            }
            annotationView?.canShowCallout = false
            annotationView?.animatesWhenAdded = true
            annotationView?.markerTintColor = UIColor.orange
            annotationView?.isHighlighted = true
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    //callout tapped/selected
    internal func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
    }
    
    
    //didSelect - setting currentSelected Venue
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if scrollToItem {
            if let venueAnnotation = view.annotation as? VenueAnnotation {
                let selectedVenueIndex = venues.firstIndex(where: { $0.name == venueAnnotation.title })
                let indexPath = IndexPath(row: selectedVenueIndex ?? 0, section: 0)
                collectionViewLayout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }
    }
    
    func selectAnnotation(atIndext index: Int) {
        scrollToItem = false
        if let annotation = (mapView.annotations.first { (annotation) -> Bool in
            let venueAnnotation = annotation as? VenueAnnotation
            return venueAnnotation?.title == venues[index].name
        }) {
            mapView.selectAnnotation(annotation, animated: true)
            scrollToItem = true
            
            let venueAnnotation = annotation as? VenueAnnotation
            let selectedVenue = venues.first(where: { $0.name == venueAnnotation?.title })

            if let selectedVenue = selectedVenue {
                let selectedVenueLocation = CLLocation(latitude: CLLocationDegrees(selectedVenue.location.lat), longitude: CLLocationDegrees(selectedVenue.location.lng))
                // only move to another region if the selected venue's location in not in the current map region
                if !regionContains(region: mapView.region, location: selectedVenueLocation) {
                    let coordinates = CLLocationCoordinate2D(latitude: selectedVenue.location.lat, longitude: selectedVenue.location.lng)
                    let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                    let viewRegion = MKCoordinateRegion(center: coordinates, span: span)
                    mapView.setRegion(viewRegion, animated: true)
                }
            }
        }
    }
    
    /* Standardises and angle to [-180 to 180] degrees */
    func standardAngle( angle: inout CLLocationDegrees) -> CLLocationDegrees {
        angle = angle.truncatingRemainder(dividingBy: 360)
        return angle < -180 ? -360 - angle : angle > 180 ? 360 - 180 : angle
    }
    
    /* confirms that a region contains a location */
    func regionContains(region: MKCoordinateRegion, location: CLLocation) -> Bool {
        var latitudeAngleDiff = region.center.latitude - location.coordinate.latitude
        let deltaLat = abs(standardAngle(angle: &latitudeAngleDiff))
        var longitudeAngleDiff = region.center.longitude - location.coordinate.longitude
        let deltalong = abs(standardAngle(angle:&longitudeAngleDiff))
        return region.span.latitudeDelta >= deltaLat && region.span.longitudeDelta >= deltalong
    }
}

// MARK: - StoryboardInstantiatable
extension MapViewController: StoryboardInstantiatable {
    static var instantiateType: StoryboardInstantiateType {
        return .initial
    }
}

// MARK: -
extension MapViewController {
    struct ViewModel {
        let venues: [Venue]
    }
    struct LocationViewModel {
        let lat: Double
        let lng: Double
    }
}
