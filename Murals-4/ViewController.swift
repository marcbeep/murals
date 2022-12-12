//
//  ViewController.swift
//  Murals-4
//
//  Created by Marc Beepath on 12/12/2022.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate {
    
    //MAP
    
    @IBOutlet weak var myMap: MKMapView!
    
    var locationManager = CLLocationManager()
        var firstRun = true
        var startTrackingTheUser = false
         
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationOfUser = locations[0] //this method returns an array of locations
        //generally we always want the first one (usually there's only 1 anyway)
        let latitude = locationOfUser.coordinate.latitude
        let longitude = locationOfUser.coordinate.longitude
        //get the users location (latitude & longitude)
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        if firstRun {
            firstRun = false
            let latDelta: CLLocationDegrees = 0.0025
            let lonDelta: CLLocationDegrees = 0.0025
            //a span defines how large an area is depicted on the map.
            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
            
            //a region defines a centre and a size of area covered.
            let region = MKCoordinateRegion(center: location, span: span)
            
            //make the map show that region we just defined.
            self.myMap.setRegion(region, animated: true)
            
            //the following code is to prevent a bug which affects the zooming of the map to the user's location.
            //We have to leave a little time after our initial setting of the map's location and span,
            //before we can start centering on the user's location, otherwise the map never zooms in because the
            //intial zoom level and span are applied to the setCenter( ) method call, rather than our "requested" ones,
            //once they have taken effect on the map.
            
            //we setup a timer to set our boolean to true in 5 seconds.
            _ = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector:
                                        #selector(startUserTracking), userInfo: nil, repeats: false)
        }
        
        
        
        if startTrackingTheUser == true {
            myMap.setCenter(location, animated: true)
        }
        
        // User's current location
        _ = CLLocation(latitude: location.latitude, longitude: location.longitude);
        
        /*
        let sortedList = murals?.newbrighton_murals.sorted{         userCurrentLocation.distance(from: CLLocation(latitude: $0.lat, longitude: $0.long))
            < userCurrentLocation.distance(from: CLLocation(latitude: $1.lat, longitude: $1.long)) }
         */
        
        let sortedList = murals?.newbrighton_murals.sorted{$0.title < $1.title}
        murals?.newbrighton_murals = sortedList ?? []
        updateTheTable()

    }
        
        //this method sets the startTrackingTheUser boolean class property to true. Once it's true,
       //subsequent calls to didUpdateLocations will cause the map to centre on the user's location.
        @objc func startUserTracking() {
            startTrackingTheUser = true
        }
    
    //TABLE
    
    var murals:muralList? = nil
    var info = ""
    
    
    func updateTheTable() {
                theTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return murals?.newbrighton_murals.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
            var content = UIListContentConfiguration.subtitleCell()
            content.text = murals?.newbrighton_murals[indexPath.row].title ?? "Title Unavailable"
            content.secondaryText = murals?.newbrighton_murals[indexPath.row].artist ?? "Artist Unavailable"
            cell.contentConfiguration = content
        
            return cell
    }
    
    @IBOutlet weak var theTable: UITableView!
    
    override func viewDidLoad() {
      super.viewDidLoad()
        
        //Code from Phil Jimmieson
        // Make this view controller a delegate of the Location Manager, so that it
        //is able to call functions provided in this view controller.
        locationManager.delegate = self as CLLocationManagerDelegate
         
        //set the level of accuracy for the user's location.
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
         
        //Ask the location manager to request authorisation from the user. Note that this
        //only happens once if the user selects the "when in use" option. If the user
        //denies access, then your app will not be provided with details of the user's
        //location.
        locationManager.requestWhenInUseAuthorization()
         
        //Once the user's location is being provided then ask for updates when the user
        //moves around.
        locationManager.startUpdatingLocation()
         
        //configure the map to show the user's location (with a blue dot).
        myMap.showsUserLocation = true
                     
        //Own Code
      if let url = URL(string: "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/nbm/data2.php?class=newbrighton_murals") {
          let session = URLSession.shared
            session.dataTask(with: url) { (data, response, err) in
              guard let jsonData = data else {
                  return
              }
              do {
                  let decoder = JSONDecoder()
                  let reportList = try decoder.decode(muralList.self, from: jsonData)
                  self.murals = reportList
                  DispatchQueue.main.async {
                      self.updateTheTable()
                  }
              } catch let jsonErr {
                  print("Error decoding JSON", jsonErr)
              }
          }.resume()
       }
        
        createAnnotation(locations: annotationLocations)
    }
        
    let annotationLocations = [
        ["title" : "I See The Sea", "latitude": 53.43881250167621, "longitude": -3.0416222190640183]
    ]
    
    func createAnnotation(locations:[[String:Any]]){
        for location in locations {
            let annotations = MKPointAnnotation()
            annotations.title = location["title"] as? String
            annotations.coordinate = CLLocationCoordinate2D(latitude: location["latitude"] as! CLLocationDegrees, longitude: location["longitude"] as! CLLocationDegrees)
            
            myMap.addAnnotation(annotations)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail"{
            let viewController = segue.destination as! InfoViewController
            
            if let indexPath = self.theTable.indexPathForSelectedRow {
                viewController.url = "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/nbm_images/" + (murals?.newbrighton_murals[indexPath.row].images[0].filename ?? "")
                viewController.info = murals?.newbrighton_murals[indexPath.row].info ?? "Info Unavailable"
            }
        }
    }

}

