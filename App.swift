// Force your view controller to use the entire window frame size
override func viewDidLoad() {
    super.viewDidLoad()
    
    // 1. Configure viewport layout frames to span the entire screen boundaries
    let webConfiguration = WKWebViewConfiguration()
    webConfiguration.allowsInlineMediaPlayback = true
    webConfiguration.mediaTypesRequiringUserActionForPlayback = []
    
    // Use view.bounds instead of safeAreaLayoutGuide to eliminate the top/bottom space
    let webView = WKWebView(frame: self.view.bounds, configuration: webConfiguration)
    webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    // 2. Disable layout constraints from clipping to safe areas
    webView.scrollView.contentInsetAdjustmentBehavior = .never
    
    self.view.addSubview(webView)
}
