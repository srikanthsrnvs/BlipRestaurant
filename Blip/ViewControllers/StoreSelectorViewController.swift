//
//  StoreSelectorViewController.swift
//  Blip
//
//  Created by Srikanth Srinivas on 3/25/18.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import UIKit
import Hero
import Kingfisher
import Material
import GooglePlaces
import PopupDialog

class StoreSelectorViewController: UIViewController {

    @IBOutlet weak var storeSelectorTableView: UITableView!
    
    var userAddress: String?
    let locationManager = CLLocationManager()
    var stores = [Store]()
    var i  = 1.0
    var selectedCell: StoreTableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareHeroCascade()
        prepareNavigationBar()
        handleLocations()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareHeroCascade(){
        storeSelectorTableView.hero.isEnabled = true
        self.hero.isEnabled = true
        self.hero.modalAnimationType = .auto
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toStore"{
            let dest = segue.destination as! HomePage
            dest.dataSource = selectedCell.store.catalog
            dest.store = selectedCell.store
        }
    }
    
    func prepareNavigationBar(){
        
        self.navigationController?.setColorToNavBar(color: #colorLiteral(red: 0.4685202837, green: 0.7641497254, blue: 0.2666088939, alpha: 1))
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeDeliveryAddress))
        let cartButton = IconButton()
        cartButton.addTarget(self, action: #selector(goToCart), for: .touchUpInside)
        cartButton.setIcon(icon: .googleMaterialDesign(.shoppingCart), color: UIColor.white, forState: .normal)
        let cartBarButton = UIBarButtonItem(customView: cartButton)
        self.navigationItem.rightBarButtonItem = cartBarButton
        self.setTitleForNavBar(title: "Loading", subtitle: "Tap to change location", gesture: tap)
    }
    
    @objc func goToCart(){
        //perform segue
        self.performSegue(withIdentifier: "goToCartVC", sender: nil)
    }
    
    @objc func changeDeliveryAddress(){
        
        let placePickerController = GMSAutocompleteViewController()
        placePickerController.delegate = self
        present(placePickerController, animated: true, completion: nil)
    }
    
}

extension StoreSelectorViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let storeSelectorCell = tableView.dequeueReusableCell(withIdentifier: "StoreSelectorCell", for: indexPath) as! StoreTableViewCell
        storeSelectorCell.hero.isEnabled = true
        storeSelectorCell.hero.modifiers = [.duration(0.25 * i),.translate(CGPoint.init(x: 200, y: 400))]
        i += 1
        storeSelectorCell.store = stores[indexPath.section]
        storeSelectorCell.storeImage.image = stores[indexPath.section].storeBackground
        storeSelectorCell.storeLogo.image = stores[indexPath.section].storeLogo
        storeSelectorCell.orderAmount.text = "Minimum order: $\(stores[indexPath.section].minOrder!)"
        storeSelectorCell.storeName.text = stores[indexPath.section].name
        storeSelectorCell.storeRating.rating = 4
        return storeSelectorCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return stores.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        for cell in tableView.visibleCells{
            cell.hero.modifiers = []
        }
        let storeSelectorCell = tableView.cellForRow(at: indexPath) as! StoreTableViewCell
        storeSelectorCell.overlay.hero.id = storeSelectorCell.store.name
        storeSelectorCell.storeImage.hero.id = "\(storeSelectorCell.store.storeBackground)"
        storeSelectorCell.storeLogo.hero.id = "\(storeSelectorCell.store.storeLogo)"
        selectedCell = storeSelectorCell
        self.performSegue(withIdentifier: "toStore", sender: self)
    }

}

extension StoreSelectorViewController: CLLocationManagerDelegate, GMSAutocompleteViewControllerDelegate{
    
    
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
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeDeliveryAddress))
        //stop updating location to save battery life
        self.userAddress = "\(placemark.postalCode!)"
        self.setTitleForNavBar(title: "Delivering to \(userAddress!)", subtitle: "Tap to change location", gesture: tap)
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
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
