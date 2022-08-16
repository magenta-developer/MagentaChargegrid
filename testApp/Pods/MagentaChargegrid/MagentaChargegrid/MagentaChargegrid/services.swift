//
//  services.swift
//  MagentaChargegrid
//
//  Created by DEEPAK KUMAR on 16/08/22.
//

import Foundation

var DEVELOPMENT_BASE_URL = "http://stage.magentachargegrid.com"
let GET_ACCESSTOKEN_API = "/cm/api/v1/driver/guestuser"
let CHARGERLIST_API = "/am/api/v1/getlocations?source=HpPay"
let GET_STATIONDETAILS_API =  "/sm/secure/api/v1/getstationbyname"
let START_CHARGING_REQUEST_API  =  "/sm/secure/api/v1/remote/start/startinitialize"
let CHARGING_PROGRESS_API = "/tm/secure/api/v1/charging/progress"
let REQUEST_CHARGING_STOP_API = "/sm/secure/api/v1/remote/stop"
let GENERATE_RECEIPT_API = "/tm/secure/api/v1/charging/receipt"
var Token_ID = "basic eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb3VyY2UiOiJIcFBheSIsImV4cCI6MTY1OTUyNzUwNiwiaWF0IjoxNjU5MDk1NTA2LCJpc3MiOiJ3d3cubWFnZW50YWluZm9tYXRpY3MuY29tIn0._mMP3DuHwg8tCvBA6zcZgh8xj89rKIXpmrt43BGE0mo"



var charger_Id = ""

var location = ""

var mobileNo = 7503482233
var chargebox_id =  ""
var connector_type = ""
var connector_no = ""
var priceplan = ""
var enterprise = ""
var plan_id = "pay as you go"
var createdby = ""
var charging_amount = 0
var transactionid = 0


var responseData = ""








