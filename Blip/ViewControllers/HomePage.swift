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

class HomePage: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    

    @IBOutlet weak var scrollViewContent: UIView!
    @IBOutlet weak var alphaView: UIView!
    @IBOutlet weak var storeBackground: UIImageView!
    @IBOutlet weak var storeLogo: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var storeBackgroundToTop: NSLayoutConstraint!
    @IBOutlet weak var storeBackgroundHeight: NSLayoutConstraint!
    
    var navAlphaComponent = CGFloat(0)
    var tileImages = [UIImage.init(named: "aubergine"), UIImage.init(named: "milk"), UIImage.init(named: "chips"), UIImage.init(named: "glass"), UIImage.init(named: "grain"), UIImage.init(named: "meat"), UIImage.init(named: "baguette"), UIImage.init(named: "toaster"), UIImage.init(named: "ice-cream"), UIImage.init(named: "pizza")]
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
    let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    let itemsPerRow: CGFloat = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareLogo()
        prepareNavigationBar()
        handleLocations()
        
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize(width: 375, height: 800)
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
        
        if scrollView.frame.size.height > 200{
            let percentageScrolledForAlphas = (scrollView.contentOffset.y/(self.storeBackground.frame.size.height - ((self.navigationController?.navigationBar.frame.size.height)! + (UIApplication.shared.statusBarFrame.height))))
            
            self.storeBackground.alpha = (1 - percentageScrolledForAlphas)
            self.alphaView.alpha = (1 - percentageScrolledForAlphas)
            
            self.navAlphaComponent = CGFloat(percentageScrolledForAlphas)
            
            self.navigationController?.setColorToNavBar(color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1).withAlphaComponent(self.navAlphaComponent))
            
            if (scrollView.contentOffset.y <= 0) {
                
                self.storeBackgroundHeight.constant = (-scrollView.contentOffset.y)
                let translate = CGAffineTransform(translationX: 0, y: scrollView.contentOffset.y/2.0)
                let orgHeight = storeBackgroundHeight.constant
                let scaleFactor = (self.storeBackground.frame.size.height - scrollView.contentOffset.y) / self.storeBackground.frame.size.height
                let translateAndZoom = translate.scaledBy(x: scaleFactor, y: scaleFactor)
                storeBackground.transform = translateAndZoom
                alphaView.transform = translateAndZoom
            }
            else if (scrollView.contentOffset.y > 0){
                
                
                let offset = -scrollView.contentOffset.y
                self.storeBackgroundToTop.constant = offset
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        prepareScrollView()
    }
    
    func prepareScrollView(){
        
        self.scrollView.delegate = self
        var yPosition:CGFloat = self.storeBackground.frame.size.height - 60

        for x in 1 ... 5{
            
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            layout.itemSize = CGSize(width: 120, height: 120)
            
            let myCollectionView:UICollectionView = UICollectionView(frame: CGRect(x: 0, y: yPosition, width: self.view.frame.size.width, height: 190), collectionViewLayout: layout)
            myCollectionView.dataSource = self
            myCollectionView.delegate = self
            myCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CustomCell")
            myCollectionView.backgroundColor = UIColor.white
            myCollectionView.contentSize = CGSize(width: 700, height: 190)
            self.scrollViewContent.addSubview(myCollectionView)
            
            print(myCollectionView)
            yPosition += (210)
        
        }
        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: yPosition)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath as IndexPath)
        myCell.backgroundColor = UIColor.blue
        return myCell
    }

    func prepareNavigationBar(){
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeDeliveryAddress))
        let cartButton = IconButton()
        cartButton.setIcon(icon: .googleMaterialDesign(.shoppingCart), color: UIColor.white, forState: .normal)
        let cartBarButton = UIBarButtonItem(customView: cartButton)
        self.navigationItem.rightBarButtonItem = cartBarButton
        self.navigationController?.setColorToNavBar(color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1).withAlphaComponent(self.navAlphaComponent))
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


