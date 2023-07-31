import SwiftUI
import WebKit
import AVFoundation

func requestMicrophoneAccess() {
    AVAudioSession.sharedInstance().requestRecordPermission { granted in
        if granted {
            // The user granted access to the microphone
        } else {
            // The user did not grant access to the microphone
        }
    }
}

struct ContentView: View {
    var body: some View {
            WebView(url: URL(string: "http://localhost:8080"))
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    requestMicrophoneAccess()
                }
        }
}

struct WebView: UIViewRepresentable {
    let url: URL?

    func makeUIView(context: Context) -> WKWebView  {
        let webView = WKWebView()
        if let url = url {
            webView.load(URLRequest(url: url))
        }
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Update the view if needed
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
