import Foundation
import MapKit
import SwiftUI


class LocationsViewModel: ObservableObject {
    
    // All loaded locations
    @Published var locations: [Location]
    
    // current location on map
    @Published var mapLocation: Location{
        didSet{
            updateMapRegion(location: mapLocation)
        }
    }
    
    // current region on map
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    
    // show list of locations
    @Published var showLocations: Bool = false
    
    // show location details via sheet
    @Published var sheetLocation: Location?
    
    init() {
        let locations = LocationsDataService.locations
        self.locations = locations
        self.mapLocation = locations.first!
        self.updateMapRegion(location: locations.first!)
    }
    
    
    func updateMapRegion(location: Location) {
        withAnimation(.easeInOut){
            mapRegion = MKCoordinateRegion(
                center: location.coordinates,
                span: mapSpan
            )
        }
    }
    
    func toggleLocationList(){
        withAnimation(.easeInOut){
            showLocations.toggle()
        }
    }
    
    func showNextLocation(location: Location){
        withAnimation(.easeInOut){
            mapLocation = location
            showLocations = false
        }
    }
    
    func nextButtonPressed(){
        // get the current index
        guard let currentIndex = locations.firstIndex(where: {$0 == mapLocation}) else {
            print("Could not find current index in locations array")
            return
        }
        // check if the current index is valid
        let nextIndex = currentIndex + 1
        guard locations.indices.contains(nextIndex) else {
            // current index is NOT valid
            // Restart from 0
            guard let firstLocation = locations.first else {return}
            showNextLocation(location: firstLocation)
            return
        }
        // Next index is valid
        let nextLocation = locations[nextIndex]
        showNextLocation(location: nextLocation)
    }
}
