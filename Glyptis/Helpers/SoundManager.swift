//
//  SoundManager.swift
//  Glyptis
//
//  Created by Guilherme Ghise Rossoni on 26/11/25.
//

import Foundation
import AVFoundation

class SoundManager {
    
    static let shared = SoundManager()
    private var player: AVAudioPlayer?
    
    private init() {}
    
    func playSound(named name: String, extension ext: String = "mp3", volume: Float = 1.0) {
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
            print("⚠️ SoundManager: Som não encontrado -> \(name).\(ext)")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            
            player?.volume = volume
            
            player?.prepareToPlay()
            player?.play()
            
        } catch {
            print("❌ SoundManager: Erro ao tocar som -> \(error.localizedDescription)")
        }
    }
}
