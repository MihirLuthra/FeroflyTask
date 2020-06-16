//
//  MainScreeenVC.swift
//  InternshipTask
//
//  Created by Mihir Luthra on 15/06/20.
//  Copyright © 2020 Mihir Luthra. All rights reserved.
//

import UIKit

class MainScreeenVC: UIViewController {
	
	let address = """
	2nd Floor, Hno 12, Road no 37, \
	Back Side of Mgs Hospital , West Punjabi Bagh, \
	Pubjabi Bagh, Delhi, 110026, India
	"""

	@IBOutlet weak var addressLabel: UILabel!
	@IBOutlet weak var reportIssue: CircularEdgedButton!
	@IBOutlet weak var trackOrder: UIButton!
	
	@IBOutlet weak var deliveryProcessView: UIView!
	
	let iconImageNames = ["Cooking", "Picked", "On way", "Delivered", "Done"]
	
	struct Icon {
		let iconView : UIView
		let iconImage : UIImageView
		let heightConstraint : NSLayoutConstraint
		let widthConstraint : NSLayoutConstraint
	}
	
	var deliveryProcessViewIcons : [Icon] = []
	var progressLines : [UIView] = []
	let iconDiameter : CGFloat = 50
	let scaleValue : CGFloat = 2
	let deliveryTime : Double = 5
	var deliveryIndex = 0
	var deliveryProcessInitDone = false
	var deliveryProcessDone = false
	
	var pinkGradient = [
		UIColor.lightGray.cgColor,
		UIColor(red: 178/255, green: 115/255, blue: 142/255, alpha: 1).cgColor,
		UIColor(red: 166/255, green: 67/255, blue: 110/255, alpha: 1).cgColor,
	]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		addressLabel.text = address
		reportIssue.isEnabled = false
		
		trackOrder.imageView?.contentMode = .scaleAspectFit
		trackOrder.imageEdgeInsets = UIEdgeInsets(top: (trackOrder.imageView?.frame.minY)! + 25, left: (trackOrder.imageView?.frame.minX)! - 10, bottom: 30, right: 5)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		if !deliveryProcessInitDone {
			deliveryProcessInit()
			deliveryProcessInitDone = true
		}
		
