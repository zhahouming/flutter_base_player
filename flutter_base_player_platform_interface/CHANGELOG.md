## 0.1.1

#### define property
- dynamic get videoTrack;
- dynamic get videoTracks;
- dynamic get audioTrack;
- dynamic get audioTracks;
- dynamic get subtitleTrack;
- dynamic get subtitleTracks;

#### define methods
- void setVideoTrack(dynamic track);
- void setAudioTrack(dynamic track);
- void setSubtitleTrack(dynamic track);

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