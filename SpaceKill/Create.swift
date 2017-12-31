//
//  CreateLackeys.swift
//  SpaceKill
//
//  Created by eleves on 17-12-07.
//  Copyright © 2017 marcos. All rights reserved.
//

//------- Libraries -------
import Foundation
import UIKit
//-------------------------

/*********************************************************************************************************
*																										 *
*		CREATE CLASS - It create the lackeys and add the UIImageView to Lackeys UIViews					 *
*																										 *
*		sws = Screen width size																			 *
*		shs = Screen heigth size																		 *
*		dvx = Distance between views on x																 *
*		dvy = Distance between views on y																 *
*		lb = Lackeys by line																			 *
**********************************************************************************************************/
class Create
{
	//------- Variables -------
	var arrayUIView = [UIView]()
	var arrayUIImgView = [UIImageView]()
	var arrayNormandyBullets = [UIView]()
	var arrayMothershipBullets = [UIView]()
	var arrayLackeyBullets = [UIView]()
	var arrayBullets = [[UIView]]()
	var aUIView: UIView!
	var aUIImgView: UIImageView!
	var mv: UIView!
	var sws: CGFloat!; var shs: CGFloat!
	var dvx: CGFloat!; var dvy: CGFloat!
	var ipx: CGFloat!; var ipy: CGFloat!
	//------- Constants -------
	let nl, lb, nll, nb, nmb, nlb: Int!
	//------ Initiation -------
	/* The init perform the viewDidLoad's role and
	it do the constants and variables importations from MainViewController */
	init(mainView mv: UIView,
		 numberOfLackeys nl: Int,
		 numberOfLackeysLines nll: Int,
		 lcInitialPositionX ipx: CGFloat,
		 lcInitialPositionY ipy: CGFloat,
		 nBullets nb: Int,
		 nMsBullets nmb: Int,
		 nLcBullets nlb: Int)
	{
		//-- Vars to import
		self.mv = mv					/* Self do the class assignments variables for the imported variables */
		self.nl = nl
		self.nll = nll
		self.ipx = ipx
		self.ipy = mv.frame.height * (ipy / 1024)
		self.nb = nb
		self.nmb = nmb
		self.nlb = nlb
		//-- Vars to load --
		sws = mv.frame.width
		shs = mv.frame.height
		lb = nl / nll
		dvx = CGFloat(Int(sws)/(lb + 1))
		dvy = dvx
	}
	
	//================================= FUNCTIONS =================================
	//Creation of the lackeys UIViews
	func createArrayOfLackeys() -> [UIView]
	{
		let constIncrementationX: CGFloat = dvx
		let constIncrementationY: CGFloat = dvy
		var incX: CGFloat = 0
		var incY: CGFloat = 0
		
		for i in 1...nl
		{
			//-- Line 1 -- 0.0651 = 50/768 width ipad 9.7" // 0.141927 = 109/768 // 0.152344 = 156/1024
			if i <= lb
			{
				aUIView = UIView(frame: .init(x: ipx + incX,		/* UIView creation */
											  y: ipy + incY,
											  width: sws * 50/768,
											  height: shs * 50/1024))
			}
			//-- Line 2 --
			if (i > lb && i <= lb * 2)
			{
				if i == (lb + 1) { incX = 0 } // Reset incX on line 2
				
				aUIView = UIView(frame: .init(x: ipx + incX,
											  y: ipy + incY,
											  width: sws * 50/768,
											  height: shs * 50/1024))
			}
			//-- Line 3 --
			if (i > lb * 2 && i <= lb * 3)
			{
				if i == (2 * lb + 1) { incX = 0 } // Reset incX on line 3
				
				aUIView = UIView(frame: .init(x: ipx + incX,
											  y: ipy + incY,
											  width: sws * 50/768,
											  height: shs * 50/1024))
			}
			//-- Line 4 --
			if (i > lb * 3 && i <= nl)
			{
				if i == (3 * lb + 1) { incX = 0 } // Reset incX on line 3
				
				aUIView = UIView(frame: .init(x: ipx + incX,
											  y: ipy + incY,
											  width: sws * 50/768,
											  height: shs * 50/1024))
			}
			arrayUIView.append(aUIView)
			//-- X incrementations
			incX = incX + constIncrementationX
			//-- Y incrementations conditions
			if (i == lb || i == 2 * lb || i == 3 * lb)
			{ incY = incY + constIncrementationY }
		}
		return arrayUIView
	}
	// Creation of Lackeys UIImageViews for add to views
	func createArrayImgViewsLackeys() -> [UIImageView]
	{
		for _ in 0...nl
		{
			aUIImgView = UIImageView(frame: .init(x: 0,
												  y: 0,
												  width: sws * 50/768,
												  height: shs * 50/1024))
			
			aUIImgView.image = UIImage.init(named: "lackey.png")
			
			arrayUIImgView.append(aUIImgView)
		}
		return arrayUIImgView
	}
	
	func spaceshipsBulletsCreation() -> [[UIView]]
	{
		//---- Normandy's bullets ----
		for _ in 1...nb
		{
			let bullet = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 10))
			
			bullet.backgroundColor = UIColor.white
			
			arrayNormandyBullets.append(bullet)
		}
		//---- Mothership's bullets ----
		for _ in 1...nmb
		{
			let msBullet = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
			
			msBullet.backgroundColor = UIColor.white
			msBullet.layer.cornerRadius = msBullet.frame.width / 2
			
			arrayMothershipBullets.append(msBullet)
		}
		//---- Lackey's bullets ----
		for _ in 1...nlb
		{
			let lcBullet = UIView(frame: .init(x: 0, y: 0, width: 10, height: 10))
			
			lcBullet.backgroundColor = UIColor.white
			lcBullet.layer.cornerRadius = lcBullet.frame.width / 2
			
			arrayLackeyBullets.append(lcBullet)
		}
		arrayBullets = [arrayNormandyBullets, arrayMothershipBullets, arrayLackeyBullets]
		return arrayBullets
	}
	//=============================================================================
}
/*********************************************************************************************************
*																										 *
*												INTERNAL CLASS											 *
*																										 *
**********************************************************************************************************/



























