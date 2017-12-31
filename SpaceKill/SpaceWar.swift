/*
  SpaceWar.swift
  SpaceKill

  Created by eleves on 17-12-04.
  Copyright © 2017 marcos. All rights reserved.
*/
//------------ Libraries ------------
import UIKit
import Foundation
import AVFoundation
//-----------------------------------

class SpaceWar: UIViewController
{
	//------------- Outlets -------------
	@IBOutlet weak var view_mothership: UIView!
	@IBOutlet weak var view_normandy: UIView!
	@IBOutlet weak var view_gameOver: UIView!
	
	@IBOutlet weak var label_gameOver: UILabel!
	@IBOutlet weak var label_resetOrMenu: UILabel!
	@IBOutlet weak var label_score: UILabel!
	@IBOutlet weak var label_bestScore: UILabel!
	
	@IBOutlet weak var button_menu: UIButton!
	@IBOutlet weak var button_reset: UIButton!
	
	@IBOutlet weak var img_mothership: UIImageView!
	@IBOutlet weak var img_normandy: UIImageView!
	
	@IBOutlet weak var img_life1: UIImageView!
	@IBOutlet weak var img_life2: UIImageView!
	@IBOutlet weak var img_life3: UIImageView!
	@IBOutlet weak var img_life4: UIImageView!
	@IBOutlet weak var img_life5: UIImageView!
	//-----------------------------------
	//------------ Constants ------------
	let normandy = "normandy"
	let lackey = "lackey"
	let mothership = "mothership"
	//-----------------------------------
	//------------ Variables ------------
	//-- Coordinates
	var shotX, shotY, msShotX, msShotY, lcShotX, lcShoty: Float!
	var animationX, animationY : CGFloat!			/* Distance on pixels to animate */
	//-- Trigonometry
	var anglesDivised, anglesDivisedLc: Double!
	var arrayCos = [Double](); var arraySin = [Double]()
	var arrayAngles = [Double]()
	var arrayCosLc = [Double](); var arraySinLc = [Double]()
	var arrayAnglesLc = [Double]()
	//-- Game Mode
	var tupleNormandyMode: (nBullets: Int, shotSpeed: Double, normandyLife: Int)!
	var tupleMothershipMode: (bullets: Int, life: Int, probabilityShot: Double, sampleSpace: UInt32, speed: Double, speedShot: Double, minAngle: Double, maxAngle: Double)!
	var tupleLackeysMode: (bullets: Int, life: Int, probabilityShot: Double, sampleSpace: UInt32, speed: Double, speedShot: Double, minAngle: Double, maxAngle: Double)!
	var rightOrLeftMS, rightOrLeftLC: Int!
	var maxDistance, maxMsDistance, maxAniLcDistance: Int!				/* Max distance to animate by screen */
	var distanceAniLc = 0												/* Initial distance to animate lackeys */
	var distanceBullet = 0; var distanceMsBullet = 0					/* Initial distance to animate shot */
	var distanceLcBullet = 0
	var mothershipLife, lackeysLifes, normandyLife: Int!				/* Ships Lifes */
	var dificultyMode: String!
	//-- Arrays of game elements
	var arrayMothershipBullets = [UIView](); var arrayBullets = [UIView]()
	var arrayLackeyBullets = [UIView]()
	var arrayLackeys = [UIView](); var arrayLackeysDisplaced = [UIView]()
	var arrayLackeysToShot = [UIView]()
	//-- Arrays meta games
	var arrayImgLackeys = [UIImageView]()
	var arrayButtons = [UIButton](); var arrayLabels = [UILabel]()
	var arrayLifes = [UIImageView]()
	//-- Tuples of vessels
	var tupleMotherShip = [(view: UIView, life: Int)]()
	var tupleLackeys = [(view: UIView, life: Int)]()
	var tupleNormandy = [(view: UIView, life: Int)]()
	//-- Sounds and musics
	var tupleSounds: (mus_endgame: AVAudioPlayer, mus_gameover: AVAudioPlayer, sound_touchMothership: AVAudioPlayer,
		sound_touchNormandy: AVAudioPlayer, sound_deathLackey: AVAudioPlayer, sound_explosion: AVAudioPlayer,
		sound_shotLackey: AVAudioPlayer, sound_shotMothership: AVAudioPlayer, sound_shot: AVAudioPlayer)!
	var arrayMusics = [AVAudioPlayer]()
	//-- Timers to animation and score
	var realTime: Double = 0.0; var bestTime: Double!
	var aniBulletTimer, aniBulletLackey, aniBulletMothership: Timer!							/* Variable of time animation */
	var aniRightMothershipTimer, aniLeftMothershipTimer: Timer!
	var aniRightLackeysTimer, aniLeftLackeysTimer: Timer!
	var aniMusicTimer, aniScoreTimer: Timer!
	//-----------------------------------
	//------------- Obj/Clas ------------
	let object_saveLoad = SaveAndLoad()
	let object_style = Styles()
	var object_create: Create!
	var object_gameMode: GameMode!
	var object_musicSounds: MusicSounds!
	var object_moveMotherShip: EnemyMoves!
	
