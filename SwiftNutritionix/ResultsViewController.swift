//
//  ResultsViewController.swift
//  Foogle
//
//  Created by Krysia O on 2/4/17.
//  Copyright © 2017 Krysia. All rights reserved.
//

import UIKit

struct Allergies {
    let peanut: Bool
    let soy: Bool
    let custom: String
}

class ResultsViewController: UIViewController {

    @IBOutlet weak var customInputLabel: UILabel!
    var allergies: Allergies!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        customInputLabel.text = allergies?.custom
        // = allergies?.peanut
        
        let upc = "49000036756"
        let url = NSURL(string: "https://api.nutritionix.com/v1_1/item?upc=\(upc)&appId=7ae9c03a&appKey=fdd9aab99c312dd07dda6d4f36278794")!
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            
            let string = String(data: data!, encoding: NSUTF8StringEncoding)
            print(string)
            
            let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: [])
            print(json)
            
            let root = json as! [String:AnyObject]
            print(root.keys)
            
            /* if root.containsValue(custom) {
             
             
             }*/
            
            //            self.customInputLabel.text = root["error_code"] as! String
            let ingredients = root["nf_ingredient_statement"] as! String
            print(ingredients)
            //
            
            }.resume()
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
