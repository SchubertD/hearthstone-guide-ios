//
//  SearchByNameViewController.swift
//  Hearthstone Beginners Guide
//
//  Created by Schubert David Rodríguez on 16/12/15.
//  Copyright © 2015 Schubert David Rodríguez. All rights reserved.
//

import UIKit

class SearchByNameViewController: UIViewController, UITextFieldDelegate {
    
    
    var cards: [Card]?;
    var sessionTask:NSURLSessionDataTask?;
    @IBOutlet weak var menuButton:UIBarButtonItem!

    @IBOutlet weak var nameSearch: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //Save integrity for querys
        guard let queryString:String = nameSearch.text else{
            return false;
        }
        
        if self.sessionTask != nil {
            self.sessionTask!.cancel();
        }else{
            //nameSearch.resignFirstResponder();
            ViewUtil.showLoadingScreen(self.view, object: self.nameSearch);
            
            sessionTask = SearchByClient.searchCardsBy(Endpoints.HEARTHSTONE_API_CARDS_SEARCH_NAME_ENDPOINT, query: queryString, location: currentLanguage!) { (cards, error) -> Void in
                //Go to the server
                self.cards = cards;
                if let c = self.cards{
                    if c.count > 0 {
                        //Add operation to the main thread
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            //Excute the segue
                            ViewUtil.hideLoadingScreen(self.view);
                            self.performSegueWithIdentifier("searchByNameSegue", sender: nil);
                            self.sessionTask = nil;

                            
                        })
                    }else{
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            ViewUtil.hideLoadingScreen(self.view);
                            ViewUtil.alertMessage(self, title: "Error", message: "There are not results for your search");
                        })
                    }
                }else{
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        ViewUtil.hideLoadingScreen(self.view);
                        ViewUtil.alertMessage(self, title: "Error", message: "There are not results for your search");
                        self.sessionTask = nil;
                    })
                }
            }
        }
        
        return true;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let cardTableViewController = segue.destinationViewController as? CardTableViewController {
            cardTableViewController.cards = cards;
        }
        
    }
    
}
