import UIKit
import WebKit

class ViewController: UIViewController {
    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Configure viewport layout frames to span the entire screen boundaries
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        webConfiguration.mediaTypesRequiringUserActionForPlayback = []
        
        // 2. Initialize the web view to fill the absolute physical screen glass size
        webView = WKWebView(frame: self.view.bounds, configuration: webConfiguration)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // 3. Disable internal layout constraints from clipping to safe areas (fixes letterboxing)
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        
        self.view.addSubview(webView)
        
        // 4. Point the app to your website or stream URL (Replace with your actual URL)
        if let url = URL(string: "https://google.com") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Build the window context natively to cover the entire device display
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
}
