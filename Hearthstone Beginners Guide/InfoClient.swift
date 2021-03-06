//
//  InfoClient.swift
//  Hearthstone Beginners Guide
//
//  Created by Schubert David Rodríguez on 07/12/15.
//  Copyright © 2015 Schubert David Rodríguez. All rights reserved.
//

import Foundation

class InfoClient {
    
    static func searchInfo(completionHandler: (Info?, NSError?) -> Void) -> Void {
        //Check query has a valid value
        guard let url = NSURL(string: ParameterConstants.HEARTHSTONE_API_URI + Endpoints.HEARTHSTONE_API_INFO_ENDPOINT.rawValue) else{
            return;
        }
        //Headers
        let headers = [ParameterConstants.KEY_HEADER_HEARTHSTONE_API: ParameterConstants.VALUE_HEADER_HEARTSTONE_API]
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration();
        sessionConfiguration.HTTPAdditionalHeaders = headers;
        let session = NSURLSession(configuration: sessionConfiguration);
        
        let sessionTask = session.dataTaskWithURL(url) { (data, response, error) -> Void in
            let info = parseInfo(data);
            completionHandler(info, error);
        }
        sessionTask.resume();
        
        
        
    }
    
    
    static func parseInfo(data:NSData?) -> Info?{
        do{
            guard let dta = data else {
                return nil;
            }
            
            if let searchDictionary = try NSJSONSerialization.JSONObjectWithData(dta, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary{
                
                let patch = searchDictionary.objectForKey("patch") as! String;
                let classes = searchDictionary.objectForKey("classes") as! [String];
                let sets = searchDictionary.objectForKey("sets") as! [String];
                let types = searchDictionary.objectForKey("types") as! [String];
                let factions = searchDictionary.objectForKey("factions") as! [String];
                let qualities = searchDictionary.objectForKey("qualities") as! [String];
                let races = searchDictionary.objectForKey("races") as! [String];
                let locales = searchDictionary.objectForKey("locales") as! [String];
                
                return Info(patch:patch, classes:classes,sets: sets,types: types,factions: factions,qualities: qualities,races: races,locales: locales);                
            }
        }catch{
            
        }
        return nil;
        
    }
    
}