		if !deliveryProcessDone {
			startDeliveryProcess()
			deliveryProcessDone = true
		}
	}
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "toMapVC" {
			let destinationVC = segue.destination as! MapVC
			destinationVC.searchString = address
			
		}
	}
	
	func deliveryProcessInit() {
		
		var multiplier : CGFloat = 0.2

		for imageName in iconImageNames {
			deliveryProcessViewIcons.append(addIconToView(superView: deliveryProcessView, iconDiameter: iconDiameter, imageName : imageName, xPosMultiplier : multiplier))
			multiplier += 0.4
		}
		
		for index in 0..<(deliveryProcessViewIcons.count - 1) {
			progressLines.append(addProgressLineToView(superView: deliveryProcessView, view1: deliveryProcessViewIcons[index].iconView, view2: deliveryProcessViewIcons[index+1].iconView))
		}
	}
	
	func startDeliveryProcess() {
	
		progressDelivery(index: deliveryIndex)
		deliveryIndex += 1
		
		Timer.scheduledTimer(withTimeInterval: deliveryTime, repeats: true) { (timer) in
			self.progressDelivery(index: self.deliveryIndex)
			self.deliveryIndex += 1
			if self.deliveryIndex >= self.deliveryProcessViewIcons.count {
				timer.invalidate()
			}
		}
	}
	
	func progressDelivery(index : Int) {
		
		if (index >= deliveryProcessViewIcons.count) {
			return
		}
		
		updateIcon(icon: deliveryProcessViewIcons[index])
		
		if (index > 0) {
			completeProgressLine(progressLine: progressLines[index - 1], view1: deliveryProcessViewIcons[index - 1].iconView, view2: deliveryProcessViewIcons[index].iconView)
		}
		
		if (index < deliveryProcessViewIcons.count - 1) {
			startProgressLine(progressLine: progressLines[index], view1: deliveryProcessViewIcons[index].iconView, view2: deliveryProcessViewIcons[index+1].iconView)
		}
	}
	
	func updateIcon(icon : Icon) {
		
		icon.heightConstraint.constant = iconDiameter
		icon.widthConstraint.constant = iconDiameter
		
		icon.iconView.backgroundColor = .none
		
		icon.iconImage.isHidden = false
		
		icon.iconView.layer.cornerRadius = iconDiameter / 2
		icon.iconView.layer.borderWidth = 1.5
		icon.iconView.layer.borderColor = UIColor.black.cgColor
		
		deliveryProcessView.layoutIfNeeded()
	}
	
	func updateProgressLineFrame(progressLine : UIView, view1 : UIView, view2 : UIView) {
		let x = view1.frame.maxX
		let y = view1.frame.midY - 1
		let width = view2.frame.minX - x
		let height : CGFloat = progressLine.frame.height
		
		progressLine.frame = CGRect(x: x, y: y, width: width, height: height)
	}
	
	func completeProgressLine(progressLine : UIView, view1 : UIView, view2 : UIView) {
		
		updateProgressLineFrame(progressLine: progressLine, view1: view1, view2: view2)
		
		progressLine.removeGradientBackground()
		progressLine.backgroundColor = UIColor(cgColor: pinkGradient.last!)
	}
	
	func startProgressLine(progressLine : UIView, view1 : UIView, view2 : UIView) {
		
		updateProgressLineFrame(progressLine: progressLine, view1: view1, view2: view2)

		progressLine.setGradientBackground(colors: pinkGradient)
	}
	
	func addProgressLineToView(superView : UIView, view1 : UIView, view2 : UIView) -> UIView {
		let x = view1.frame.maxX
		let y = view1.frame.midY - 1
		let width = view2.frame.minX - x
		let height : CGFloat = 3
		let progressLine = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
		
		progressLine.backgroundColor = .lightGray
		
		superView.addSubview(progressLine)
		
		return progressLine
	}
	
	func addIconToView(superView : UIView, iconDiameter : CGFloat, imageName : String, xPosMultiplier : CGFloat) -> Icon {
		
		let grayDotDiameter = iconDiameter/scaleValue
		
		let iconView = UIView()
		iconView.backgroundColor = .lightGray
		iconView.layer.cornerRadius = grayDotDiameter / 2
		
		superView.addSubview(iconView)
		
		let image = UIImage(named: imageName)
		let imageView = UIImageView(image: image)
		
		iconView.addSubview(imageView)
		
		let label = UILabel()
		label.text = imageName
		label.adjustsFontSizeToFitWidth = true
		label.font = UIFont(name: "Calibri", size: 13)
		label.textAlignment = .center
		
		superView.addSubview(label)
		
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.leadingAnchor.constraint(equalTo: iconView.leadingAnchor, constant: 10).isActive = true
		imageView.trailingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: -10).isActive = true
		imageView.topAnchor.constraint(equalTo: iconView.topAnchor, constant: 10).isActive = true
		imageView.bottomAnchor.constraint(equalTo: iconView.bottomAnchor, constant: -10).isActive = true
		
		imageView.isHidden = true
		
		iconView.translatesAutoresizingMaskIntoConstraints = false
		
		let widthConstraint = iconView.widthAnchor.constraint(equalToConstant: grayDotDiameter)
		widthConstraint.isActive = true
		let heightConstraint = iconView.heightAnchor.constraint(equalToConstant: grayDotDiameter)
		heightConstraint.isActive = true
		
		iconView.centerYAnchor.constraint(equalTo: superView.centerYAnchor).isActive = true
		
		let xShift = (superView.frame.midX * xPosMultiplier) - superView.frame.midX
		iconView.centerXAnchor.constraint(equalTo: superView.centerXAnchor, constant: xShift).isActive = true
		
		label.translatesAutoresizingMaskIntoConstraints = false
		label.centerYAnchor.constraint(equalTo: superView.centerYAnchor, constant: iconDiameter/2 + 15).isActive = true
		label.centerXAnchor.constraint(equalTo: iconView.centerXAnchor).isActive = true
		label.widthAnchor.constraint(equalToConstant: iconDiameter * 2).isActive = true
		label.heightAnchor.constraint(equalToConstant: iconDiameter).isActive = true
		
		superView.layoutIfNeeded()
		
		return Icon(iconView: iconView, iconImage: imageView, heightConstraint: heightConstraint, widthConstraint: widthConstraint)
	}
}
