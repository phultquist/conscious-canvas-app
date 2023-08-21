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
    // @State private var url = "https://192.168.0.100:8000";
    @State private var url = "https://192.168.4.85:8000";
    @State private var submitted = false;
    
    var body: some View {
        if (submitted) {
            WebView(url: URL(string: url))
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    requestMicrophoneAccess()
                }.statusBar(hidden: true)
            
        } else {
            VStack(alignment: .center) {
                Text("Enter URL")
                TextField("URL", text: $url)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
                    .frame(width: 200).padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6)).cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(lineWidth: 1)
                    )
            Button(
                action: {
                    self.submitted.toggle()
                }, label: {Text("Submit").padding(EdgeInsets(top: 20, leading: 10, bottom: 10, trailing: 10))})
            }
        }
        
    }
    
    
}

struct WebView: UIViewRepresentable {
    let url: URL?
    let webViewDelgate = WebViewNavigationDelegate()
    let uiDelegate = WebViewUIDelegate()

    func makeUIView(context: Context) -> WKWebView  {
        let webView = WKWebView()
        webView.navigationDelegate = webViewDelgate;
        webView.uiDelegate = uiDelegate;
        if let url = url {
            webView.load(URLRequest(url: url))
        }
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Update the view if needed
    }
}

class WebViewNavigationDelegate: NSObject, WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, cred)
    }
}

class WebViewUIDelegate: NSObject, WKUIDelegate {
    func webView(
        _ webView: WKWebView,
        requestMediaCapturePermissionFor origin: WKSecurityOrigin,
        initiatedByFrame frame: WKFrameInfo,
        type: WKMediaCaptureType,
        decisionHandler: @escaping (WKPermissionDecision) -> Void
    ) {
        NSLog("asking for mic permission")
        decisionHandler(.grant)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
