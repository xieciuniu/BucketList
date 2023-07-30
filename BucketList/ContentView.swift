//
//  ContentView.swift
//  BucketList
//
//  Created by Hubert Wojtowicz on 30/07/2023.
//

import SwiftUI
import MapKit

////Day 69 exercise 1
//import MapKit

//// Day 69 exercise2
//import LocalAuthentication

////Day 68 exercise 3
////enum for different views
//enum LoadingState {
//    case loading, success, failed
//}
//
//// Views for different state
//struct LoadingView: View {
//    var body: some View {
//        Text("Loading...")
//    }
//}
//
//struct SuccessView: View {
//    var body: some View {
//        Text("Success!")
//    }
//}
//
//struct FailedView: View {
//    var body: some View {
//        Text("Failed.")
//    }
//}

////Day 68 exercise 1
//// Struct that conform to comparable and can be sorted
//struct User: Identifiable, Comparable {
//    let id = UUID()
//    let firstName: String
//    let lastName: String
//
//    static func <(lhs: User, rhs: User) -> Bool {
//        lhs.lastName < rhs.lastName
//    }
//}

////Day 69 exercise 1
//struct Location: Identifiable {
//    let id = UUID()
//    let name: String
//    let coordinate: CLLocationCoordinate2D
//}

struct ContentView: View {
//    // Day 68 exercise 1
//    // struct to sort
//    let user = [
//    User(firstName: "Arnold", lastName: "Rimmer"),
//    User(firstName: "Kristine", lastName: "Kochanski"),
//    User(firstName: "David", lastName: "Lister"),
//    ].sorted()
    
//    //Day 68 exercise 3
//    // propety to store current LoadingState value
//    var loadingState = LoadingState.loading

//    //Day 69 exercise 1
//    // property to store current location
//    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5, longitude: -0.12), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
//
//    //example to location on map
//    let locations = [
//        Location(name: "Backingham Palace", coordinate: CLLocationCoordinate2D(latitude: 51.501, longitude: -0.141)),
//        Location(name: "Tower of London", coordinate: CLLocationCoordinate2D(latitude: 51.508, longitude: -0.076))
//    ]
    
//    //Day 69 exercise 2
//    @State private var isUnlocked = false
    
//    // propeties expoerted to ContentView-ViewModel
//    // property to store current state of the map
//    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
//
//    // Array of location user add
//    @State private var locations = [Location]()
//
//    // property to send location to sheet to make new annotation
//    @State private var selectedPlace: Location?
    
    // property replacing these higher
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        //        VStack {
        
        //            //Day 68 exercise 1
        //            ForEach(user){person in
        //                Text("\(person.firstName) \(person.lastName)")
        //            }
        
        //            //Day 68 exercise 2
        //            Text("Hello World")
        //                .onTapGesture {
        //                    let str = "Test Message"
        //                    let url = FileManager.default.urls("message.txt") //.appendingPathComponent("message.txt")
        //
        //                    do {
        //                        try str.write(to: url, atomically: true, encoding: .utf8)
        //                        let input = try String(contentsOf: url)
        //                        print(input)
        //                    } catch {
        //                        print(error.localizedDescription)
        //                    }
        //                }
        
        //    }
        
        //        //Day 68 exercise 3
        //        if loadingState == .loading {
        //            LoadingView()
        //        } else if loadingState == .success {
        //            SuccessView()
        //        } else if loadingState == .failed {
        //            FailedView()
        //        }
        
        //        //Day 69 exercise 1
        //        NavigationView{
        //            Map(coordinateRegion: $mapRegion, annotationItems: locations) { location in
        //                MapAnnotation(coordinate: location.coordinate) {
        //                    NavigationLink {
        //                        Text(location.name)
        //                    } label: {
        //                        Circle()
        //                            .stroke(.red, lineWidth: 3)
        //                            .frame(width: 44, height: 44)
        //                    }
        //                }
        //            }
        //            .navigationTitle("London Explorer")
        //        }
        
        //        //Day 69 exercise 2
        //        VStack {
        //            if isUnlocked {
        //                Text("Unlocked")
        //            } else {
        //                Text("Locked")
        //            }
        //        }
        //        .onAppear(perform: authenticate)
        
        ZStack {
            // showing app only if user is authorized
            if viewModel.isUnlocked {
                // whole map
                Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.locations) { location in
                    MapAnnotation(coordinate: location.coordinate) {
                        //label for map annotation
                        VStack {
                            Image(systemName: "star.circle")
                                .resizable()
                                .foregroundColor(.red)
                                .frame(width:44, height: 44)
                                .background(.white)
                                .clipShape(Circle())
                            
                            Text(location.name)
                                .fixedSize()
                        }
                        // going to sheed by tapping annotation
                        .onTapGesture {
                            viewModel.selectedPlace = location
                        }
                    }
                }
                    .ignoresSafeArea()
                
                // Cirlce on the center point of screen
                Circle()
                    .fill(.blue)
                    .opacity(0.3)
                    .frame(width: 32, height: 32)
                
                //Button in the bottom-right to add place marks to the map
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button{
    //                        // adding location is exported to ViewModel
    //                        // create a new location
    //                        let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: viewModel.mapRegion.center.latitude, longitude: viewModel.mapRegion.center.longitude)
    //                        viewModel.locations.append(newLocation)
                            
                            viewModel.addLocation()
                            
                            // jumping into sheet after creating new location
                            viewModel.selectedPlace = viewModel.locations.last
                            
                        } label: {
                            Image(systemName: "plus")
                                .padding()
                                .background(.black.opacity(0.75))
                                .foregroundColor(.white)
                                .font(.title)
                                .padding(.trailing)
                        }
                    }
                }
            } else {
                // button to authorize user
                Button("Unlock Places") {
                    viewModel.authenticate()
                }
                .padding()
                .background(.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
        }
        .sheet(item: $viewModel.selectedPlace) { place in
            EditView(location: place) { // newLocation in // unused
//                 // another exported part of code
//                if let index = viewModel.locations.firstIndex(of: place) {
//                    viewModel.locations[index] = newLocation
//                }
                viewModel.update(location: $0)
            }
        }
        .alert("Authentication Error", isPresented: $viewModel.authenticationError){
            Button("OK") {}
        } message: {
            Text("Please try again.")
        }
    }
    
//    //Day 69 exercise 2
//    //function to manage authentication
//    func authenticate() {
//        //adding context
//        let context = LAContext()
//        //optional error in obj-c
//        var error: NSError?
//
//        //check wheather biometric authentication is possible
//        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
//            // it's possible, so go ahead and use it
//            let reason = "We need to unlock your data."
//
//            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
//                //authentication has now completed
//                if success {
//                    //authenticated successfully
//                    isUnlocked = true
//                } else {
//                    // there was a problem
//                }
//            }
//        } else {
//            //no biometrics
//        }
//    }
    
//    //Day 68 exercise 2
//    //Function to find url of my app in directory
//    func getDocumentsDirectory() -> URL {
//        // find all possible documents directories for this user
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//
//        //just send back the first one, which ought to be the only one
//        return paths[0]
//    }
}

//// FileManager extension - chalange
//extension FileManager {
//    func urls(_ file: String) -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//
//        return paths[0].appendingPathComponent(file)
//    }
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
