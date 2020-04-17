//
//  LoginViewController.swift
//  On the Map
//
//  Created by Makaveli Ohaya on 4/13/20.
//  Copyright © 2020 Ohaya. All rights reserved.
//
import Foundation
import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {
@IBOutlet weak var myView: UIView!
    
    
     @IBOutlet weak var loginButton: UIButton!{ didSet{
             loginButton.layer.cornerRadius = 50
             loginButton.clipsToBounds = true
         }
     }

    @IBOutlet weak var signUPButton: UIButton!{ didSet{
            signUPButton.layer.cornerRadius = 50
             signUPButton.clipsToBounds = true
        }
    }
    @IBOutlet weak var emailTextField: UITextField!{ didSet{
            emailTextField.layer.cornerRadius = 30
            emailTextField.clipsToBounds = true
            emailTextField.tag = 1
                   emailTextField.becomeFirstResponder()
                   emailTextField.delegate = self
        }
    }
        @IBOutlet weak var passwordTextField: UITextField!{ didSet{
                passwordTextField.layer.cornerRadius = 30
                passwordTextField.clipsToBounds = true
            passwordTextField.tag = 2
            passwordTextField.becomeFirstResponder()
            passwordTextField.delegate = self
            }
        }
        
        @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
        var selectedTextField: UITextField?
        override func viewDidLoad() {
            super.viewDidLoad()
           myView.setGradientBackground(colorOne: Colors.white, colorTwo: Colors.brightOrange)
        }


        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            self.tabBarController?.tabBar.isHidden = true
            activityIndicator.isHidden = true
            passwordTextField.isSecureTextEntry = true
            subscribeToKeyboardNotifications()
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            unsubscribeFromKeyBoardNotifications()
        }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            
            textField.resignFirstResponder()
            return true
        }
        @IBAction func loginTapped(_ sender: Any) {
            fieldsChecker()
            UdacityClient.login(self.emailTextField.text!, self.passwordTextField.text!) { (successful, error) in
                
                if error != nil {
                    DispatchQueue.main.async {
                        let errorLoginAlert = UIAlertController(title: "Network Error", message: "Could not connect to the network", preferredStyle: .alert)
                        errorLoginAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(errorLoginAlert, animated: true, completion: nil)
                        self.setLoggingIn(false)
                    }
                }
                
                if successful {
                    print("success")
                    DispatchQueue.main.async {
                        let mapVC = self.storyboard?.instantiateViewController(identifier: "TabBarController") as! UITabBarController
                        self.navigationController?.pushViewController(mapVC, animated: true)
                        self.setLoggingIn(false)
                    }
                } else {
                    DispatchQueue.main.async {
                        let invalidLogin = UIAlertController(title: "Invalid Access", message: "Invalid Email or Password", preferredStyle: .alert)
                        invalidLogin.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
                            return
                        }))
                        self.present(invalidLogin, animated: true, completion: nil)
                        self.setLoggingIn(false)
                    }
                }
            }
        }
        
        @IBAction func signUpTapped(_ sender: Any) {
            let url = UdacityClient.Endpoints.signUp.url
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
                      if text == emailTextField {
                          self.view.frame.origin.y = -getKeyboardHeight(notification: notification as NSNotification)
           }
            else if text == passwordTextField {
            self.view.frame.origin.y = -getKeyboardHeight(notification: notification as NSNotification)
       }
       }
    }
             @objc func keyboardWillHide(_ notification:Notification) {
               if selectedTextField != nil {
                  if  emailTextField.isEditing, view.frame.origin.y != 0 {
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
        
        private func fieldsChecker(){
            if (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)!  {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Credentials were not filled in", message: "Please fill both email and password", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                DispatchQueue.main.async {
                    self.setLoggingIn(true)
                }
            }
        }
        
        func setLoggingIn(_ loggingIn: Bool) { //function handles all of the UI Elements states
            if loggingIn {
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
                print("loggin in")
            } else {
                activityIndicator.stopAnimating()
                activityIndicator.isHidden = true
            }
            emailTextField.isEnabled = !loggingIn
            passwordTextField.isEnabled = !loggingIn
            loginButton.isEnabled = !loggingIn
            
        }
    }
