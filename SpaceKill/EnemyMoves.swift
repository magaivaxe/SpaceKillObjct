//
//  EnemyMoves.swift
//  SpaceKill
//
//  Created by Marcos Gomes on 17-12-30.
//  Copyright © 2017 marcos. All rights reserved.
//

//------- Libraries -------
import Foundation
import UIKit
//-------------------------

/*********************************************************************************************************
*																										 *
*						ENEMY MOVE CLASS - It do the enemies's moves and animations						 *
*																										 *
**********************************************************************************************************/


class EnemyMoves
{
	//------- Variables -------
	var rightOrLeft: UInt32!
	
	var timerRight: Timer!
	var timerLeft: Timer!
	
	var mv: UIView!
	var tv: [(view: UIView, life: Int)]!
	var tvm: (bullets: Int, life: Int, probabilityShot: Double, sampleSpace: UInt32, speed: Double, speedShot: Double, minAngle: Double, maxAngle: Double)
	
	var mX: CGFloat!
	//-------- Objects --------
	var ne: EnemyShot!
	//------- Constants -------
	
	//------ Initiation -------
	
	init(mainView mv: UIView,
		 tupleOfViews tv: [(view: UIView, life: Int)],
		 tupleOfViewsModes tvm: (bullets: Int, life: Int, probabilityShot: Double, sampleSpace: UInt32, speed: Double, speedShot: Double, minAngle: Double, maxAngle: Double),
		 moveX mX: CGFloat)
	{
		//-- Vars to import
		self.mv = mv
		self.tv = tv
		self.tvm = tvm
		self.mX = mX
		
		//-- Vars to load --
		
	}
	//Time's functions to animate
	func timerMoves()
	{
		//To choice the side to move: 0 is right and 1 is left
		rightOrLeft = arc4random_uniform(2)
		//move to right
		if rightOrLeft == 0
		{
			timerRight = Timer.scheduledTimer(timeInterval: tvm.speed,
											  target: self,
											  selector: #selector(animationToRight),
											  userInfo: nil,
											  repeats: true)
		}
		//move to left
		else
		{
			timerLeft = Timer.scheduledTimer(timeInterval: tvm.speed,
											 target: self,
											 selector: #selector(animationToLeft),
											 userInfo: nil,
											 repeats: true)
		}
	}
	//Animation to right
	@objc func animationToRight()
	{
		//Condition to stop to go right
		if tv[0].view.center.x >= mv.frame.width - (248 / 768 * mv.frame.width) / 2
		{
			//Invalidate timer and nil
			timerRight.invalidate()
			timerRight = nil
			//Change direction
			rightOrLeft = 1
			//Recall
			timerMoves()
		}
		//Animation to right and incrementation mX
		tv[0].view.center.x += mX
		
		//shot here and position shot ******************************
	}
	//Animation to left
	@objc func animationToLeft()
	{
		//Condition to stop to go left
		if tv[0].view.center.x <= (248 / 768 * mv.frame.width) / 2
		{
			//Invalidate timer and nil
			timerLeft.invalidate()
			timerLeft = nil
			//Change direction
			rightOrLeft = 0
			//Recall
			timerMoves()
		}
		//Animation to left and incramentation mX
		tv[0].view.center.x -= mX
		
		//shot here and position shot ******************************
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

}

