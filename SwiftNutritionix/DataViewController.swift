//
//  DataViewController.swift
//  Foogle
//
//  Created by Krysia O on 2/4/17.
//  Copyright © 2017 Krysia. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {

    @IBOutlet weak var dataLabel: UILabel!
    var dataObject: String = ""

    @IBOutlet weak var customInput: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        customInput.delegate = self
    }

    override func didReceiveMemoryWarning() {
    //    weak var customText: UITextField!
              super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
     //   self.dataLabel!.text = dataObject
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "scannerSegue" {
            let destination = segue.destinationViewController as! ResultsViewController
            let allergies = Allergies(peanut: false, soy: false, custom: customInput.text ?? "")
            destination.allergies = allergies
        }
    }
}

extension DataViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}