import Combine
import Foundation

// MARK: - Volume API

public extension YouTubePlayer {
    
    /// A Publisher that emits the current ``YouTubePlayer/VolumeState``.
    /// - Warning: This Publisher relies on the unoffical `.volumeChange` event and its behavior and availability may change.
    var volumeStatePublisher: some Publisher<VolumeState, Never> {
        self.eventPublisher
            .compactMap { event in
                guard event.name == .volumeChange else {
                    return nil
                }
                return try? event.data?.jsonValue(as: VolumeState.self)
            }
    }
    
    /// Mutes the player.
    func mute() async throws {
        try await self.evaluate(
            javaScript: .youTubePlayer(
                functionName: "mute"
            )
        )
    }
    
    /// Unmutes the player.
    func unmute() async throws {
        try await self.evaluate(
            javaScript: .youTubePlayer(
                functionName: "unMute"
            )
        )
    }
    
    /// Returns Bool value if the player is muted.
    func isMuted() async throws -> Bool {
        try await self.evaluate(
            javaScript: .youTubePlayer(
                functionName: "isMuted"
            ),
            converter: .typeCast()
        )
    }
    
    /// Returns the player's current volume, an integer between 0 and 100
    func getVolume() async throws -> Int {
        try await self.evaluate(
            javaScript: .youTubePlayer(
                functionName: "getVolume"
            ),
            converter: .typeCast()
        )
    }
    
}
