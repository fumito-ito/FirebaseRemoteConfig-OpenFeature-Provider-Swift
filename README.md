
[![Swift](https://github.com/fumito-ito/FirebaseRemoteConfig-OpenFeature-Provider-Swift/actions/workflows/swift.yml/badge.svg?branch=main)](https://github.com/fumito-ito/FirebaseRemoteConfig-OpenFeature-Provider-Swift/actions/workflows/swift.yml)

# FirebaseRemoteConfig OpenFeature Provider for Swift

This is yet another OpenFeature provider for [Firebase RemoteConfig](https://firebase.google.com/docs/remote-config?hl=en).

## Installation

### Swift Package Manager

In dependencies section of Package.swift add:

```swift
dependencies: [
    .package(
        url: "git@github.com:fumito-ito/FirebaseRemoteConfig-OpenFeature-Provider-Swift.git",
        .upToNextMajor(from: "0.0.1")
    ),
]
```

and in the target dependencies section add:

```swift
.product(name: "FirebaseRemoteConfigOpenFeatureProvider", package: "FirebaseRemoteConfig-OpenFeature-Provider-Swift"),
```

## Usage

Import the `FirebaseRemoteConfigOpenFeatureProvider` and `OpenFeature` modules.

```swift
import FirebaseRemoteConfigOpenFeatureProvider
```

Create and set provider.

```swift
let provider = FirebaseRemoteConfigOpenFeatureProvider(remoteConfig: RemoteConfig.remoteConfig())
let context = MutableContext(targetingKey: "your_targeting_key", structure: MutableStructure())
OpenFeatureAPI.shared.setProvider(provider: provider, initialContext: context)
``` 

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[Apache License 2.0](https://choosealicense.com/licenses/apache-2.0/)
