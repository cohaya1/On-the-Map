//
//  AddNewLocationForMapViewController.swift
//  On the Map
//
//  Created by Makaveli Ohaya on 4/15/20.
//  Copyright © 2020 Ohaya. All rights reserved.
//

import UIKit
import MapKit
class AddNewLocationForMapViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var locationinputTextfield: UITextField!{ didSet {
       locationinputTextfield.becomeFirstResponder()
         locationinputTextfield.delegate = self
        

        }
    }
        @IBOutlet weak var FindOnTheMapButton: UIButton!
    
       var selectedTextField: UITextField?
    
        override func viewDidLoad() {
            super.viewDidLoad()
            FindOnTheMapButton.layer.cornerRadius = 5
            locationinputTextfield.attributedPlaceholder = NSAttributedString(string: "Enter Your Location Here", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        }
        
        override func viewWillAppear(_ animated: Bool) {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.tabBarController?.tabBar.isHidden = true
            subscribeToKeyboardNotifications()
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.tabBarController?.tabBar.isHidden = false
            unsubscribeFromKeyBoardNotifications()
        }

        @IBAction func cancelButtonTapped(_ sender: Any) {
            self.navigationController?.popViewController(animated: true)
        }
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
                     let userInfo = notification.userInfo
                     let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
                     return keyboardSize.cgRectValue.height
                 }
       func subscribeToKeyboardNotifications() {
              // keyboardWillShow
              NotificationCenter.default.addObserver(
              self,
              selector: #selector(self.keyboardWillShow(_:)),
              name: UIResponder.keyboardWillShowNotification, object: nil)
              // keyboardWillHide
              NotificationCenter.default.addObserver(
                 self,
                 selector: #selector(self.keyboardWillHide(_:)),
                 name: UIResponder.keyboardWillHideNotification, object: nil)
            }
          
          @objc func keyboardWillShow(_ notification:Notification) {
              if let text = selectedTextField {
                         if text == locationinputTextfield {
                             self.view.frame.origin.y = -getKeyboardHeight(notification: notification as NSNotification)
              }
              
          }
       }
                @objc func keyboardWillHide(_ notification:Notification) {
                  if selectedTextField != nil {
                     if locationinputTextfield.isEditing, view.frame.origin.y != 0 {
                         view.frame.origin.y = 0
                    }
                }
          }
       func unsubscribeFromKeyBoardNotifications() {
               // keyboardWillShow
               NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
               // keyboardWillHide
               NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
             }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            
            textField.resignFirstResponder()
            return true
        }
        @IBAction func findOnTheMapButtonTapped(_ sender: Any) {
            if locationinputTextfield.text!.isEmpty {
                let alert = UIAlertController(title: "No Location", message: "No Location was entered", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let submitVC = storyboard?.instantiateViewController(identifier: "SubmitLinkViewController") as! SubmitLinkViewController
                submitVC.locationRetrieved = locationinputTextfield.text
                self.navigationController?.pushViewController(submitVC, animated: true)
            }
        }
    }
