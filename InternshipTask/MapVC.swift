//
//  MapVC.swift
//  InternshipTask
//
//  Created by Mihir Luthra on 15/06/20.
//  Copyright © 2020 Mihir Luthra. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {

	var searchString : String?
	
	@IBOutlet weak var mapView: MKMapView!
	
	
	override func viewDidLoad() {
        super.viewDidLoad()

		let request = MKLocalSearch.Request()
		request.naturalLanguageQuery = searchString
	
		let search = MKLocalSearch(request: request)
		search.start { response, _ in
			guard let response = response else {
				print("Unable to get location")
				return
			}
			let placemark = response.mapItems[0].placemark
			self.mapView.removeAnnotations(self.mapView.annotations)
			let annotation = MKPointAnnotation()
			annotation.coordinate = placemark.coordinate
			annotation.title = placemark.name
			
			self.mapView.addAnnotation(annotation)
			let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
			let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
			self.mapView.setRegion(region, animated: true)
		}
    }

}
