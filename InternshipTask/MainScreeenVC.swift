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
		
		deliveryProcessInit()
		startDeliveryProcess()
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
		
		if (index > 0) {
			completeProgressLine(progressLine: progressLines[index - 1], view1: deliveryProcessViewIcons[index - 1].iconView, view2: deliveryProcessViewIcons[index].iconView)
		}
		
		updateIcon(icon: deliveryProcessViewIcons[index])
		
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
	
	func completeProgressLine(progressLine : UIView, view1 : UIView, view2 : UIView) {
		progressLine.removeGradientBackground()
		progressLine.backgroundColor = UIColor(cgColor: pinkGradient.last!)
	}
	
	func startProgressLine(progressLine : UIView, view1 : UIView, view2 : UIView) {
		let x = view1.frame.maxX
		let y = view1.frame.midY - 1
		let width = view2.frame.minX - x
		let height : CGFloat = progressLine.frame.height
		
		progressLine.frame = CGRect(x: x, y: y, width: width, height: height)

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
		iconView.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: superView.frame.midX * xPosMultiplier - iconDiameter/2).isActive = true
		
		label.translatesAutoresizingMaskIntoConstraints = false
		label.centerYAnchor.constraint(equalTo: superView.centerYAnchor, constant: iconDiameter/2 + 15).isActive = true
		//label.topAnchor.constraint(equalTo: iconView.centerYAnchor, constant: 10).isActive = true
		label.centerXAnchor.constraint(equalTo: iconView.centerXAnchor).isActive = true
		label.widthAnchor.constraint(equalToConstant: iconDiameter * 2).isActive = true
		label.heightAnchor.constraint(equalToConstant: iconDiameter).isActive = true
		
		superView.layoutIfNeeded()
		
		return Icon(iconView: iconView, iconImage: imageView, heightConstraint: heightConstraint, widthConstraint: widthConstraint)
	}

	/*
	func deliveryProcessInit() {

		turnToGrayDot(wrapperView: cookingView, wrapperImageView: cookingImageView, widthConstraint: cookingViewWidthConstraint, heightConstraint: cookingViewHeightConstraint)
		turnToGrayDot(wrapperView: pickedView, wrapperImageView: pickedImageView, widthConstraint: pickedViewWidthConstraint, heightConstraint: pickedViewHeightConstraint)
		turnToGrayDot(wrapperView: onWayView, wrapperImageView: onWayImageView, widthConstraint: onWayViewWidthConstraint, heightConstraint: onWayViewHeightConstraint)
		turnToGrayDot(wrapperView: deliveredView, wrapperImageView: deliveredImageView, widthConstraint: deliveredViewWidthConstraint, heightConstraint: deliveredViewHeightConstraint)
		turnToGrayDot(wrapperView: doneView, wrapperImageView: doneImageView, widthConstraint: doneViewWidthConstraint, heightConstraint: doneViewHeightConstraint)
		
		let yCoord = cookingView.frame.midY
		let height :CGFloat = 3
		let widthOffset = (cookingView.frame.width - cookingView.frame.width/K.scaleFactor)/2
		let cookingToPickedWidth = pickedView.frame.minX - cookingView.frame.maxX
		let width = cookingToPickedWidth + widthOffset*2
		
		cookingToPicked = UIView(frame: CGRect(x: cookingView.frame.maxX - widthOffset, y: yCoord, width: width, height: height))
		cookingToPicked?.backgroundColor = .lightGray
		deliveryProcessView.addSubview(cookingToPicked!)
		
		pickedToOnWay = UIView(frame: CGRect(x: pickedView.frame.maxX - widthOffset, y: yCoord, width: width, height: height))
		pickedToOnWay?.backgroundColor = .lightGray
		deliveryProcessView.addSubview(pickedToOnWay!)
		
		onWayToDelivered = UIView(frame: CGRect(x: onWayView.frame.maxX - widthOffset, y: yCoord, width: width, height: height))
		onWayToDelivered?.backgroundColor = .lightGray
		deliveryProcessView.addSubview(onWayToDelivered!)
		
		deliveredToDone = UIView(frame: CGRect(x: deliveredView.frame.maxX - widthOffset, y: yCoord, width: width, height: height))
		deliveredToDone?.backgroundColor = .lightGray
		deliveryProcessView.addSubview(deliveredToDone!)
	}
	
	func startDeliveryProcess() {
		
		// cooking
		self.setIcon(wrapperView: self.cookingView, wrapperImageView: self.cookingImageView, widthConstraint: self.cookingViewWidthConstraint, heightConstraint: self.cookingViewHeightConstraint)
		
		turnGrayLineToGradient(lineView: cookingToPicked, view1: cookingView, view2: pickedView, startX: cookingStartX)
		// picked
		DispatchQueue.main.asyncAfter(deadline: .now() + K.secs) {
			
			self.resetLine(lineView: self.cookingToPicked)
			self.setIcon(wrapperView: self.pickedView, wrapperImageView: self.pickedImageView, widthConstraint: self.pickedViewWidthConstraint, heightConstraint: self.pickedViewHeightConstraint)
			self.turnGrayLineToGradient(lineView: self.pickedToOnWay, view1: self.pickedView, view2: self.onWayView, startX: self.pickedStartX)
			
			// on way
			DispatchQueue.main.asyncAfter(deadline: .now() + K.secs) {
				self.resetLine(lineView: self.pickedToOnWay)
				self.setIcon(wrapperView: self.onWayView, wrapperImageView: self.onWayImageView, widthConstraint: self.onWayViewWidthConstraint, heightConstraint: self.onWayViewHeightConstraint)
				self.turnGrayLineToGradient(lineView: self.onWayToDelivered, view1: self.onWayView, view2: self.deliveredView, startX: self.oneWayStartX)
				
				// delivered
				DispatchQueue.main.asyncAfter(deadline: .now() + K.secs) {
					self.resetLine(lineView: self.onWayToDelivered)
					self.setIcon(wrapperView: self.deliveredView, wrapperImageView: self.deliveredImageView, widthConstraint: self.deliveredViewWidthConstraint, heightConstraint: self.deliveredViewHeightConstraint)
					self.turnGrayLineToGradient(lineView: self.deliveredToDone, view1: self.deliveredView, view2: self.doneView, startX: self.deliveredStartX)
					
					// done
					DispatchQueue.main.asyncAfter(deadline: .now() + K.secs) {
						self.resetLine(lineView: self.deliveredToDone)
						self.setIcon(wrapperView: self.doneView, wrapperImageView: self.doneImageView, widthConstraint: self.doneViewWidthConstraint, heightConstraint: self.doneViewHeightConstraint)
					}
				}
			}
		}

	}
	
	func setIcon(wrapperView: UIView, wrapperImageView: UIImageView, widthConstraint: NSLayoutConstraint, heightConstraint: NSLayoutConstraint) {
		wrapperImageView.isHidden = false
		wrapperView.layer.borderWidth = 2
		wrapperView.layer.borderColor = UIColor.black.cgColor
		wrapperView.backgroundColor = .none
		scaleCircle(view: wrapperView, widthConstraint: widthConstraint, heightConstraint: heightConstraint, scale: K.scaleFactor)
		
	}

	func turnToGrayDot(wrapperView: UIView, wrapperImageView: UIImageView, widthConstraint: NSLayoutConstraint, heightConstraint: NSLayoutConstraint) {
		wrapperImageView.isHidden = true
		wrapperView.layer.borderWidth = 0
		wrapperView.backgroundColor = .gray
		scaleCircle(view: wrapperView, widthConstraint: widthConstraint, heightConstraint: heightConstraint, scale: 1/K.scaleFactor)
	}
	
	func turnGrayLineToGradient(lineView: UIView, view1 : UIView, view2 : UIView, startX : CGFloat) {

		//let startX = view1.frame.maxX
		let width = lineWidth!
		let height : CGFloat = lineView.frame.height
		let startY = view1.frame.midY
		
		lineView.frame = CGRect(x: startX, y: startY, width: width, height: height)
		
		lineView.setGradientBackground(colorOne: K.appThemeColor1, colorTwo : K.appThemeColor2, colorThree : K.appThemeColor3, colorFour: UIColor.white)
	}
	
	func resetLine(lineView: UIView) {
		lineView.removeGradientBackground()
		lineView.backgroundColor = K.appThemeColor2
	}
	
	func scaleCircle(view: UIView, widthConstraint: NSLayoutConstraint, heightConstraint: NSLayoutConstraint, scale: CGFloat) {
		widthConstraint.constant *= scale
		heightConstraint.constant *= scale
		
		view.layer.cornerRadius = widthConstraint.constant / 2
	}
*/
}
