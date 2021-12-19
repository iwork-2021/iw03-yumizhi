//
//  ViewController.swift
//  ITSC
//
//  Created by Chun on 2021/10/19.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    let webView = WKWebView()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view = webView
        load_news_URL()
    }
    func load_news_URL(){
        if let url = URL(string: "https://itsc.nju.edu.cn/xwdt/list.htm") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}

