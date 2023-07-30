//
//  EditView.swift
//  BucketList
//
//  Created by Hubert Wojtowicz on 31/07/2023.
//

import SwiftUI

struct EditView: View {
    //dismiss sheet
    @Environment(\.dismiss) var dismiss
//    // Exported
//    //location struct
//    var location: Location
    
//    // Exported
//    //property to store name
//    @State private var name: String
//    //property to store description
//    @State private var description: String
    
    // get single location and return nothing
    var onSave: (Location) -> Void
    
//    // Exported
//    //property to represent the loading state
//    @State private var loadingState = LoadingState.loading
//    //property to store array of wikipedia pages
//    @State private var pages = [Page]()
    
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Place name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.description)
                }
                
                //Section depend of loading state
                Section("Nerby...") {
                    switch viewModel.loadingState {
                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ") +
                            Text(page.description)
                                .italic()
                        }
                    case .loading:
                        Text("Loading...")
                    case .failed:
                        Text("Please try again later.")
                    }
                }
            }
            .navigationTitle("Place Details")
            .toolbar {
                Button("Save") {
//                    // Exported
//                    //creating new location, then sending it back with onSave()
//                    var newLocation = location
//                    newLocation.id = UUID()
//                    newLocation.name = name
//                    newLocation.description = description
                    
                    onSave(viewModel.newLocation())
                    dismiss()
                }
            }
            .task { await viewModel.fetchNearbyPlaces()}
        }
    }
    init(location: Location, onSave: @escaping (Location) -> Void) {
//        //Exported
//        self.location = location
        self.onSave = onSave
        
//        // Exported
//        _name = State(initialValue: location.name)
//        _description = State(initialValue: location.description)
        
        _viewModel = StateObject(wrappedValue: ViewModel(location: location))
    }
    
//    // Exported
//    // enum to show view depend on loading state
//    enum LoadingState {
//        case loading, loaded, failed
//    }
    
//    // Exported
//    //Method to fetch data from Wikipedia
//    func fetchNearbyPlaces() async {
//        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.coordinate.latitude)%7C\(location.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
//
//        guard let url = URL(string: urlString) else {
//            print("Bad URL: \(urlString)")
//            return
//        }
//
//        do {
//            let (data, _) = try await URLSession.shared.data(from: url)
//
//            // data we got back
//            let items = try JSONDecoder().decode(Result.self, from: data)
//
//            //when success convert the array values to our pages array
//            pages = items.query.pages.values.sorted()
//            loadingState = .loaded
//
//        } catch {
//            loadingState = .failed
//        }
//    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location.example) { newLocation in }
    }
}
