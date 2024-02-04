import SwiftUI
import FirebaseRemoteConfig
import FirebaseRemoteConfigOpenFeatureProvider

struct ContentView: View {
    var remoteConfig: RemoteConfig?
    var provider: FirebaseRemoteConfigOpenFeatureProvider?
    
    @RemoteConfigProperty(key: "LocalString", fallback: "")
    var localString: String
    @RemoteConfigProperty(key: "RemoteString", fallback: "")
    var remoteString: String

    init() {
        let config = RemoteConfig.remoteConfig()
        try! config.setDefaults(from: [
            "LocalString": "This is local string value for Demo"
        ])
        config.fetchAndActivate()
        
        provider = FirebaseRemoteConfigOpenFeatureProvider(remoteConfig: config)
        remoteConfig = config
    }

    var body: some View {
        VStack {
            Text("RemoteConfig Direct Value").font(.title)
            Text(localString)
            Text(remoteString)

            Spacer().frame(height: 100)

            Text("Through Provider Value").font(.title)
            Text(try! provider!.getStringEvaluation(key: "LocalString", defaultValue: "", context: nil).value)
            Text(try! provider!.getStringEvaluation(key: "RemoteString", defaultValue: "", context: nil).value)
        }
    }
}
