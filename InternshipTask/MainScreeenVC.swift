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
	@IBOutlet weak var deliveryProcessView: UIView!
	
	@IBOutlet weak var addressLabel: UILabel!
	@IBOutlet weak var reportIssue: CircularEdgedButton!
	@IBOutlet weak var trackOrder: UIButton!
	
	var lineWidth : CGFloat!
	
	@IBOutlet weak var cookingView: UIView!
	@IBOutlet weak var cookingImageView: UIImageView!
	@IBOutlet weak var cookingViewWidthConstraint: NSLayoutConstraint!
	@IBOutlet weak var cookingViewHeightConstraint: NSLayoutConstraint!
	var cookingStartX : CGFloat!
	
	@IBOutlet weak var pickedView: UIView!
	@IBOutlet weak var pickedImageView: UIImageView!
	@IBOutlet weak var pickedViewWidthConstraint: NSLayoutConstraint!
	@IBOutlet weak var pickedViewHeightConstraint: NSLayoutConstraint!
	var pickedStartX : CGFloat!
	
	@IBOutlet weak var onWayView: UIView!
	@IBOutlet weak var onWayImageView: UIImageView!
	@IBOutlet weak var onWayViewWidthConstraint: NSLayoutConstraint!
	@IBOutlet weak var onWayViewHeightConstraint: NSLayoutConstraint!
	var oneWayStartX : CGFloat!
	
	@IBOutlet weak var deliveredView: UIView!
	@IBOutlet weak var deliveredImageView: UIImageView!
	@IBOutlet weak var deliveredViewWidthConstraint: NSLayoutConstraint!
	@IBOutlet weak var deliveredViewHeightConstraint: NSLayoutConstraint!
	var deliveredStartX : CGFloat!
	
	@IBOutlet weak var doneView: UIView!
	@IBOutlet weak var doneImageView: UIImageView!
	@IBOutlet weak var doneViewWidthConstraint: NSLayoutConstraint!
	@IBOutlet weak var doneViewHeightConstraint: NSLayoutConstraint!
	
	var cookingToPicked : UIView!
	var pickedToOnWay : UIView!
	var onWayToDelivered : UIView!
	var deliveredToDone : UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		addressLabel.text = address
		reportIssue.isEnabled = false
		
		trackOrder.imageView?.contentMode = .scaleAspectFit
		trackOrder.imageEdgeInsets = UIEdgeInsets(top: (trackOrder.imageView?.frame.minY)! + 25, left: (trackOrder.imageView?.frame.minX)! - 10, bottom: 30, right: 5)
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		lineWidth = pickedView.frame.minX - cookingView.frame.maxX
		cookingStartX = cookingView.frame.maxX
		pickedStartX = pickedView.frame.maxX
		oneWayStartX = onWayView.frame.maxX
		deliveredStartX = deliveredView.frame.maxX
		
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
		
		lineView.setGradientBackground(colorOne: K.appThemeColor, colorTwo: UIColor.white)
	}
	
	func resetLine(lineView: UIView) {
		lineView.removeGradientBackground()
		lineView.backgroundColor = K.appThemeColor
	}
	
	func scaleCircle(view: UIView, widthConstraint: NSLayoutConstraint, heightConstraint: NSLayoutConstraint, scale: CGFloat) {
		widthConstraint.constant *= scale
		heightConstraint.constant *= scale
		
		view.layer.cornerRadius = widthConstraint.constant / 2
	}
}
