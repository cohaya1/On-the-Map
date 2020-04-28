//
//  SubmitLinkViewController.swift
//  On the Map
//
//  Created by Makaveli Ohaya on 4/15/20.
//  Copyright © 2020 Ohaya. All rights reserved.
//
import MapKit
import UIKit

class SubmitLinkViewController: UIViewController,UITextFieldDelegate {

  
        @IBOutlet weak var urlTextField: UITextField!{ didSet {
           urlTextField.becomeFirstResponder()
             urlTextField.delegate = self
            }
        }
        @IBOutlet weak var SubmitLocationButton: UIButton!
        @IBOutlet weak var mapView: MKMapView!
        var locationRetrieved: String!
        var urlRetrieved: String!
         var selectedTextField: UITextField?
        var location: String = ""
        var coordinate: CLLocationCoordinate2D?
        
        var latitude: Double = 0.0
        var longitude: Double = 0.0
         var objectIdHolder: String = ""
    var student: StudentInformation?
        
        override func viewDidLoad() {
            super.viewDidLoad()
             urlTextField.delegate = self
             urlTextField.attributedPlaceholder = NSAttributedString(string: "Enter A Link To Share", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
            SubmitLocationButton.layer.cornerRadius = 5
            print(locationRetrieved!)
            search()
            self.navigationController?.setNavigationBarHidden(true, animated: true)
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
        
        func search() {
            
            guard let location = locationRetrieved else { //checks if the location was retrieved
                self.errorAlert("No Location", "Location was not found or entered. Go back to the previous view.")
                return
            }
            
            let ai = self.startAnActivityIndicator()
            
            CLGeocoder().geocodeAddressString(location) { (placemark, error) in
                
                ai.stopAnimating()
                
                guard error == nil else {
                    self.errorAlert("No Location", "Location was not found or entered. Go back to the previous view.")
                    return
                }
                
                self.location = location //assign the location to the global location variable so we can access it
                self.coordinate = placemark!.first!.location!.coordinate
                self.pin(coordinate: self.coordinate!)
                self.latitude = (placemark?.first?.location?.coordinate.latitude)!
                self.longitude = (placemark?.first?.location?.coordinate.longitude)!
            }
        }
        
        
        func getUserinfo() {
            UdacityClient.getUser() { (success, error) in
                
                if error != nil {
                    DispatchQueue.main.async {
                        self.errorAlert("Error", "Error Getting User Info")
                    }
                }
                
                if success {
                    print("success")
                    
                    DispatchQueue.main.async {
                        self.student = StudentInformation(uniqueKey: UdacityClient.accountKey, firstName: UdacityClient.firstName, lastName: UdacityClient.lastName, latitude: self.latitude, longitude: self.longitude, mapString: self.location, mediaURL: self.urlRetrieved)
                        print(self.student?.firstName ?? "No First Name")
                        print(self.student?.lastName ?? "No First Name")
                        print(self.student?.latitude ?? 0)
                        print(self.student?.longitude ?? 0)
                        print(self.student?.mapString ?? "No Location")
                        print(self.student?.mediaURL ?? "No URL")
                        print(self.student?.uniqueKey ?? "No Key")
                        
                        
                        //insert update
                        if UdacityClient.objectId == "" {
                            self.postLocation()
                        } else {
                            self.updateLocation()
                        }
                    }
                    
                } else {
                    DispatchQueue.main.async {
                         self.errorAlert("Error", "Error Getting User Info")
                    }
                }
            }
        }
        
        func updateLocation() {
            UdacityClient.updateUserLocation(student: student!) { (success, error) in
                if error != nil {
                    print(error?.localizedDescription ?? "")
                    self.errorAlert("Could not update student Location", "There was an error trying to update a pin")
                    return
                }
                
                
                if success {
                    print("update success")
                    print("New Latitude: \(self.student?.latitude ?? 0)")
                    print("New Longitude: \(self.student?.longitude ?? 0)")
                    DispatchQueue.main.async {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                 } else {
                                   self.errorAlert("Could not update student Location", "There was an error trying to update a pin")
                               }
            }
        }
        
        func postLocation() {
            UdacityClient.postStudentLocation(student: student!) { (success, error) in
                
                if error != nil {
                    print(error?.localizedDescription ?? "")
                    self.errorAlert("Could not post student location", "There was an error trying to post a pin")
                    return
                }
                
                if success {
                    print("post success")
                    print(self.student?.firstName ?? "")
                    print(self.student?.lastName ?? "")
                    print(self.student?.latitude ?? 0)
                    print(self.student?.longitude ?? 0)
                    DispatchQueue.main.async {
                        let vc = self.navigationController?.viewControllers[1]
                        self.navigationController?.popToViewController(vc!, animated: true)
                    }
                } else {
                    self.errorAlert("Could not post student location", "There was an error trying to post a pin")
                }
            }
        }
        
    
        
        func pin(coordinate: CLLocationCoordinate2D) {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = location
            
            let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            DispatchQueue.main.async {
                self.mapView.addAnnotation(annotation)
                self.mapView.setRegion(region, animated: true)
                self.mapView.regionThatFits(region)
            }
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
                      if text == urlTextField {
                          self.view.frame.origin.y = -getKeyboardHeight(notification: notification as NSNotification)
           }
           
       }
    }
             @objc func keyboardWillHide(_ notification:Notification) {
               if selectedTextField != nil {
                  if urlTextField.isEditing, view.frame.origin.y != 0 {
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
        
        @IBAction func cancelButtonTapped(_ sender: Any) {
            self.navigationController?.popViewController(animated: true)
        }
        
        @IBAction func submitTapped(_ sender: Any) {
            urlRetrieved = urlTextField.text
            getUserinfo()
        }
    func errorAlert(_ title: String?, _ message: String?) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let actionOK = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(actionOK)
            self.present(alert, animated: true, completion: nil)
        }
}
    extension SubmitLinkViewController {
        func startAnActivityIndicator() -> UIActivityIndicatorView {
            let ai = UIActivityIndicatorView(style: .large)
            self.view.addSubview(ai)
            self.view.bringSubviewToFront(ai)
            ai.center = self.view.center
            ai.hidesWhenStopped = true
            ai.startAnimating()
            return ai
        }
    }
    
    
