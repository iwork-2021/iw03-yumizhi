//
//  ItemViewController.swift
//  ITSC
//
//  Created by nju on 2021/11/14.
//

import UIKit
import WebKit

class PageViewController: UIViewController {


    @IBOutlet weak var texttitle: UILabel!
    @IBOutlet weak var textone: UITextView!
    
    @IBOutlet weak var texttwo: UITextView!
    @IBOutlet weak var image: UIImageView!
    
    var Url:String = ""
    var style:String = ""
    let webView = WKWebView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadUrl()
        self.view = self.webView
        //self.temp_loadHtml()
        // Do any additional setup after loading the view.
    }
    
    func temp_loadHtml(){
        let url = URL(string:self.Url)!
        let request = URLRequest(url: url)
        self.webView.load(request)
    }
    
    
    func loadUrl(){
        let url = URL(string:self.Url)!
        print(self.Url)
        let task = URLSession.shared.dataTask(with: url, completionHandler: {
            data, response, error in
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                print("server error")
                return
            }
            
            if let mimeType = httpResponse.mimeType, mimeType == "text/html",
                        let data = data,
                        let string = String(data: data, encoding: .utf8) {
                            DispatchQueue.main.async {
                                
                                var content = ""
                                let lines = string.split(separator: "\r\n")
                                var flag = true
                                
                                for i in lines{
                                    //print(i)
                                    //print("good")
                                    if (i == "<!--Start||head-->") ||
                                        (i == "<!--Start||footer-->") ||
                                        (i == "<!--Start||nav-->") ||
                                        (i == "<!--Start||focus-->")
                                        {
                                        flag = false
                                    }
                                    else if (i == "<!--End||head-->") ||
                                                (i == "<!--End||nav-->") ||
                                                (i == "<!--End||footer-->") ||
                                                (i == "<!--End||focus-->") ||
                                                (i == "</html>")
                                                {
                                                flag = true
                                    }
                                    else if i == "<head>"{
                                        flag = false
                                        content += """
                                        <head>
                                        <meta charset=\"utf-8\">
                                        <meta name=\"renderer\" content=\"webkit\" />
                                        <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge,chrome=1\">
                                        <base href=\"https://itsc.nju.edu.cn/\">
                                        <meta http-equiv=\"pragma\" content=\"no-cache\" />
                                        <meta content=\"yes\" name=\"apple-mobile-web-app-capable\" />
                                        <meta content=\"telephone=no\" name=\"format-detection\" />
                                        <meta name=\"viewport\" content=\"width=device-width,user-scalable=0,initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0 minimal-ui\"/>
                                        """
                                        content += "\r\n"
                                    }
                                    else if i == "<meta name=\"viewport\" content=\"width=device-width,user-scalable=0,initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0\"/>" && flag == false{
                                        flag = true
                                    }
                                    else if i == "<link type=\"text/css\" href=\"/_css/_system/system.css\" rel=\"stylesheet\"/>"{
                                        content+="""
                                        <link type=\"text/css\" href=\"/_css/_system/system.css\" rel=\"stylesheet\"/>
                                        <link type=\"text/css\" href=\"/_upload/site/1/style/49/49.css\" rel=\"stylesheet\"/>
                                        <link type=\"text/css\" href=\"/_upload/site/01/2e/302/style/194/194.css\" rel=\"stylesheet\"/>
                                        <link type=\"text/css\" href=\"/_js/_portletPlugs/simpleNews/css/simplenews.css\" rel=\"stylesheet\" />
                                        <link type=\"text/css\" href=\"/_js/_portletPlugs/sudyNavi/css/sudyNav.css\" rel=\"stylesheet\" />
                                        <link type=\"text/css\" href=\"/_js/_portletPlugs/datepicker/css/datepicker.css\" rel=\"stylesheet\" />

                                        <script language=\"javascript\" src=\"/_js/jquery.min.js\" sudy-wp-context=\"\" sudy-wp-siteId=\"302\"></script>
                                        <script language=\"javascript\" src=\"/_js/jquery.sudy.wp.visitcount.js\"></script>
                                        <script type=\"text/javascript\" src=\"/_js/_portletPlugs/wp_photos/layer/layer.min.js\"></script>
                                        <script type=\"text/javascript\" src=\"/_js/_portletPlugs/sudyNavi/jquery.sudyNav.js\"></script>
                                        <script type=\"text/javascript\" src=\"/_js/_portletPlugs/datepicker/js/jquery.datepicker.js\"></script>
                                        <script type=\"text/javascript\" src=\"/_js/_portletPlugs/datepicker/js/datepicker_lang_HK.js\"></script>
                                        <link href=\"/_upload/tpl/04/04/1028/template1028/wap_resources/style.css\" rel=\"stylesheet\">
                                        <script type=\"text/javascript\">
                                        /*取设备宽度*/
                                        function rem(){
                                            var iWidth=document.documentElement.getBoundingClientRect().width;
                                            iWidth=iWidth>1000?1000:iWidth;
                                            document.getElementsByTagName(\"html\")[0].style.fontSize=iWidth/10+\"px\";
                                        };
                                        rem();
                                        window.onorientationchange=window.onresize=rem
                                        </script>
                                        <body class=\"info\" style=\"width:10rem !important; margin:0 auto;\">
                                        """
                                        flag = false
                                    }
                                    else if i == "</head>"{
                                        content+=i
                                        content+="\r\n"
                                        flag = true
                                    }
                                    
                                    else if i == "<div class=\"wrapper\" id=\"d-container\">"
                                    {
                                        content+="""
                                        <div class=\"wrapper container\">
                                          <div class=\"inner\">
                                            <div class=\"info-box\" frag=\"面板31\">
                                              <div class=\"article\" frag=\"窗口31\" portletmode=\"simpleArticleAttri\">

                                        """
                                        flag = false
                                    }
                                    else if flag == false && i.hasSuffix("simpleArticleAttri\">"){
                                        flag = true
                                    }
                                    else if i == "</body>"{
                                        content+="""
                                        </body>
                                        <script type=\"text/javascript\" src=\"/_upload/tpl/04/04/1028/template1028/wap_resources/js/base.js\"></script>
                                        </html>
                                        """
                                        flag = false
                                    }
                                    
                                    else if flag{
                                        content+=i
                                        content+="\r\n"
                                    }
                                }
                                print(content)
                                self.webView.loadHTMLString(content, baseURL: nil)
                                
                              
                        }
            }
            
        })
        
        task.resume()
        task.priority = 1
    }
    
}


