//
//  EnemyShot.swift
//  SpaceKill
//
//  Created by Marcos Gomes on 17-12-30.
//  Copyright © 2017 marcos. All rights reserved.
//

//------- Libraries -------
import Foundation
import UIKit
import AVFoundation
//-------------------------

/*********************************************************************************************************
*																										 *
*						ENEMYSHOT CLASS - It do the enemies's shots and animations						 *
*																										 *
*						aed = Array of Enemies Displaced: Array of Dead Enemies							 *
**********************************************************************************************************/


class EnemyShot
{
	//------- Variables -------
	var mv: UIView!
	var aeb: [UIView]!
	var aed = [UIView]() //import from death function
	var arraySin = [Double]()
	var arrayCos = [Double]()
	var arrayAngles = [Double]()
	var ate: [(view: UIView, life: Int)]!
	var tem: (bullets: Int, life: Int, probShot: UInt32, sampleSpace: UInt32, speed: Double,
		speedShot: Double, minAngle: Double, maxAngle: Double)!
	var md: Int!
	var ss: AVAudioPlayer!
	
	var displaced: CGFloat = -500
	var distance: Int = 0
	
	var timerShot: Timer!
	//------- Constants -------
	
	//------ Initiation -------
	
	init(mainView mv: UIView,
		 arrayEnemyBullets aeb: [UIView],
		 arrayTupleEnemy ate: [(view: UIView, life: Int)],
		 tupleEnemyMode tem: (bullets: Int, life: Int, probShot: UInt32, sampleSpace: UInt32,
		 	speed: Double, speedShot: Double, minAngle: Double, maxAngle: Double),
		 maxDistance md: Int,
		 shotSound ss: AVAudioPlayer)
	{
		//-- Vars to import
		self.mv = mv
		self.aeb = aeb
		self.ate = ate
		self.tem = tem
		self.md = md
		self.ss = ss
		//-- Vars to load --
	}
	//Function to shot
	func shotOfEnemy()
	{
		//Shot is the minimum number to shot
		let shot = arc4random_uniform(tem.sampleSpace)
		//The chosen that will be shot
		let chosen: UIView!
		//Probability to shot
		if (shot <= tem.probShot && timerShot == nil && aed.count < ate.count)
		{
			//Call the function to choose the enemy
			chosen = chosenEnemy()
			//Call function to place the bullets
			placeBulletsToShot(chosen)
			//Call function to set the angles bullets
			setAnglesShots()
			ss.play()
		}
	}
	//Function shot timer
	func timerOfShot()
	{
		timerShot = Timer.scheduledTimer(timeInterval: tem.speedShot,
										 target: self,
										 selector: #selector(animationShot),
										 userInfo: nil,
										 repeats: true)
	}
	//Function to animate the bullets
	@objc func animationShot()
	{
		//Distace incrementation
		distance += 1
		//Condition to stop timer animation
		if distance >= md
		{
			//To invalidade the timer loop
			timerShot.invalidate()
			//To set value nil to timer
			timerShot = nil
			//New distance
			distance = 0
		}
		
	}
	//Function to place the bullets before the shot
	func placeBulletsToShot(_ chosen: UIView)
	{
		//Loop to place bullets
		for bullet in aeb
		{
			//Set starts positions x and y to bullets
			bullet.center.x = chosen.center.x
			bullet.center.y = chosen.center.y + chosen.frame.height / 2
			//Add the bullet to mainView
			mv.addSubview(bullet)
		}
	}
	//Function to set the angles shots to animation
	func setAnglesShots()
	{
		//Fraction of angle to increment each bullet angle
		let angleFraction = (tem.maxAngle - tem.minAngle) / Double(aeb.count)
		//Angle of each bullet
		var angle: Double = 0
		//Loop to set each bullet angle
		while arrayCos.count != aeb.count
		{
			//Create cos bullet and add it to array
			let cos = __cospi((tem.minAngle + angle) / 180); arrayCos.append(cos)
			//Create sin bullet and add it to array
			let sin = __sinpi((tem.minAngle + angle) / 180); arraySin.append(sin)
			//Array of angles to use on reflections balls
			arrayAngles.append(tem.minAngle + angle)
			//Incrementation of actual angle
			angle += angleFraction
		}
	}
	//Function to choose the alive chosen enemy
	func chosenEnemy() -> UIView
	{
		//array to append the enemies alives
		var enemiesAlives: [UIView] = []
		//loop to check the alives
		for i in 0..<ate.count
		{
			//Condition to remove dead anemies
			if ate[i].view.frame.origin.x != displaced
			{
				//Add the enemies alives
				enemiesAlives.append(ate[i].view)
			}
		}
		//it choose the chosen
		let chosen = Int(arc4random_uniform(UInt32(enemiesAlives.count)))
		//return the enemy chose
		return enemiesAlives[chosen]
	}
	
	
	
	
	
	
	
}









































