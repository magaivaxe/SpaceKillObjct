//
//  GameMode.swift
//  SpaceKill
//
//  Created by Marcos Gomes on 17-12-28.
//  Copyright © 2017 marcos. All rights reserved.
//

//------- Libraries -------
import Foundation
//-------------------------

/*********************************************************************************************************
*																										 *
*		GAMEMODE CLASS - It establish the game's mode (normal, hard, diabolic) when the game start		 *
*																										 *
**********************************************************************************************************/


class GameMode
{
	//------- Variables -------
	var tupleNormandyMode: (nBullets: Int, shotSpeed: Double, normandyLife: Int)!
	var tupleMothershipMode: (nMsBullets: Int, mothershipLife: Int, mothershipProbabilityShot: Double,
	sampleSpace: UInt32, mothershipSpeed: Double, mothershipSpeedShot: Double, minAngle: Double, maxAngle: Double)!
	var tupleLackeysMode: (nLcBullets: Int, lackeysLifes: Int, lackeysProbabilityShot: Double,
	sampleSpaceLc: UInt32, lackeySpeed: Double, lackeysSpeedShot: Double, minAngleLc: Double, maxAngleLc: Double)!
	var dm: String!
	//------- Constants -------
	
	//------ Initiation -------
	
	init(dificultyMode dm: String)
	{
		//-- Vars to import
		self.dm = dm
		//-- Vars to load --
	}
	//================================= FUNCTIONS =================================
	func dificultyGameNormandy() -> (Int, Double, Int)
	{
		switch dm
		{
		case "captain": tupleNormandyMode = (1, 0.003, 5)
			break
		case "hero": tupleNormandyMode = (1, 0.0035, 3)
			break
		case "god": tupleNormandyMode = (1, 0.0035, 2)
			break
		default:
			break
		}
		return tupleNormandyMode
	}
	func dificultyGameMothership() -> (Int, Int, Double, UInt32, Double, Double, Double, Double)
	{
		switch dm
		{
		case "captain": tupleMothershipMode = (5, 10, 1, 300, 0.01, 0.008, 235, 315)
			break
		case "hero": tupleMothershipMode = (10, 15, 1, 200, 0.008, 0.006, 230, 315)
			break
		case "god": tupleMothershipMode = (15, 20, 1, 100, 0.006, 0.005, 230, 315)
			break
		default:
			break
		}
		return tupleMothershipMode
	}
	func dificultyGameLackeys() -> (Int, Int, Double, UInt32, Double, Double, Double, Double)
	{
		switch dm
		{
		case "captain": tupleLackeysMode = (3, 1, 1, 300, 0.008, 0.005, 245, 320)
			break
		case "hero": tupleLackeysMode = (6, 2, 1, 200, 0.006, 0.004, 230, 315)
			break
		case "god": tupleLackeysMode = (9, 3, 1, 100, 0.004, 0.0035, 230, 315)
			break
		default:
			break
		}
		return tupleLackeysMode
	}
}


















