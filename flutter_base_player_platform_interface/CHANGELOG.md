## 0.1.8

- add replay

## 0.1.7

- add track id

## 0.1.6

- support multi instance

## 0.1.5

- support background color
- add precompleteStream

## 0.1.4

add new property

- bool get completed;

## 0.1.3

update some types

## 0.1.2

add BaseTrack and update some types

#### define property
- BaseTrack get videoTrack;
- List<BaseTrack> get videoTracks;
- BaseTrack get audioTrack;
- List<BaseTrack> get audioTracks;
- BaseTrack get subtitleTrack;
- List<BaseTrack> get subtitleTracks;

#### define methods
- void setVideoTrack(BaseTrack track);
- void setAudioTrack(BaseTrack track);
- void setSubtitleTrack(BaseTrack track);

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