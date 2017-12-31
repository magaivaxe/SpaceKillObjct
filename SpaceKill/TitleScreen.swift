/*
SpaceWar.swift
SpaceKill

Created by eleves on 17-12-04.
Copyright © 2017 marcos. All rights reserved.
*/

import UIKit
import Foundation
import AVFoundation

class TitleScreen: UIViewController
{
	//------------- Outlets -------------
	@IBOutlet weak var imgView_logo: UIImageView!
	@IBOutlet weak var button_startGame: UIButton!
	@IBOutlet weak var button_captainMode: UIButton!
	@IBOutlet weak var button_heroWar: UIButton!
	@IBOutlet weak var button_godWar: UIButton!
	@IBOutlet weak var label_gameMode: UILabel!
	@IBOutlet weak var label_title: UILabel!
	//-----------------------------------
	//------------ Variables ------------
	var arrayButtons: [UIButton]!
	var timerMusic: Timer!
	var audioBgMusic = AVAudioPlayer()
	var audioClickStart = AVAudioPlayer()
	var audioMode = AVAudioPlayer()
	//-----------------------------------
	//------------ Constants ------------
	let modeCaptain = "captain"
	let modeHero = "hero"
	let modeGod = "god"
	//-----------------------------------
	//------------- Classes -------------
	let object_style = Styles()
	let object_saveLoad = SaveAndLoad()
	//-----------------------------------
	//============================ viewDidLoad ============================
    override func viewDidLoad()
	{
        super.viewDidLoad()
		
		setArrays(); musicsAndSounds(); elementsStyles(); playBgMusic()
		
		
		
    }
	//=====================================================================
	//========================== Action Buttons ===========================
	@IBAction func start_game(_ sender: UIButton)
	{
		audioClickStart.play()
		
		if (button_captainMode.alpha == 1 && button_heroWar.alpha == 1 &&
			button_godWar.alpha == 1)
		{
			object_saveLoad.saveData(theData: modeCaptain as AnyObject,
									 fileName: "fileMode")
		}
		else if button_captainMode.alpha == 1
		{
			object_saveLoad.saveData(theData: modeCaptain as AnyObject,
									 fileName: "fileMode")
		}
		else if button_heroWar.alpha == 1
		{
			object_saveLoad.saveData(theData: modeHero as AnyObject,
									 fileName: "fileMode")
		}
		else
		{
			object_saveLoad.saveData(theData: modeGod as AnyObject,
									 fileName: "fileMode")
		}
		
		audioBgMusic.stop(); timerMusic.invalidate(); timerMusic = nil
		
		performSegue(withIdentifier: "segueGame", sender: nil)
		
	}
	
	@IBAction func game_mode(_ sender: UIButton)
	{
		audioMode.play()
		
		if sender.tag == 1			/* mode captain */
		{
			button_captainMode.alpha = 1
			button_heroWar.alpha = 0.5
			button_godWar.alpha = 0.5
		}
		else if sender.tag == 2		/* mode hero of war */
		{
			button_captainMode.alpha = 0.5
			button_heroWar.alpha = 1
			button_godWar.alpha = 0.5
		}
		else						/* mode god of war */
		{
			button_captainMode.alpha = 0.5
			button_heroWar.alpha = 0.5
			button_godWar.alpha = 1
		}
	}
	
	
	//=====================================================================
	//========================== Load functions ===========================
	//---- Play background music
	func playBgMusic()
	{
		timerMusic = Timer.scheduledTimer(timeInterval: 1, target: self,
										  selector: #selector(play),
										  userInfo: nil, repeats: true)
	}
	@objc func play()
	{
		if audioBgMusic.isPlaying == false { audioBgMusic.play() }
	}
	//----
	func elementsStyles()
	{
		object_style.styleArrayOfUIButtons(arrayButtons, UIFont.init(name: "Space Age", size: 20), UIColor.white,
										   15, 1, UIColor.white.cgColor, UIColor.black.cgColor, 1)
		
		object_style.styleUILabel(label_title, UIFont.init(name: "Space Age", size: 60), NSTextAlignment.center,
								  "SPACE KILL", 0, 0, UIColor.black.cgColor, UIColor.black.cgColor)
		
		object_style.styleUILabel(label_gameMode, UIFont.init(name: "Space Age", size: 25), NSTextAlignment.center,
								  "YOUR DESTINY", 0, 0, UIColor.black.cgColor, UIColor.black.cgColor)
		
	}
	//----
	//---- Prepare all sounds and musics
	func musicsAndSounds()
	{
		do
		{
			audioBgMusic = try AVAudioPlayer(contentsOf: .init(fileURLWithPath: Bundle.main.path(forResource: "startMusic", ofType: "mp3")!))
			audioBgMusic.prepareToPlay()
			
			audioClickStart = try AVAudioPlayer(contentsOf: .init(fileURLWithPath: Bundle.main.path(forResource: "clickStart", ofType: "mp3")!))
			audioClickStart.prepareToPlay()
			
			audioMode = try AVAudioPlayer(contentsOf: .init(fileURLWithPath: Bundle.main.path(forResource: "shot", ofType: "wav")!))
			audioMode.prepareToPlay()
			
		}
		catch { print(error) }
	}
	//----
	//---- Set the arrays
	func setArrays()
	{
		arrayButtons = [button_startGame, button_captainMode,
						button_heroWar, button_godWar]
	}
	//----
    //=====================================================================

	

}
