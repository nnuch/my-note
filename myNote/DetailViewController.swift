//
//  DetailViewController.swift
//  myNote
//
//  Created by Nuch Phromsorn on 2018-03-02.
//  Copyright © 2018 Nuch Phromsorn. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    var text:String = ""                //1. set view property
    var masterView:ViewController!      //2. new property that referance main viewController
    
    // ! means implicitly unwrapped optional.

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = text
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //first responder refers to the object currently receiving events
        //for this it will automatically bring up the software keyboard
        //when user dismiss the method then it will resignFirstResponder
        
        textView.becomeFirstResponder()
    }
    

    func setText(t:String) {
        text = t
        
        //check if view has load already happened
        if isViewLoaded{
            textView.text = t
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        masterView.newRowText = textView.text
      
    }
 
}
