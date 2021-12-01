//
//  ServiceManager.swift
//  Currency Convertor
//
//  Created by Ankur Kathiriya on 02/11/21.
//

import UIKit

/// Class to manage API calls related stuff
class ServiceManager: NSObject {
    
    /// Constant
    let REQUEST_TIME_OUT = 120.0
    
    /// To get shared object
    static let shared = ServiceManager()
    
    /// To fire API call
    ///  - Parameter serviceName: API url
    ///  - Parameter parameters: API input/body paramters if any else nil
    ///  - Parameter showLoader: true if need to show loader else false
    ///  - Parameter requestType: API request type like GET, POST, PUT, DELETE
    ///  - Parameter successBlock: Block which contains response dictionary if success
    ///  - Parameter errorBlock: Block which contains error if any failure
    func processServiceCall(serviceName: String,
                            parameters: AnyObject?,
                            showLoader : Bool,
                            requestType : String,
                            successBlock: @escaping (_ responseDict:NSDictionary) -> (),
                            errorBlock: @escaping (_ error:NSError) -> Void)
    {
        if Reachability.isConnectedToNetwork() {
     
            if showLoader == true {
                DispatchQueue.main.async(execute: { () -> Void in
                    //FIXME: Show loader code goes here
                })
            }
            
            let headers = [
                "content-type": "application/json",
                "cache-control": "no-cache"
            ]
            
            do {
                print("Service URL : \(serviceName)")
                
                var postData : Data? = nil
                if parameters != nil {
                    let jsonData: NSData = try JSONSerialization.data(withJSONObject: parameters!, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
                    print("\((serviceName as NSString).lastPathComponent) Parameter : \(NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String)")
                    
                    postData = try JSONSerialization.data(withJSONObject: parameters!, options:JSONSerialization.WritingOptions.prettyPrinted)
                }
                
                let request = NSMutableURLRequest(url: NSURL(string: serviceName)! as URL,
                                                  cachePolicy: .useProtocolCachePolicy,
                                                  timeoutInterval: REQUEST_TIME_OUT)
                request.httpMethod = requestType
                request.allHTTPHeaderFields = headers
                request.httpBody = (postData != nil ? postData : nil)
                
                let session = URLSession.shared
                
                let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                    if (error != nil) {
                        print(error ?? "")
                        DispatchQueue.main.async(execute: { () -> Void in
                            if showLoader == true {
                                //FIXME: Hide loader code goes here
                            }
                            errorBlock(error! as NSError)
                        })
                    } else {
                        do {
                            print("\((serviceName as NSString).lastPathComponent) Response: \(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)")
                            let jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                            print("\((serviceName as NSString).lastPathComponent) Response as Dictionary : \(jsonDictionary)")
                            DispatchQueue.main.async(execute: { () -> Void in
                                if showLoader == true {
                                    //FIXME: Hide loader code goes here
                                }
                                successBlock(jsonDictionary)
                            })
                            
                        } catch let myJSONError {
                            
                            print("\((serviceName as NSString).lastPathComponent) myJSONError : \(myJSONError)")
                            DispatchQueue.main.async(execute: { () -> Void in
                                if showLoader == true {
                                    //FIXME: Hide loader code goes here
                                }
                                errorBlock(myJSONError as NSError)
                            })
                        }
                        
                    }
                })
                
                dataTask.resume()
            }
            catch let error {
                if showLoader == true {
                    //FIXME: Hide loader code goes here
                }
                print("Erro in service call : \(error)")
            }
            
        }
        else {
            let err = NSError(domain: "", code: 501, userInfo:
                
                [NSLocalizedDescriptionKey : "Limited or no internet connectivity. Please try again."])
            errorBlock(err)
            
        }
    }
    
}


