//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Hubert Wojtowicz on 08/08/2023.
//

import Foundation
import MapKit
import LocalAuthentication

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        // replacing propeties from ContentView here to make project architecture as MVVM
        @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
        // adding private(set) tells that reading this property is ok but only this class can write it
        @Published private(set) var locations: [Location]
        @Published var selectedPlace: Location?
        
        //property to store location that is saving
        let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPlaces")
        
        // property to track if app is unlocked
        @Published var isUnlocked = false
        
        // property to showing alert if authentication is faild
        @Published var authenticationError = false
        // mathod to add location
        func addLocation() {
            let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
            locations.append(newLocation)
            // saving new location after adding it :)
            save()
        }
        
        func update(location: Location) {
            guard let selectedPlace = selectedPlace else { return }
            
            // code from content view 
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
            }
            save()
        }
        
        // intializer to get data from device memory
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        // method that give access to data only if the user has unlocked their device
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Unable to save data.")
            }
        }
        
        // method to handle autentication - it's Objective-C
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            // check if device has biometric authentication
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                // this string is used for TouchID, while message for FaceID is storage in app Info
                let reason = "Please authenticate yourself to unlock your places."
                
                // authentication
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    
                    // possibility of authentication
                    if success {
                        // changing isUnlocked property on the main actor
                        Task { @MainActor in
                            self.isUnlocked = true
                        }
                    } else {
                        Task { @MainActor in 
                            self.authenticationError = true
                        }
                    }
                }
            } else {
                // no biometrics
            }
        }
    }
}
