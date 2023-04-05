## 0.1.0

#### define property
- aspectRatio: double, width / height
- buffered: todo
- duration: Duration
- hasError: bool
- errorMessage: String
- playbackSpeed: double
- position: Duration
- size: Size
- volume: double
- isBuffering: bool
- isInitialized: bool
- isLooping: bool
- isPlaying: bool
- positionStream: ChangeNotifier, events emitter

#### define methods
- assets
- file
- network, set network datasource and init player controler 
- play
- paus
- seek
- setVolume
- setPlaybackSpeed
- setLooping
- builder, video player container