	//NEXT CLASS WILL BE SPACESHIPS BULLETS CREATIONS
	
	//-----------------------------------
	//============================ The loader =============================
    override func viewDidLoad()
	{
        super.viewDidLoad()
		//----- Load Data and Styles
		loads()
		//----- Object Game Mode
		object_gameMode = GameMode(dificultyMode: dificultyMode)
		//----- Game Mode
		gameMode()
		//----- Object Creation
		object_create = Create(mainView: self.view, numberOfLackeys: 24, numberOfLackeysLines: 4,
							   lcInitialPositionX: 0, lcInitialPositionY: 147,
							   nBullets: tupleNormandyMode.nBullets,
							   nMsBullets: tupleMothershipMode.bullets,
							   nLcBullets: tupleLackeysMode.bullets)
		//----- Creation
		creationAndGameConfig(); spaceshipsBulletsCreation(); setStyles()
		//----- Object Music
		object_musicSounds = MusicSounds()
		//----- Set Musics
		setMusicsAndSounds()
		//----- Object Mothership Moves
		object_moveMotherShip = EnemyMoves(mainView: self.view, tupleOfViews: tupleMotherShip, tupleOfViewsModes: tupleMothershipMode, moveX: animationX)
		//----- Play Functions
		playMusic(); score(); moveMothership(); moveLackeys(); shotOfNormandy()
    }
	//=====================================================================
	/*********************************************************************************************************
	*																										 *
	*											LOADING FUNCTIONS											 *
	*																										 *
	**********************************************************************************************************/
	//-------------- Mods choice ---------------
	func gameMode()
	{
		// Normandy's modes
		tupleNormandyMode = object_gameMode.dificultyGameNormandy()
		// Mothership's modes
		tupleMothershipMode = object_gameMode.dificultyGameMothership()
		// Lackeys's modes
		tupleLackeysMode = object_gameMode.dificultyGameLackeys()
	}
	//--Enemies Creation and set initial config--
	func creationAndGameConfig()
	{
		//------ Lackeys -------
		arrayLackeys = object_create.createArrayOfLackeys()
		arrayImgLackeys = object_create.createArrayImgViewsLackeys()
		//Set images to views
		var i = 0; while i < arrayLackeys.count
		{ arrayLackeys[i].addSubview(arrayImgLackeys[i]); i += 1}
		//Add views + images to main view
		for lc in arrayLackeys { self.view.addSubview(lc) }
		//--- Set the tuple of lackeys
		lackeysLifes = tupleLackeysMode.life
		for lac in arrayLackeys { tupleLackeys.append((lac, lackeysLifes)) }
		//----- Mothership -----
		//-- Set mothership's tuple
		mothershipLife = tupleMothershipMode.life
		tupleMotherShip = [(view: view_mothership, life: mothershipLife)]
		//-- Set image to mothership
		img_mothership.image = UIImage(named: "mothership.png")
		//----- Normandy ------
		//-- set life's array
		arrayLifes = [img_life1, img_life2, img_life3, img_life4, img_life5]
		//-- Set normandy's tuple
		normandyLife = tupleNormandyMode.normandyLife
		tupleNormandy = [(view: view_normandy, life: normandyLife)]
		//-- Initial position --
		tupleNormandy[0].view.center.x = view.frame.width * 0.5			/* To position in x mid frame */
		tupleNormandy[0].view.center.y = view.frame.height * 0.9017		/* To position in y frame proportional position */
		//----------------------
		//-- Shot's start --
		shotX = Float(tupleNormandy[0].view.center.x)				/* Value shot X value */
		shotY = Float(view.frame.height * 0.9017)				/* Value shot Y value */
	
		msShotY = Float(view.frame.height * 0.09472)			/* Value shot Y mothership */
		//------------------
		//-- Animations config -
		maxDistance = Int(view.frame.height - view.frame.height * 0.0983)
		maxMsDistance = Int(1.2 * view.frame.height)
		maxAniLcDistance = Int(UIScreen.main.bounds.width * 218/768)
		//distance to animations add
		animationY = 1; animationX = 1
	}
	//----------------- Styles ------------------
	func setStyles()
	{
		object_style.styleUIView(view_gameOver, 15, 1, UIColor.white.cgColor, UIColor.black, 1)
		
		arrayButtons = [button_menu, button_reset]
		object_style.styleArrayOfUIButtons(arrayButtons, UIFont.init(name: "Space Age", size: 25), UIColor.white,
										   15, 1, UIColor.white.cgColor, UIColor.black.cgColor, 1)
		
		arrayLabels = [label_gameOver, label_resetOrMenu]
		object_style.styleArrayOfUILabel(arrayLabels, UIFont.init(name: "Space Age", size: 20), NSTextAlignment.center,
										 0, 0, UIColor.black.cgColor, UIColor.white, UIColor.black.cgColor)
		
		object_style.styleUILabel(label_score, UIFont.init(name: "Space Age", size: 20), NSTextAlignment.center, "",
								  0, 0, UIColor.black.cgColor, UIColor.black.cgColor)
		
		object_style.styleUILabel(label_bestScore, UIFont.init(name: "Space Age", size: 20), NSTextAlignment.center,
								  "\((bestTime * 100).rounded()/100)", 0, 0, UIColor.black.cgColor, UIColor.black.cgColor)
		
		//-- Set the life's images on the screen
		for i in 0..<tupleNormandyMode.normandyLife { arrayLifes[i].image = UIImage(named: "ship0") }
	}
	//-------------------------------------------
	//------------- Musics creation	-------------
	func setMusicsAndSounds()
	{
		tupleSounds = object_musicSounds.returnTupleSounds()
		arrayMusics = object_musicSounds.returnArrayMusics()
	}
	//-------------------------------------------
	//------------- Shots creations -------------
	func spaceshipsBulletsCreation()
	{
		//---- Normandy's bullets ----
		arrayBullets = object_create.spaceshipsBulletsCreation()[0]
		//---- Mothership's bullets ----
		arrayMothershipBullets = object_create.spaceshipsBulletsCreation()[1]
		//---- Lackey's bullets ----
		arrayLackeyBullets = object_create.spaceshipsBulletsCreation()[2]
	}
	
