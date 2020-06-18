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
    
    var urlString=""
    var search=""
   
    override func viewDidLoad() {
        super.viewDidLoad()
        searchbar.delegate=self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @IBAction func search(_ sender: Any) {
       
        if search.contains(".COM") && (search.contains("HTTP://") || search.contains("HTTPS://"))
        {
            urlString = urlString.replacingOccurrences(of: " ", with: "")
            print(urlString)
        }
        else if search.contains(".COM") && !(search.contains("HTTP://") || search.contains("HTTPS://")){
            urlString="http://" + "\(urlString)"
        }
        else if !(search.contains(".COM")) && (search.contains("HTTP://") || search.contains("HTTPS://")){
            urlString="\(urlString).com"
        }
        else if urlString != ""{
            urlString="http://" + "\(urlString).com"
        }
        if search.contains("YOUTUBE")
        {
            showAlert()
        }
        else{
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            vc.delegate = self
            present(vc, animated: true)
        }
        }
    }
    func showAlert(){
       
        let alert = UIAlertController(title: "Alert!", message: "Sorry,this page can’t be loaded", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

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
        search=searchText.uppercased()
        urlString=search.filter { !$0.isWhitespace }
        
    }
}

