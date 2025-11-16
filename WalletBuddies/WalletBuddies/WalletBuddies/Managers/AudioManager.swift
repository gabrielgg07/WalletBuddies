import AVFoundation

class AudioManager: ObservableObject {
    static let shared = AudioManager()
    private var player: AVAudioPlayer?

    func playSound(named fileName: String) {
        // 🔥 FIX IS HERE — use fileName, not audio1
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
            print("❌ Audio file '\(fileName).mp3' not found in bundle")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("❌ Error playing audio: \(error)")
        }
    }

    func stop() {
        player?.stop()
    }

    func toggle(name: String) {
        if player?.isPlaying == true {
            player?.stop()
        } else {
            playSound(named: name)
        }
    }
}
