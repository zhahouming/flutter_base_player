## 0.1.9

- support replay

## 0.1.8

- support replay

## 0.1.7

- support completed state
- add precompleteStream event

## 0.1.6

- fix loading support 

## 0.1.5

- fix buffered 

## 0.1.4

- add track id

## 0.1.3

- fix alignment
- add filename

## 0.1.2

- fix dispose error

## 0.1.1

- Use media_kit for iOS, MacOS, Windows, Linux
- Support multi instance
- handle error

## 0.1.0
Platorm Support

- Android
- iOS
- MacOS
- Windows
- Linux

Property

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

Methods 

- assets
- file
- network, set network datasource and init player controler 
- play
- pause
- seek
- setVolume
- setPlaybackSpeed
- setLooping
- builder, video player container
