//
//  HomePage.swift
//  Blip
//
//  Created by Srikanth Srinivas on 3/4/18.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import UIKit
import Material
import Hero
import GooglePlaces
import PopupDialog
import SwiftIcons

class HomePage: UIViewController, UIScrollViewDelegate {


    @IBOutlet weak var alphaView: UIView!
    @IBOutlet weak var storeBackground: UIImageView!
    @IBOutlet weak var storeLogo: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var storeBackgroundToTop: NSLayoutConstraint!
    
    fileprivate var tileImages = [UIImage.init(named: "aubergine"), UIImage.init(named: "milk"), UIImage.init(named: "chips"), UIImage.init(named: "glass"), UIImage.init(named: "grain"), UIImage.init(named: "meat"), UIImage.init(named: "baguette"), UIImage.init(named: "toaster"), UIImage.init(named: "ice-cream"), UIImage.init(named: "pizza")]
    fileprivate var tileStrings = [
        "produce",
        "Dairy",
        "Chips & Snacks",
        "Beverages",
        "Spices & Pantry",
        "Meat & Fish",
        "Bakery & Deli",
        "Cereals & Breakfast",
        "Frozen foods",
        "Microwave meals",
        "Grains & Bulk",
        "Household goods"]
    var userAddress: String?
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareLogo()
        prepareNavigationBar()
        handleLocations()
        // Do any additional setup after loading the view.
    }
    
    func prepareLogo(){
        
        self.storeLogo.layer.cornerRadius = self.storeLogo.frame.size.width/2
        self.storeLogo.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // THIS IS FOR ANIMATION
    }
    
    func prepareScrollView(){
        
        // DO THIS TO LOAD THE SCROLLVIEW WITH 10 TILES, 2 IN EACH ROW
    }
    
    func prepareNavigationBar(){
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeDeliveryAddress))
        let cartButton = IconButton()
        cartButton.setIcon(icon: .googleMaterialDesign(.shoppingCart), color: UIColor.white, forState: .normal)
        let cartBarButton = UIBarButtonItem(customView: cartButton)
        self.navigationItem.rightBarButtonItem = cartBarButton
        self.navigationController?.setColorToNavBar(color: UIColor.clear)
        self.setTitleForNavBar(title: "Loading", subtitle: "Tap to change location", gesture: tap)
    }
}

extension HomePage: CLLocationManagerDelegate, GMSAutocompleteViewControllerDelegate{
    
    
    func handleLocations(){
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        CLGeocoder().reverseGeocodeLocation(manager.location!) { (placemarks, error) in
            if (error != nil){
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            if (placemarks?.count)! >= 0 {
                self.locationManager.stopUpdatingLocation()
                let pm = placemarks![0] as CLPlacemark
                self.displayLocationInfo(placemark: pm)
            }
            else {
                print("Problem with geocoder data")
            }
        }
    }
    
    func displayLocationInfo(placemark: CLPlacemark) {
        if placemark != nil {
            let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeDeliveryAddress))
            //stop updating location to save battery life
            self.userAddress = "\(placemark.postalCode!)"
            self.setTitleForNavBar(title: "Delivering to \(userAddress!)", subtitle: "Tap to change location", gesture: tap)
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        for component in place.addressComponents!{
            if component.type == "postal_code"{
                userAddress = "\(component.name)"
                let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeDeliveryAddress))
                self.setTitleForNavBar(title: "Delivering to \(userAddress!)", subtitle: "Tap to change location", gesture: tap)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print(error)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        let errorPopup = PopupDialog(title: "Error", message: "Could not retrive your location. Please enter a delivery location manually, alternatively turn on location services within settings")
        self.present(errorPopup, animated: true, completion: nil)
    }
    
    @objc func changeDeliveryAddress(){
        
        let placePickerController = GMSAutocompleteViewController()
        placePickerController.delegate = self
        present(placePickerController, animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}


