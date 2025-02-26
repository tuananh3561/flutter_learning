/// Defines the different game modes available
enum GameMode {
  /// Single player mode against AI opponents
  singlePlayer,

  /// Local multiplayer on the same device
  localMultiplayer,

  /// Online multiplayer with other players
  onlineMultiplayer
}

/// Defines the possible states of a game session
enum GameSessionState {
  /// Lobby/waiting for players to join
  lobby,

  /// Game is being initialized/dealt
  initializing,

  /// Game is in progress
  inProgress,

  /// Game is paused
  paused,

  /// Game has been completed
  completed,

  /// Game has been abandoned before completion
  abandoned
}

/// Defines difficulty levels for AI opponents
enum AIDifficulty {
  /// Easy - Makes random but valid moves
  easy,

  /// Medium - Makes somewhat strategic moves
  medium,

  /// Hard - Makes highly strategic moves
  hard
}

/// Defines player status in a multiplayer game
enum PlayerStatus {
  /// Player is in the lobby but not ready
  notReady,

  /// Player is ready to start
  ready,

  /// Player is currently playing
  playing,

  /// Player has disconnected
  disconnected,

  /// Player has left the game
  left,

  /// Player has been spectating
  spectating
}

/// Defines game rule variants
enum GameRuleVariant {
  /// Standard UNO rules
  standard,

  /// Allow stacking of Draw cards (+2 on +2, +4 on +4, etc.)
  stackingDraw,

  /// Force play of drawn card if possible
  forcePlay,

  /// Skip turn after drawing a card
  skipAfterDraw,

  /// Seven-Zero rule (swap hands on 7, everyone rotates hands on 0)
  sevenZero,

  /// Jump-in rule (play identical card out of turn)
  jumpIn,

  /// Progressive UNO (increasing challenges)
  progressive
}
