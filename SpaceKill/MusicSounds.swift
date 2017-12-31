//
//  GameMode.swift
//  SpaceKill
//
//  Created by Marcos Gomes on 17-12-28.
//  Copyright © 2017 marcos. All rights reserved.
//

//------- Libraries -------
import Foundation
import AVFoundation
//-------------------------

/*********************************************************************************************************
*																										 *
*		GAMEMODE CLASS - It establish the game's mode (normal, hard, diabolic) when the game start		 *
*																										 *
**********************************************************************************************************/

class MusicSounds
{
	//------- Variables -------
	var tupleSounds: (mus_endgame: AVAudioPlayer, mus_gameover: AVAudioPlayer, sound_touchMothership: AVAudioPlayer, sound_touchNormandy: AVAudioPlayer, sound_deathLackey: AVAudioPlayer, sound_explosion: AVAudioPlayer, sound_shotLackey: AVAudioPlayer, sound_shotMothership: AVAudioPlayer, sound_shot: AVAudioPlayer)!
	var arrayBackgroundMusics = [AVAudioPlayer]()
	var meg: AVAudioPlayer!
	var mgo: AVAudioPlayer!
	var sdl: AVAudioPlayer!
	var sep: AVAudioPlayer!
	var ssl: AVAudioPlayer!
	var ssm: AVAudioPlayer!
	var ssn: AVAudioPlayer!
	var stm: AVAudioPlayer!
	var stn: AVAudioPlayer!
	//------- Constants -------
	
	//------ Initiation -------
	
	init()
	{
		//-- Vars to import
		//---- Prepare sounds
		do
		{
			meg = try AVAudioPlayer(contentsOf: .init(fileURLWithPath: Bundle.main.path(forResource: "endgame", ofType: "mp3")!))
			meg.prepareToPlay()
			
			mgo = try AVAudioPlayer(contentsOf: .init(fileURLWithPath: Bundle.main.path(forResource: "gameover", ofType: "mp3")!))
			mgo.prepareToPlay()
			
			stm = try AVAudioPlayer(contentsOf: .init(fileURLWithPath: Bundle.main.path(forResource: "touchMothership", ofType: "mp3")!))
			stm.prepareToPlay()
			
			stn = try AVAudioPlayer(contentsOf: .init(fileURLWithPath: Bundle.main.path(forResource: "touchNormandy", ofType: "mp3")!))
			stn.prepareToPlay()
			
			sdl = try AVAudioPlayer(contentsOf: .init(fileURLWithPath: Bundle.main.path(forResource: "deathLackey", ofType: "wav")!))
			sdl.prepareToPlay()
			
			sep = try AVAudioPlayer(contentsOf: .init(fileURLWithPath: Bundle.main.path(forResource: "explosion", ofType: "wav")!))
			sep.prepareToPlay()
			
			ssl = try AVAudioPlayer(contentsOf: .init(fileURLWithPath: Bundle.main.path(forResource: "shotLackey", ofType: "mp3")!))
			ssl.prepareToPlay()
			
			ssm = try AVAudioPlayer(contentsOf: .init(fileURLWithPath: Bundle.main.path(forResource: "shotMothership", ofType: "wav")!))
			ssm.prepareToPlay()
			
			ssn = try AVAudioPlayer(contentsOf: .init(fileURLWithPath: Bundle.main.path(forResource: "shot", ofType: "wav")!))
			ssn.prepareToPlay()
		}
		catch { print(error) }
		
		for i in 1...8
		{
			do
			{	//---- Dynamic musics creation ----
				let music = try AVAudioPlayer(contentsOf: .init(fileURLWithPath: Bundle.main.path(forResource: "music\(i)", ofType: "mp3")!))
				music.prepareToPlay()
			
				arrayBackgroundMusics.append(music)	/* Add to array to random play */
			}
			catch { print(error) }
		}
		//-- Vars to load --
		tupleSounds = (meg, mgo, stm, stn, sdl, sep, ssl, ssm, ssn)
	}
	
	func returnArrayMusics() -> [AVAudioPlayer] { return arrayBackgroundMusics }
	
	func returnTupleSounds() -> (AVAudioPlayer, AVAudioPlayer, AVAudioPlayer, AVAudioPlayer,
								 AVAudioPlayer, AVAudioPlayer, AVAudioPlayer, AVAudioPlayer, AVAudioPlayer)
	{ return tupleSounds }
}


















