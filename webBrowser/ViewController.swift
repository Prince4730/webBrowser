//
//  ViewController.swift
//  webBrowser
//
//  Created by praveen on 17/06/20.
//  Copyright © 2020 prince. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController,SFSafariViewControllerDelegate {
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var searchUrl: UIButton!
    var urlString=""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchUrl.isEnabled=false
        searchUrl.isSelected=false
        searchUrl.alpha=0.5
        searchbar.delegate=self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @IBAction func search(_ sender: Any) {
        openSafariWebView()
    }
    
    func openSafariWebView(){
        if  (urlString.contains("HTTP://") || urlString.contains("HTTPS://"))
        {
            
            urlString = urlString.replacingOccurrences(of: "HTTPS://", with: "")
            urlString=urlString.lowercased()
        }
        else{
            urlString=urlString.lowercased()
        }
        let originalString = urlString
        var escapedString = originalString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        escapedString = "https://www.google.com/search?client=safari&rls=en&q=\(escapedString ?? "")"
        
        if urlString.contains("youtube")
        {
            showAlert()
        }
        else{
            if let url = URL(string: escapedString ?? "") {
                var safariController: SFSafariViewController?
                if #available(iOS 11.0, *) {
                    safariController = SFSafariViewController(url: url)
                } else {
                    safariController = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                }
                safariController?.delegate = self
                present(safariController ?? self, animated: true)
            }
        }
        
        
    }
    
    func showAlert(){
        
        let alert = UIAlertController(title: "Alert!", message: "Sorry,this page can’t be loaded", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            let shift = keyboardSize.height/2
            
            self.view.frame.origin.y = -shift
            
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
}

extension ViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        urlString=searchText.uppercased()
        searchUrl.isEnabled=true
        if searchText.count==0{
            searchUrl.alpha=0.5
        }
        else{
            searchUrl.alpha=1.0
        }
    }
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar)
    {
        openSafariWebView()
    }
}

