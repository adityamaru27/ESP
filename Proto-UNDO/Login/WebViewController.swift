//
//  WebViewController.swift
//  Proto-UNDO
//
//  Created by Santu C on 24/11/15.
//  Copyright © 2015 Curly Brackets. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!

    var myActivityIndicator : UIActivityIndicatorView!
    var isPrivacy : Bool! = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var urlString : String!
        
        if isPrivacy ==  true
        {
            urlString = "http://eatsleeppoopapp.com/privacy.html"
            self.title = "Privacy"
        }
        else
        {
            urlString = "http://eatsleeppoopapp.com/terms.html"
             self.title = "Terms"
        }
        
        let url = NSURL (string: urlString)
        let requestObj = NSURLRequest(URL: url!)
        webView.loadRequest(requestObj)
        

        let refreshButton =  UIBarButtonItem(title: "Close", style: .Plain, target: self, action: #selector(WebViewController.closeMethod))
        navigationItem.rightBarButtonItem = refreshButton

       
        
        myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        myActivityIndicator.center = view.center
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)
        
        
        // Do any additional setup after loading the view.
    }

    
    func webViewDidStartLoad(webView: UIWebView){
        
        myActivityIndicator.hidden = false
        myActivityIndicator.startAnimating()
        
    }
    func webViewDidFinishLoad(webView: UIWebView){
        
        myActivityIndicator.hidden = true
        myActivityIndicator.stopAnimating()
    }
    
    func webView(_ webView: UIWebView,
        didFailLoadWithError error: NSError?)
    {
        myActivityIndicator.hidden = true
        myActivityIndicator.stopAnimating()
    }

    



    
    func closeMethod() {
        
       self.dismissViewControllerAnimated(true, completion: {});
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