	//------------- Load best times -------------
	func loads()
	{
		//------ Dificult mode load
		dificultyMode = object_saveLoad.loadData(fileName: "fileMode") as! String
		//------ Load Best Time by dificult mode
		if object_saveLoad.checkExistingData(fileName: dificultyMode) == true
		{
			bestTime = object_saveLoad.loadData(fileName: dificultyMode) as! Double
		}
		else
		{
			bestTime = 100
			object_saveLoad.saveData(theData: bestTime as AnyObject, fileName: dificultyMode)
		}
	}
	//-------------------------------------------
	//----------- Game configuration ------------ 	
	//func gameConfig()
	//{
		
		//-- Slider loader --
		//slider_normandy.value = Float(view.frame.width * 0.5)	/* Initial value to slider */
		//-------------------
		
		//----------------------
		/* Actualization of max and min slider values by mobiles screen sizes */
		/*if view.frame.width <= 414				/* All iPhones*/
		{
			slider_normandy.maximumValue = Float(view.frame.width - 18)
			slider_normandy.minimumValue = Float(18)
		}
		else if view.frame.width == 768			/* iPads 9.7"*/
		{
			slider_normandy.maximumValue = Float(view.frame.width - 40)
			slider_normandy.minimumValue = Float(40)
		}
		else if view.frame.width == 834			/* iPads 10.5"*/
		{
			slider_normandy.maximumValue = Float(view.frame.width - 44)
			slider_normandy.minimumValue = Float(44)
		}
		else if view.frame.width == 1024		/* iPads 12.9"*/
		{
			slider_normandy.maximumValue = Float(view.frame.width - 54)
			slider_normandy.minimumValue = Float(54)
		}*/
	//}
	//=====================================================================
	/*********************************************************************************************************
	*																										 *
	*												GAME ACTIONS											 *
	*																										 *
	**********************************************************************************************************/
	//-------------------------------------------
	//------------ Normandy's shifting ----------
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
	{
		super.touchesMoved(touches, with: event)
		let touch: UITouch = touches.first!
	
		if touch.view == tupleNormandy[0].view
		{
			tupleNormandy[0].view.center.x = touch.location(in: self.view).x
			shotX = Float(tupleNormandy[0].view.center.x)
		}
	}
	//-------------------------------------------
	/*********************************************************************************************************
	*																										 *
	*										NORMANDY'S PLAY FUNCTIONS										 *
	*																										 *
	**********************************************************************************************************/
	//---- Normandy Shot ----
	func shotOfNormandy()
	{
		if aniBulletTimer != nil 		/* One shot condition */
		{ return }
		
		placeBulletsForShot(arrayBullets)
		
		for shot in arrayBullets
		{
			self.view.addSubview(shot) /* UIview adds on view */
			
			animateNormandyShot()
		}
		tupleSounds.sound_shot.play()
	}
	//----------- Place bullets for shot ---------
	func placeBulletsForShot(_ arrayBullets: [UIView])
	{
		for bullet in arrayBullets
		{
			bullet.center.x = CGFloat(shotX)			/* To spacehipCenter: less half viewShot width */
			bullet.center.y = CGFloat(shotY - 39)		/* less 45 pixels de la normandy */
		}
	}
	//--------------------------------------------
    //=================== Normandy's Animations shots =====================
	func animateNormandyShot()
	{
		//- Inicial distace for shot animation
		distanceBullet = 0
		//- Animation timer execution -
		aniBulletTimer = Timer.scheduledTimer(timeInterval: tupleNormandyMode.shotSpeed,
											  target: self,
											  selector: #selector(animationNS),
											  userInfo: nil,
											  repeats: true)
	}
	//-- Normandy shot animation --
	@objc func animationNS()
	{
		//- distance incremental -
		distanceBullet += 1
		//-- Stop the animation --
		if distanceBullet >= maxDistance { aniBulletTimer.invalidate(); aniBulletTimer = nil; shotOfNormandy()}
		//--- Bullet animation ---
		for bullet in arrayBullets
		{
			bullet.center.y -= animationY					/* Bullet animation on screen */
			//--- Bullet kill the lackeys ---
			for i in 0..<tupleLackeys.count
			{
				//-- Frames intersections conditions --
				if bullet.frame.intersects(tupleLackeys[i].view.frame) == true
				{
					tupleLackeys[i].life -= 1
					
					if tupleLackeys[i].life == 0
					{
						death(lackey, tupleLackeys[i].view, bullet)	/* Call death's function */
					}
					
					aniBulletTimer.invalidate()				/* Stop animation */
					aniBulletTimer = nil
					bullet.removeFromSuperview()			/* Remove the bullet from the main view */
					shotOfNormandy()
				}
			}
			//-- Frames intersections conditions --
			if bullet.frame.intersects(tupleMotherShip[0].view.frame)
			{
				tupleMotherShip[0].life -= 1		/* Mothership life dedremantation */
				//---- Bullet mothership touch sound
				tupleSounds.sound_touchMothership.play()
				//---- Condition to die
				if tupleMotherShip[0].life == 0
				{
					death(mothership, tupleMotherShip[0].view, bullet)
					
					//--- Stop mothership left animation
					if aniLeftMothershipTimer != nil
					{ aniLeftMothershipTimer.invalidate()
						aniLeftMothershipTimer = nil }
					
					//--- Stop mothership right animation
					if aniRightMothershipTimer != nil
					{ aniRightMothershipTimer.invalidate()
						aniRightMothershipTimer = nil }
				}
				//--- Stop normandy bullet animation
				aniBulletTimer.invalidate()
				aniBulletTimer = nil
				bullet.removeFromSuperview()	/* Remove the bullet from the main view if don't kill */
				shotOfNormandy()
			}
		}
	}
    //=====================================================================
	/*********************************************************************************************************
	*																										 *
	*										MOTHERSHIP'S PLAY FUNCTIONS										 *
	*																										 *
	**********************************************************************************************************/
	//--------- MothershipShot ----------
	func shotOfMothership()
	{
		let shot = Double(arc4random_uniform(tupleMothershipMode.sampleSpace))
		
		if (shot <= tupleMothershipMode.probabilityShot && aniBulletMothership == nil)
		{
			placeMothershipShot(arrayMothershipBullets)
			//---- Shot
			animatedMothershipShot()
			//---- Shot's sound
			tupleSounds.sound_shotMothership.play()
		}
		else {return}
	}
	//- Place mothership bullets to shot -
	func placeMothershipShot(_ arrayMsBullets: [UIView])
	{
		for msBullet in arrayMsBullets
		{
			msBullet.center.x = CGFloat(msShotX)
			msBullet.center.y = CGFloat(msShotY)
			
			self.view.addSubview(msBullet)
		}
		anglesDivised = (tupleMothershipMode.maxAngle - tupleMothershipMode.minAngle) / Double(arrayMsBullets.count)		/* it is the incremantations for each bullet */
		var angle: Double = 0
		
		arraySin = []; arrayCos = []
		while arrayCos.count != arrayMsBullets.count
		{
			let cos = __cospi((tupleMothershipMode.minAngle + angle)/180); arrayCos.append(cos)
			let sin = __sinpi((tupleMothershipMode.minAngle + angle)/180); arraySin.append(sin)
			//---- Angles to reflection
			arrayAngles.append(tupleMothershipMode.minAngle + angle)
			angle += anglesDivised
		}
	}
	//---- Mothership shot animation ----
	func animatedMothershipShot()
	{
		aniBulletMothership = Timer.scheduledTimer(timeInterval: tupleMothershipMode.speedShot,
												   target: self,
												   selector: #selector(animationMS),
												   userInfo: nil,
												   repeats: true)
	}
	//---- object to animate ----
	@objc func animationMS()
	{
		distanceMsBullet += 1
		
		if distanceMsBullet >= maxMsDistance
		{
			aniBulletMothership.invalidate()
			aniBulletMothership = nil
			distanceMsBullet = 0
			for b in arrayMothershipBullets { b.removeFromSuperview() }
		}
		
		for i in 0..<arrayMothershipBullets.count
		{
			//--- Left wall mothership bullets reflections
			if arrayMothershipBullets[i].center.x < arrayMothershipBullets[i].frame.width / 2
			{
				arrayCos[i] = __cospi((540 - arrayAngles[i]) / 180)
				arraySin[i] = __sinpi((540 - arrayAngles[i]) / 180)
			}
			//--- Right wall mothership bullets reflections
			if arrayMothershipBullets[i].center.x > self.view.frame.width - arrayMothershipBullets[i].frame.width / 2
			{
				arrayCos[i] = __cospi((540 - arrayAngles[i]) / 180)
				arraySin[i] = __sinpi((540 - arrayAngles[i]) / 180)
			}
			//--- animation
			arrayMothershipBullets[i].center.x -= CGFloat(arrayCos[i])
			arrayMothershipBullets[i].center.y -= CGFloat(arraySin[i])
		}
		//---- Condition to kill Normandy
		for bullet in arrayMothershipBullets
		{
			if bullet.frame.intersects(tupleNormandy[0].view.frame)
			{
				//--- Damage Normandy
				tupleNormandy[0].life -= 1
				//--- Touch normandy's sound
				tupleSounds.sound_touchNormandy.play()
				//--- Func to show lifes
				lifes()
				//--- Remove Bullet and phantom
				bullet.removeFromSuperview(); bullet.frame.origin.x = -500
				//--- Death's condition
				if tupleNormandy[0].life == 0
				{
					death(normandy, tupleNormandy[0].view, bullet)
				}
			}
		}
	}
	//----- Mothership's animations -----
    func moveMothership()
	{
		object_moveMotherShip.timerMoves()
	}
	//---- Mothership's animations to right -----
	/*@objc func animationMothershipToRight()
	{
		if view_mothership.center.x >= UIScreen.main.bounds.width - (248 / 768 * UIScreen.main.bounds.width) / 2
		{
			aniRightMothershipTimer.invalidate()
			aniRightMothershipTimer = nil
			rightOrLeftMS = 1
			moveMothership()
		}
		view_mothership.center.x += animationX
		
		msShotX = Float(view_mothership.center.x)
		shotOfMothership()
	}
	//----- Mothership's animations to left ------
	@objc func animationMothershipToLeft()
	{
		if view_mothership.center.x <= (248 / 768 * UIScreen.main.bounds.width) / 2
		{
			aniLeftMothershipTimer.invalidate()
			aniLeftMothershipTimer = nil
			rightOrLeftMS = 0
			moveMothership()
		}
		view_mothership.center.x -= animationX
		
		msShotX = Float(view_mothership.center.x)
		shotOfMothership()
	}*/
	//--------------------------------------------
	/*********************************************************************************************************
	*																										 *
	*											LACKEYS'S FUNCTIONS											 *
	*																										 *
	**********************************************************************************************************/
	//---------- Lackeys animations -----
	func moveLackeys()
	{
		if rightOrLeftLC == 0			/* move to right */
		{
			aniRightLackeysTimer = Timer.scheduledTimer(timeInterval: tupleLackeysMode.speed,
														target: self,
														selector: #selector(animationLackeysToRight),
														userInfo: nil,
														repeats: true)
		}
		if rightOrLeftLC == 1			/* move to left */
		{
			aniLeftLackeysTimer = Timer.scheduledTimer(timeInterval: tupleLackeysMode.speed,
													   target: self,
													   selector: #selector(animationLackeysToLeft),
													   userInfo: nil,
													   repeats: true)
		}
	}
	//----- object to animation ------
	@objc func animationLackeysToRight()
	{
		if distanceAniLc > maxAniLcDistance
		{
			aniRightLackeysTimer.invalidate()
			aniRightLackeysTimer = nil
			distanceAniLc = 0
			rightOrLeftLC = 1
			moveLackeys()
		}
		for (lck,_) in tupleLackeys
		{
			lck.center.x += animationX
		}
		distanceAniLc += 1
		shotOfLackeys()
	}
	//----- object to animation ------
	@objc func animationLackeysToLeft()
	{
		if distanceAniLc > maxAniLcDistance
		{
			aniLeftLackeysTimer.invalidate()
			aniLeftLackeysTimer = nil
			distanceAniLc = 0
			rightOrLeftLC = 0
			moveLackeys()
		}
		for (lck,_) in tupleLackeys
		{
			lck.center.x -= animationX
		}
		distanceAniLc += 1
		shotOfLackeys()
	}
	