public class services {
   
     
        public static func webservicesAPICalltoGetAccessToken(baseURL:String){

           // DEVELOPMENT_BASE_URL = baseURL
            let Url = String(format: "\(DEVELOPMENT_BASE_URL + GET_ACCESSTOKEN_API)")
           guard let serviceUrl = URL(string: Url) else { return }
           let parameter: [String: Any] = [

                   "source" : "HpPay"


           ]
           var request = URLRequest(url: serviceUrl)
           request.httpMethod = "POST"
           
           guard let httpBody = try? JSONSerialization.data(withJSONObject: parameter, options: []) else {
               return
           }
           request.httpBody = httpBody
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameter, options: []) else {
                return
            }
            request.httpBody = httpBody
            
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let response = response {
                    print(response)
                    print("The response is : ",String(data: data!, encoding: .utf8)!)
                    responseData = String(data: data!, encoding: .utf8)!
                    setDataToUser(responseData:responseData)
                    
                }
                if let data = data {
                    do {
                        
                        
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                        print(json!)
                        Token_ID = json!["token"] as! String
                        Token_ID =  "basic " + Token_ID
                      
                        
                    } catch {
                        print(error)
                      
                    }
                }
            }.resume()
        
        }
        public static func setDataToUser(responseData:String){
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationIdentifier") , object: nil, userInfo: ["responseData": responseData])
        }
        public static func webservicesAPICalltoChargerList() {
          
            let task = URLSession.shared.dataTask(with: URL(string: "\(DEVELOPMENT_BASE_URL + CHARGERLIST_API)")!) { [self](data, response, error) in
                responseData = String(data: data!, encoding: .utf8)!
                setDataToUser(responseData:responseData)
              
                
                if let data = data {
                    do {
                        
                        let someDictionaryFromJSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [[String: Any]]
                        let ListData =  someDictionaryFromJSON[0]
                        print(someDictionaryFromJSON)
                        location  = ListData["id"] as! String
                      
                        
                    } catch {
                        print(error)
                       
                    }
                }
                
            
            }
            task.resume()
         
        }
        
        
        
        
        public static func webservicesAPICalltoStationDetails(location:String) {
            
            
            let Url = String(format: "\(DEVELOPMENT_BASE_URL + GET_STATIONDETAILS_API)")
            guard let serviceUrl = URL(string: Url) else { return }
            let header = [
                
                
                "Authorization": Token_ID,
                "Content-Type": "application/json"
                
                
            ]
            

            let parameters: [String: Any] = [

                    "location" : location,
                    "stationid" : ""



            ]
          
           
            var request = URLRequest(url: serviceUrl)
            request.httpMethod = "POST"
            
            request.allHTTPHeaderFields = header
            
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
                return
            }
            request.httpBody = httpBody
            
            let session = URLSession.shared
            session.dataTask(with: request) { [self] (data, response, error) in
                
                if let data = data {
                    do {
                        print(response)
                        responseData = String(data: data, encoding: .utf8)!
                        setDataToUser(responseData:responseData)
                        let someDictionaryFromJSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                        print(someDictionaryFromJSON)
                        let chargers = someDictionaryFromJSON["chargers"] as! [[String:Any]]
                        
                      
            
                        
                        let connectorsData = chargers[0]["connectors"] as! [[String:Any]]
                        priceplan = chargers[0]["priceplan"] as! String
                      
                        chargebox_id = connectorsData[0]["chargeboxid"] as! String//"CGHP002"
                        connector_type = connectorsData[0]["connectortype"] as! String
                        connector_no = connectorsData[0]["connectorno"] as! String
                     
                        enterprise = connectorsData[0]["enterprise"] as! String//""
                        
                        createdby = connectorsData[0]["createdby"] as! String//"623d665d26a410fd0536ebf4"
                        
                       
                      
                    } catch {
                        print(error)
                        
                    }
                }
            }.resume()
        }
        
        
      
        
        public static func webservicesAPICalltoStartChargingRequest(
                        mobile:Int,
                        chargeboxid:String,
                       connectortype:String,
                       connectorno:String,
                        priceplan:String,
                       enterprise :String,
                       planid:String,
                       createdby:String,
                       chargingamount:Int
        
        ) {
           
            
            let Url = String(format: "\(DEVELOPMENT_BASE_URL + START_CHARGING_REQUEST_API)")
            guard let serviceUrl = URL(string: Url) else { return }
            let header = [
                
                
                "Authorization": Token_ID,
                "Content-Type": "application/json"
                
                
            ]
            
            let parameters: [String: Any] = [

                    "mobile" : mobile,
                    "chargeboxid" : chargeboxid,
                    "connectortype" : connectortype,
                    "connectorno" : connectorno,
                    "priceplan": priceplan,
                    "enterprise": enterprise,
                    "planid": planid,
                    "createdby": createdby,
                    "chargingamount":chargingamount


            ]
            mobileNo = mobile
            chargebox_id = chargeboxid
           connector_type = connectortype
            connector_no = connectorno
            charging_amount = chargingamount
            plan_id = planid
          
          
            var request = URLRequest(url: serviceUrl)
            request.httpMethod = "POST"
            
            request.allHTTPHeaderFields = header
            
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
                return
            }
            request.httpBody = httpBody
            
            let session = URLSession.shared
            session.dataTask(with: request) { [self] (data, response, error) in
             
                if let data = data {
                    do {
                        responseData = String(data: data, encoding: .utf8)!
                        setDataToUser(responseData:responseData)
                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                   print(json)
                        transactionid = json["transactionid"] as! Int
                      
                       
                    } catch {
                        print(error)
                       
                    }
                }
            }.resume()
        }
       
        
        public static func webservicesAPICalltoChargingProgress(transectionId:Int) {
           
            let Url = String(format: "\(DEVELOPMENT_BASE_URL + CHARGING_PROGRESS_API)")
            guard let serviceUrl = URL(string: Url) else { return }
            
            let header = [
                
                
                "Authorization": Token_ID,
                "Content-Type": "application/json"
                
                
            ]
            
            var parameters: [String: Any] = [
               
                    "mobile" : mobileNo,
                    "chargeboxid" : chargebox_id,
                    "connectortype" : connector_type,
                    "connectorno" : connector_no,
                    "chargingamount": charging_amount,
                    "planid": plan_id,
                  
                    
               
            ]
            
            parameters["transactionid"] = transectionId
          
            var request = URLRequest(url: serviceUrl)
            request.httpMethod = "POST"
            
            request.allHTTPHeaderFields = header
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
                return
            }
            request.httpBody = httpBody
            
            let session = URLSession.shared
            session.dataTask(with: request) { [self] (data, response, error) in
                if let data = data {
                    do {
                        responseData = String(data: data, encoding: .utf8)!
                        setDataToUser(responseData:responseData)
                        print("The response is : ",String(data: data, encoding: .utf8)!)
                      
                    
                } catch {
                    print(error)
                   
                }
            }
            
            }.resume()
        }
        
        
        public static func webservicesAPICalltoChargingStopRequest() {
          
            let Url = String(format: "\(DEVELOPMENT_BASE_URL + REQUEST_CHARGING_STOP_API)")
            guard let serviceUrl = URL(string: Url) else { return }
            
            let header = [
                
                
                "Authorization": Token_ID,
                "Content-Type": "application/json"
                
                
            ]
        
            let parameters: [String: Any] = [
               
                    "mobile" : mobileNo,
                    "chargeboxid" : chargebox_id,
                    "connectortype" : connector_type,
                    "connectorno" : connector_no
                    
                    
                    
              
            ]
           
            var request = URLRequest(url: serviceUrl)
            request.httpMethod = "POST"
            
            request.allHTTPHeaderFields = header
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
                return
            }
            request.httpBody = httpBody
            
            let session = URLSession.shared
            session.dataTask(with: request) {  (data, response, error) in

                if let response = response {
                    print("The response is : ",String(data: data!, encoding: .utf8)!)
                    responseData = String(data: data!, encoding: .utf8)!
                    setDataToUser(responseData:responseData)
                    }

            }.resume()
        }
        
      
        public static func webservicesAPICalltoGenerateReceipt() {
           
            
            
            let Url = String(format: "\(DEVELOPMENT_BASE_URL + GENERATE_RECEIPT_API)")
            guard let serviceUrl = URL(string: Url) else { return }
            
            let header = [
                
                
                "Authorization": Token_ID,
                "Content-Type": "application/json"
                
                
            ]
            
            
            let parameters: [String: Any] = [
               
                    "mobile" : mobileNo,
                    "transactionId" : transactionid
                 
            ]
            print("header   \(header)")
            print("parameters  \(parameters)")
            var request = URLRequest(url: serviceUrl)
            request.httpMethod = "POST"
            
            request.allHTTPHeaderFields = header
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
                return
            }
            request.httpBody = httpBody
            
            let session = URLSession.shared
            session.dataTask(with: request) { [self] (data, response, error) in
                if let data = data {
                    do {
                        responseData = String(data: data, encoding: .utf8)!
                        setDataToUser(responseData:responseData)
                        print("The response is : ",String(data: data, encoding: .utf8)!)
                    
                  
                } catch {
                    print(error)
                   
                }
            }
            }.resume()
        }
        
        
    }
