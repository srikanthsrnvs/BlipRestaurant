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
import Firebase

class HomePage: UIViewController {
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableHeaderBackground: UIImageView!
    @IBOutlet weak var storeIcon: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeader: UIView!
    var headerView: UIView!
    var navAlphaComponent = CGFloat(0)
    var dataSource: [String: [Item]] = [:]
    var userAddress: String?
    let locationManager = CLLocationManager()
    let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    let itemsPerRow: CGFloat = 2
    var selectedCellImage: UIImage!
    var selectedCellHeroID: String!
    var headerViewHeight: CGFloat!
    var dbRef:DatabaseReference!
    var ind: Int!
    var cart = Cart.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        ind = 0
        dbRef = Database.database().reference()
        prepareNavigationBar()
        setTableHeaderVariable()
        handleLocations()
        prepareTableView()
        prepareSearch()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toItem"{
            let dest = segue.destination as! ItemViewController
            dest.itemImageVariable = self.selectedCellImage
            dest.heroIdentifier = selectedCellHeroID
        }
    }
    
    func prepareSearch(){
        
        let searchImage = UIImage(icon: .googleMaterialDesign(.search), size: CGSize(width: 35, height: 35)).withRenderingMode(.alwaysTemplate)
        self.searchButton.setImage(searchImage, for: .normal)
        self.searchButton.ApplyCornerRadiusToView()
    }
    
    func setTableHeaderVariable(){
        
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        self.tableView.tableHeaderView?.frame.size.height = 184 + navBarHeight! + statusBarHeight
        self.headerView = self.tableView.tableHeaderView
        self.tableView.tableHeaderView = nil
        self.tableView.addSubview(headerView)
        self.headerViewHeight = headerView.frame.size.height
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func prepareTableView(){

        self.tableHeaderBackground.image = UIImage(named: "C-Loblaws-produce-320x200")
        self.storeIcon.layer.cornerRadius = storeIcon.frame.size.width/2
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        self.tableView.contentInset = UIEdgeInsetsMake(headerView.frame.size.height - (navBarHeight! + statusBarHeight), 0, 0, 0)
        self.tableView.contentOffset = CGPoint(x: 0, y: -headerView.frame.size.height + (navBarHeight! + statusBarHeight))
    }

    func prepareNavigationBar(){
        
        let navigationController = self.navigationController as! RootNavigationController
        navigationController.datasource = self.dataSource
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeDeliveryAddress))
        let cartButton = IconButton()
        cartButton.addTarget(self, action: #selector(goToCart), for: .touchUpInside)
        cartButton.setIcon(icon: .googleMaterialDesign(.shoppingCart), color: UIColor.white, forState: .normal)
        let cartBarButton = UIBarButtonItem(customView: cartButton)
        self.navigationItem.rightBarButtonItem = cartBarButton
        self.navigationController?.setColorToNavBar(color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1).withAlphaComponent(2))
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.setTitleForNavBar(title: "Loading", subtitle: "Tap to change location", gesture: tap)
    }
    

    @objc func goToCart(){
        //perform segue
        self.performSegue(withIdentifier: "goToCartVC", sender: nil)
    }
}

extension HomePage: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        updateHeaderView()
        let topHeight = (self.navigationController?.navigationBar.frame.size.height)! + (UIApplication.shared.statusBarFrame.height)
        let percentageScrolledForAlphas = (self.headerViewHeight + scrollView.contentOffset.y)/(self.headerViewHeight - topHeight)
        self.navAlphaComponent = CGFloat(percentageScrolledForAlphas)
        self.navigationController?.setColorToNavBar(color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1).withAlphaComponent(self.navAlphaComponent))
        self.headerView.alpha = 1 - self.navAlphaComponent
    }
    
    
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//
//        let topHeight = CGFloat(-self.headerViewHeight)
//        if targetContentOffset.pointee.y < 0 && targetContentOffset.pointee.y < topHeight/2{
//
//            let path = IndexPath(row: 0, section: 0)
//            tableView.scrollToRow(at: path, at: .top, animated: true)
//        }
//        else if tableView.contentOffset.y < 0 && tableView.contentOffset.y > topHeight/2{
//
//            tableView.setContentOffset(CGPoint(x: 0, y: -((self.navigationController?.navigationBar.frame.size.height)! + (UIApplication.shared.statusBarFrame.height))), animated: true)
//        }
//    }
    
    func updateHeaderView(){
        
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        var headerRect = CGRect(x: 0, y: -headerView.frame.size.height + (navBarHeight! + statusBarHeight), width: tableView.bounds.width, height: headerView.frame.size.height - (navBarHeight! + statusBarHeight))
        if tableView.contentOffset.y < -headerView.frame.size.height + (navBarHeight! + statusBarHeight) {
            
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        headerView.frame = headerRect
    }
}

extension HomePage: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
    
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let categoryArray = Array(dataSource.keys)
        return categoryArray[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CategoryRow
        let categoryArray = Array(dataSource.keys)
        if(ind < categoryArray.count){
            print(categoryArray[ind])
            cell.dataSource = self.dataSource[categoryArray[ind]]!
            ind = ind + 1
        }
        
        
        
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


