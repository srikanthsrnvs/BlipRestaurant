//
//  ShopScreenVC.swift
//  Blip
//
//  Created by Srikanth Srinivas on 3/1/18.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import UIKit
import Firebase
import Lottie
import Material
import CoreLocation
import PopupDialog
import GooglePlaces
import SwiftIcons
import Hero

class ShopScreenVC: UIViewController, CLLocationManagerDelegate, GMSAutocompleteViewControllerDelegate, UIScrollViewDelegate{

    @IBOutlet weak var collectionView: UICollectionView!
    
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
        prepareToolbar()
        handleLocations()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
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
            //stop updating location to save battery life
            self.userAddress = "\(placemark.postalCode!)"
            toolbarController?.toolbar.title = "\(self.userAddress!)"
        }
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        for component in place.addressComponents!{
            if component.type == "postal_code"{
                userAddress = "\(component.name)"
                toolbarController?.toolbar.title = "\(self.userAddress!)"
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

extension ShopScreenVC {
    
    fileprivate func prepareToolbar() {
        guard let toolbar = toolbarController?.toolbar else {
            return
        }
        toolbar.titleLabel.font = UIFont(name: "CenturyGothicBold", size: 20)
        toolbar.title = "Getting location.."
        toolbar.titleLabel.textColor = .white
        toolbar.titleLabel.textAlignment = .center
        toolbar.titleLabel.isUserInteractionEnabled = true
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeDeliveryAddress))
        toolbar.detail = "Tap to change delivery address"
        toolbar.detailLabel.textColor = .white
        toolbar.detailLabel.textAlignment = .center
        toolbar.detailLabel.isUserInteractionEnabled = true
        toolbar.detailLabel.addGestureRecognizer(tap)
        toolbar.titleLabel.addGestureRecognizer(tap)
    }
}

extension ShopScreenVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tileImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CustomCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CustomCollectionViewCell
        cell.cellImage.hero.id = self.tileStrings[indexPath.row]
        cell.cellLabel.hero.id = "\(tileStrings[indexPath.row])Category"
        cell.cellPrice.hero.id = "\(tileStrings[indexPath.row])Price"
        cell.addToCartButton.hero.id = "\(tileStrings[indexPath.row])Button"
        cell.addToCartButton.hero.modifiers = [.arc]
        cell.cellLabel.text = self.tileStrings[indexPath.row]
        cell.cellLabel.font = UIFont(name: "CenturyGothicBold", size: 13)
        cell.cellImage.image = self.tileImages[indexPath.row]
        cell.prepareBorder()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CustomCollectionViewCell
        print(cell.cellImage.hero.id)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (self.view.frame.size.width / 2) - 30, height: (self.collectionView.frame.size.height - 20))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
}