	//---- Lackeys Fonctions ----
	func shotOfLackeys()
	{
		let shot = Double(arc4random_uniform(tupleLackeysMode.sampleSpace))
		let theChosenOne: UIView!
		//----- Condition to call the fonction
		if shot <= tupleLackeysMode.probabilityShot && aniBulletLackey == nil && arrayLackeysDisplaced.count < 24
		{
			theChosenOne = theChosenLackey()
			placeLackeyShot(theChosenOne)
			//---- Shot
			lackeyShot()
			//---- Shot's sound
			tupleSounds.sound_shotLackey.play()
		}
	}
	//--------- Lackeys shots --------
	func lackeyShot()
	{
		aniBulletLackey = Timer.scheduledTimer(timeInterval: tupleLackeysMode.speedShot,
											   target: self,
											   selector: #selector(animationLackeyShot),
											   userInfo: nil,
											   repeats: true)
	}
	//----- object to animation ------
	@objc func animationLackeyShot()
	{
		distanceLcBullet += 1
		
		if distanceLcBullet >= maxMsDistance
		{
			aniBulletLackey.invalidate()
			aniBulletLackey = nil
			distanceLcBullet = 0
		}
		
		for i in 0..<arrayLackeyBullets.count
		{
			//--- Left wall lackey bullets reflections
			if arrayLackeyBullets[i].center.x < arrayLackeyBullets[i].frame.width / 2
			{
				arrayCosLc[i] = __cospi((540 - arrayAnglesLc[i]) / 180)
				arraySinLc[i] = __sinpi((540 - arrayAnglesLc[i]) / 180)
			}
			//--- Right wall lackey bullets reflections
			if arrayLackeyBullets[i].center.x > self.view.frame.width - arrayLackeyBullets[i].frame.width / 2
			{
				arrayCosLc[i] = __cospi((540 - arrayAnglesLc[i]) / 180)
				arraySinLc[i] = __sinpi((540 - arrayAnglesLc[i]) / 180)
			}
			
			arrayLackeyBullets[i].center.x -= CGFloat(arrayCosLc[i])
			arrayLackeyBullets[i].center.y -= CGFloat(arraySinLc[i])
		}
		//---- Condition to kill Normandy
		for bullet in arrayLackeyBullets
		{
			if bullet.frame.intersects(tupleNormandy[0].view.frame)
			{
				//--- Damage Normandy
				tupleNormandy[0].life -= 1
				//--- Touch normandy's sound
				tupleSounds.sound_touchNormandy.play()
				//--- Show current lifes
				lifes()
				//--- Remove Bullet and phantom
				bullet.removeFromSuperview(); bullet.frame.origin.x = -500
				//--- Death's condition
				if tupleNormandy[0].life == 0
				{
					death(normandy, tupleNormandy[0].view, bullet)
				}
			}
		}
	}
	//------ Choose the lackey to shot -------
	func theChosenLackey() -> UIView
	{
		arrayLackeysToShot = []
		
		for i in 0..<tupleLackeys.count
		{
			if tupleLackeys[i].view.frame.origin.x != -500		/* Condition to remove the dead lackeys */
			{
				arrayLackeysToShot.append(tupleLackeys[i].view)
			}
		}
		
		let chosen = Int(arc4random_uniform(UInt32(arrayLackeysToShot.count)))
		
		return arrayLackeysToShot[chosen]
	}
	//------ Place the bullet to shot -------
	func placeLackeyShot(_ theChosen: UIView)
	{
		for bullet in arrayLackeyBullets
		{
			bullet.center.x = theChosen.center.x
			bullet.center.y = theChosen.center.y
			
			self.view.addSubview(bullet)
		}
		
		anglesDivisedLc = (tupleLackeysMode.maxAngle - tupleLackeysMode.minAngle) / Double(arrayLackeyBullets.count)		/* it is the incremantations for each bullet */
		var angle: Double = 0
		
		arraySinLc = []; arrayCosLc = []
		while arrayCosLc.count != arrayLackeyBullets.count
		{
			let cos = __cospi((tupleLackeysMode.minAngle + angle)/180); arrayCosLc.append(cos)
			let sin = __sinpi((tupleLackeysMode.minAngle + angle)/180); arraySinLc.append(sin)
			//---- Angles to reflection
			arrayAnglesLc.append(tupleLackeysMode.minAngle + angle)
			angle += anglesDivisedLc
		}
	}
	//=====================================================================
	/*********************************************************************************************************
	*																										 *
	*										LIFE, DEATH AND MUSIC FUNCTIONS									 *
	*																										 *
	**********************************************************************************************************/
    //======================== Life's countdown ===========================
    func lifes()
	{
		switch tupleNormandy[0].life
		{
		case 0:
			img_life5.isHidden = true; img_life4.isHidden = true
			img_life3.isHidden = true; img_life2.isHidden = true
			img_life1.isHidden = true
			break
		case 1:
			img_life5.isHidden = true; img_life4.isHidden = true
			img_life3.isHidden = true; img_life2.isHidden = true
			break
		case 2:
			img_life5.isHidden = true; img_life4.isHidden = true
			img_life3.isHidden = true
			break
		case 3:
			img_life5.isHidden = true; img_life4.isHidden = true
			break
		case 4:
			img_life5.isHidden = true
			break
		default:
			break
		}
	}
	//======================== Death's function ===========================
    func death(_ whoIsDead: String,_ theDead: UIView,_ theBullet: UIView)
	{
		switch whoIsDead							//Do and call the animations before remove
		{
		case lackey:
			//---- Death's sound
			tupleSounds.sound_deathLackey.play()
			//----
			theDead.removeFromSuperview()			/* Remove the lackey from the main view */
            theDead.frame.origin.x = -500			/* Remove the phanton to position -500 */
			arrayLackeysDisplaced.append(theDead)	/* Add the dead lackeys to conditions */
			break
			
		case normandy:
			//---- Death's sound
			tupleSounds.sound_explosion.play()
			//----
			theDead.removeFromSuperview()
			//button_startGame.isEnabled = false
			gameOver()
			break
			
		case mothership:
			//---- Death's sound
			tupleSounds.sound_explosion.play()
			//----
			theDead.removeFromSuperview()
            theDead.frame.origin.x = -500
			victory()
			break
			
		default:
			break
		}
	}
	//=====================================================================
	//======================= Background music ============================
	func playMusic()
	{
		aniMusicTimer = Timer.scheduledTimer(timeInterval: 1,
											 target: self,
											 selector: #selector(music),
											 userInfo: nil,
											 repeats: true)
	}
	@objc func music()
	{
		for j in 0..<arrayMusics.count
		{
			if arrayMusics[j].isPlaying == true { return }
		}
		
		let randomMusic = Int(arc4random_uniform(UInt32(arrayMusics.count)))
		arrayMusics[randomMusic].play()
	}
	//=====================================================================
	/*********************************************************************************************************
	*																										 *
	*											END OF GAME FUNCTIONS										 *
	*																										 *
	**********************************************************************************************************/
	func gameOver()
	{
		//--- Stop animations
		aniMusicTimer.invalidate(); aniMusicTimer = nil
		if aniScoreTimer != nil
		{ aniScoreTimer.invalidate(); aniScoreTimer = nil }
		if aniBulletTimer != nil
		{ aniBulletTimer.invalidate(); aniBulletTimer = nil }
		if aniBulletLackey != nil
		{ aniBulletLackey.invalidate(); aniBulletLackey = nil }
		if aniBulletMothership != nil
		{ aniBulletMothership.invalidate(); aniBulletMothership = nil }
		if aniRightMothershipTimer != nil
		{ aniRightMothershipTimer.invalidate(); aniRightMothershipTimer = nil }
		if aniLeftMothershipTimer != nil
		{ aniLeftMothershipTimer.invalidate(); aniLeftMothershipTimer = nil }
		if aniRightLackeysTimer != nil
		{ aniRightLackeysTimer.invalidate(); aniRightLackeysTimer = nil }
		if aniLeftLackeysTimer != nil
		{ aniLeftLackeysTimer.invalidate(); aniLeftLackeysTimer = nil }
		//--- Stop music
		for mus in arrayMusics { if mus.isPlaying == true { mus.stop() } }
		//--- Show menu game over
		view_gameOver.isHidden = false
		//--- Play game over music
		tupleSounds.mus_gameover.play()
	}
	func victory()
	{
		//--- Stop animations
		if aniMusicTimer != nil
		{aniMusicTimer.invalidate(); aniMusicTimer = nil}
		if aniScoreTimer != nil
		{ aniScoreTimer.invalidate(); aniScoreTimer = nil }
		if aniBulletLackey != nil
		{ aniBulletLackey.invalidate(); aniBulletLackey = nil }
		if aniBulletMothership != nil
		{ aniBulletMothership.invalidate(); aniBulletMothership = nil }
		if aniRightMothershipTimer != nil
		{ aniRightMothershipTimer.invalidate(); aniRightMothershipTimer = nil }
		if aniLeftMothershipTimer != nil
		{ aniLeftMothershipTimer.invalidate(); aniLeftMothershipTimer = nil }
		if aniRightLackeysTimer != nil
		{ aniRightLackeysTimer.invalidate(); aniRightLackeysTimer = nil }
		if aniLeftLackeysTimer != nil
		{ aniLeftLackeysTimer.invalidate(); aniLeftLackeysTimer = nil }
		//--- Stop music
		for mus in arrayMusics { if mus.isPlaying == true { mus.stop() } }
		//--- Change text
		object_style.styleUILabelSetText(label_gameOver, "Victory!")
		//--- Show menu game over
		view_gameOver.isHidden = false
		//--- Play game over music
		tupleSounds.mus_endgame.play()
		
		if realTime < bestTime
		{ object_saveLoad.saveData(theData: realTime as AnyObject, fileName: dificultyMode) }
	}
	func score()
	{
		aniScoreTimer = Timer.scheduledTimer(timeInterval: 0.01,
											 target: self,
											 selector: #selector(scoreTime),
											 userInfo: nil,
											 repeats: true)
	}
	@objc func scoreTime() { realTime += 0.01; label_score.text = "\((realTime * 10).rounded()/10)" }
	
	@IBAction func menu_gameOver(_ sender: UIButton)
	{
		if tupleSounds.mus_endgame.isPlaying == true { tupleSounds.mus_endgame.stop() }
		if tupleSounds.mus_gameover.isPlaying == true { tupleSounds.mus_gameover.stop() }
	}
}


















