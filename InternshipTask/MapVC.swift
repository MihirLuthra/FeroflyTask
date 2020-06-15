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

		print(searchString)
		
    }

}
