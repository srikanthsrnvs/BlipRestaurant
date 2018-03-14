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
import ParallaxHeader

class HomePage: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableHeaderBackground: UIImageView!
    @IBOutlet weak var storeIcon: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeader: UIView!
    private let tableHeaderHeight: CGFloat = 250.0
    var headerView: UIView!
    
    var navAlphaComponent = CGFloat(0)
    var tileImages = [UIImage.init(named: "aubergine"), UIImage.init(named: "milk"), UIImage.init(named: "chips"), UIImage.init(named: "glass"), UIImage.init(named: "grain"), UIImage.init(named: "meat"), UIImage.init(named: "baguette"), UIImage.init(named: "toaster"), UIImage.init(named: "ice-cream"), UIImage.init(named: "pizza")]
    fileprivate var tileStrings = [
        "Produce",
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
    let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    let itemsPerRow: CGFloat = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableHeaderVariable()
        prepareNavigationBar()
        handleLocations()
        prepareTableView()
        prepareSearch()
        // Do any additional setup after loading the view.
    }
    
    func prepareSearch(){
        
        let searchImage = UIImage(icon: .googleMaterialDesign(.search), size: CGSize(width: 35, height: 35)).withRenderingMode(.alwaysTemplate)
        searchImage.tint(with: UIColor.white)
        self.searchButton.setImage(searchImage, for: .normal)
    }
    
    func setTableHeaderVariable(){
        
        self.headerView = self.tableView.tableHeaderView
        self.tableView.tableHeaderView = nil
        self.tableView.addSubview(headerView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        updateHeaderView()
        let topHeight = (self.navigationController?.navigationBar.frame.size.height)! + (UIApplication.shared.statusBarFrame.height)
        
        let percentageScrolledForAlphas = (250 + scrollView.contentOffset.y)/(250 - topHeight)
        self.navAlphaComponent = CGFloat(percentageScrolledForAlphas)
        print(navAlphaComponent)
        self.navigationController?.setColorToNavBar(color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1).withAlphaComponent(self.navAlphaComponent))
        self.tableHeader.alpha = 1 - self.navAlphaComponent
    }
    
    func updateHeaderView(){
        
        var headerRect = CGRect(x: 0, y: -tableHeaderHeight, width: tableView.bounds.width, height: tableHeaderHeight)
        
        if tableView.contentOffset.y < -tableHeaderHeight {
            
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        headerView.frame = headerRect
    }

    
    func prepareTableView(){

        self.tableHeaderBackground.image = UIImage(named: "C-Loblaws-produce-320x200")
        self.storeIcon.layer.cornerRadius = storeIcon.frame.size.width/2
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        self.tableView.contentInset = UIEdgeInsetsMake(250 - (navBarHeight! + statusBarHeight), 0, 0, 0)
        self.tableView.contentOffset = CGPoint(x: 0, y: -tableHeaderHeight)
    }

    func prepareNavigationBar(){
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeDeliveryAddress))
        let cartButton = IconButton()
        cartButton.setIcon(icon: .googleMaterialDesign(.shoppingCart), color: UIColor.white, forState: .normal)
        let cartBarButton = UIBarButtonItem(customView: cartButton)
        self.navigationItem.rightBarButtonItem = cartBarButton
        self.navigationController?.setColorToNavBar(color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1).withAlphaComponent(2))
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.setTitleForNavBar(title: "Loading", subtitle: "Tap to change location", gesture: tap)
    }
}

extension HomePage: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
    
        return tileStrings.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return tileStrings[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 185
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CategoryRow
        return cell
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


