//
//  ViewController.swift
//  ChargeGridSDKTestApp
//
//  Created by DEEPAK KUMAR on 10/08/22.
//

import UIKit
import MagentaChargegrid
class ViewController: UIViewController {
    @IBOutlet weak var baseUrlTxtF: UITextField!
    @IBOutlet weak var stationIDTxtF: UITextField!
    @IBOutlet weak var MobilextF: UITextField!
    @IBOutlet weak var ChargeBoxIdTxtF: UITextField!
    @IBOutlet weak var chargerTypeTxtF: UITextField!
    @IBOutlet weak var chargerSerialNoTxtF: UITextField!
    @IBOutlet weak var planIdTxtF: UITextField!
    @IBOutlet weak var enterpriseTxtF: UITextField!
    @IBOutlet weak var createdByTxtF: UITextField!
    @IBOutlet weak var charginAmountTxtF: UITextField!
    @IBOutlet weak var transectionIDTxtF: UITextField!
    @IBOutlet var tokeRespnseLbl: UILabel!
    @IBOutlet var chargerListRespnseLbl: UILabel!
    @IBOutlet var stationDetailsRespnseLbl: UILabel!
    @IBOutlet var startRespnseLbl: UILabel!
    @IBOutlet var progressRespnseLbl: UILabel!
    @IBOutlet var stopRespnseLbl: UILabel!
    @IBOutlet var RecieptRespnseLbl: UILabel!
        
    var selectedButtonTag = 0
    var charger_Id = ""

    var location = "62e36ddaf6d4f131b372bc71"

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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tokeRespnseLbl.text = ""
        chargerListRespnseLbl.text = ""
        stationDetailsRespnseLbl.text = ""
        startRespnseLbl.text = ""
        progressRespnseLbl.text = ""
        stopRespnseLbl.text = ""
        RecieptRespnseLbl.text = ""
        
        
        
        baseUrlTxtF.text = "http://stage.magentachargegrid.com"
        setupToHideKeyboardOnTapOnView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotificationToken(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
        
      
    }
    @objc func methodOfReceivedNotificationToken(notification: NSNotification){
        
        DispatchQueue.main.async { [self] in
           let responseData = (notification.userInfo?["responseData"] as! String)
            
            switch selectedButtonTag {
                
            case 100 :
                tokeRespnseLbl.text = responseData
            case 101 :
                chargerListRespnseLbl.text = responseData
//                    let data2 = responseData.data(using: <#String.Encoding#>)
//                if let data = responseData{
//                    do {
//                let someDictionaryFromJSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [[String: Any]]
//                let ListData =  someDictionaryFromJSON[0]
//                print(someDictionaryFromJSON)
//                location  = ListData["id"] as! String
//
//                      } catch {
//                          print(error)
//
//                      }
//                  }
                stationIDTxtF.text = location
            case 102 :
                stationDetailsRespnseLbl.text = responseData
                let data2 = responseData.data(using: .utf8)
                if let data = data2{
                    do {
                        
                      
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
                        
                        planIdTxtF.text = plan_id
                        ChargeBoxIdTxtF.text = chargebox_id
                        chargerTypeTxtF.text  = connector_type
                        chargerSerialNoTxtF.text = connector_no
                        enterpriseTxtF.text = enterprise
                        createdByTxtF.text = createdby
                        charginAmountTxtF.text = "0"
                        MobilextF.text = String(mobileNo)
                        
                       
                      
                    } catch {
                        print(error)
                        
                    }
                }
                
            case 103 :
                startRespnseLbl.text = responseData
                let data2 = responseData.data(using: .utf8)
                if let data = data2 {
                    do {
                        
                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                   print(json)
                        transactionid = json["transactionid"] as! Int
                        transectionIDTxtF.text = String(transactionid)
                       
                    } catch {
                        print(error)
                       
                    }
                }
            case 104 :
                progressRespnseLbl.text = responseData

            case 105 :
                stopRespnseLbl.text = responseData

            case 106 :
                RecieptRespnseLbl.text = responseData
                
           
            default:
                break
            }
           
            
        }
        
    }
    @IBAction func GetTokenAction(_ sender: Any) {
        selectedButtonTag  = (sender as AnyObject).tag
        services.webservicesAPICalltoGetAccessToken(baseURL: baseUrlTxtF.text! )
        
        
        
    }
    
    @IBAction func GetChargerList(_ sender: Any) {
        selectedButtonTag  = (sender as AnyObject).tag
        services.webservicesAPICalltoChargerList()
        
        
        
    }
    
    @IBAction func GetStationDetails(_ sender: Any) {
        selectedButtonTag  = (sender as AnyObject).tag
        services.webservicesAPICalltoStationDetails(location: stationIDTxtF.text!)
        
        
        
    }
    @IBAction func GetStartChagingRequest(_ sender: Any) {
        selectedButtonTag  = (sender as AnyObject).tag
        let mobNo :Int? = Int(MobilextF.text!)
        
        let chargingamount :Int? = Int(charginAmountTxtF.text!)
        services.webservicesAPICalltoStartChargingRequest(mobile: mobNo!, chargeboxid:ChargeBoxIdTxtF.text!, connectortype: chargerTypeTxtF.text!, connectorno: chargerSerialNoTxtF.text!, priceplan: planIdTxtF.text!, enterprise: enterpriseTxtF.text!, planid: planIdTxtF.text!, createdby: createdByTxtF.text!, chargingamount: chargingamount!)
        
        
        
    }
    
    @IBAction func GetChagingProgress(_ sender: Any) {
        selectedButtonTag  = (sender as AnyObject).tag
        let transectionId :Int? = Int(transectionIDTxtF.text!)
        services.webservicesAPICalltoChargingProgress(transectionId:transectionId!)
        
        
        
    }
    @IBAction func GetStopChagingRequest(_ sender: Any) {
        selectedButtonTag  = (sender as AnyObject).tag
        
        services.webservicesAPICalltoChargingStopRequest()
        
        
        
    }
    @IBAction func GetReciept(_ sender: Any) {
        selectedButtonTag  = (sender as AnyObject).tag
        
        services.webservicesAPICalltoGenerateReceipt()
        
        
        
    }
    
}

extension UIViewController
{
    func setupToHideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
