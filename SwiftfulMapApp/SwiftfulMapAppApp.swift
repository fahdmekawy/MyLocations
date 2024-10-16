import SwiftUI

@main
struct SwiftfulMapAppApp: App {
    @StateObject private var vm = LocationsViewModel()

    var body: some Scene {
        WindowGroup {
            LocationsView().environmentObject(vm)
        }
    }
}
