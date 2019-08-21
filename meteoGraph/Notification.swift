import AppKit


extension Notification.Name {
    
    static let updateTown   = Notification.Name( "updateTown")
    static let addCity      = Notification.Name( "addCity")
    static let preferencesChanged = Notification.Name("preferencesChanged")
}

extension NotificationCenter {
    
    // Send(Post) Notification
    static func send(_ key: Notification.Name) {
        self.default.post(
            name: key,
            object: nil
        )
    }
    
    // Receive(addObserver) Notification
    static func receive(instance: Any, name: Notification.Name, selector: Selector) {
        self.default.addObserver(
            instance,
            selector: selector,
            name: name,
            object: nil
        )
    }
    
    // Remove(removeObserver) Notification
    static func remove( instance: Any, name: Notification.Name  ) {
        self.default.removeObserver(
            instance,
            name: name,
            object: nil
        )
    }

}
