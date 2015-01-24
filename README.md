# CoreDataMate

CoreDataMate is a lightweight CoreData assistant. It gives you all of the control of CoreData, but helps you manage it.

[![Version](http://cocoapod-badges.herokuapp.com/v/CoreDataMate/badge.png)](http://cocoadocs.org/docsets/CoreDataMate)
[![Platform](http://cocoapod-badges.herokuapp.com/p/CoreDataMate/badge.png)](http://cocoadocs.org/docsets/CoreDataMate)

## Installation

CoreDataMate is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "CoreDataMate"

## Use
### Setup
Setup your Core Data store in your `UIApplicationDelegate` during your application's launch:
  
    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
        [CDMDataManager setupWithDataModelName:@"ModelName" storeName:@"StoreName" persistenceType:NSSQLiteStoreType];

        // Perform any other necessary setup
    
        return YES;
    }

### Main Queue Work
If you need to perform operations on the main queue, grab the `mainContext` from the `CDMDataManager` and perform your actions. After you are finished, simply persist the `CDMDataManager` instance.

    NSManagedObjectContext *context = [[CDMDataManager sharedManager] mainContext];
    
    // Perform main queue operations
    
    [[CDMDataManager sharedManager] persist:YES];

### Background Queue Work
If you need to perform operations on a background queue, create a temporary `NSManagedObjectContext` in your background queue and set it's parent context to `CDMDataManager`'s `mainContext`. You can then perform your actions. Once you are finished, save your temporary context. After your temporary context is persisted, persist the `CDMDataManager` instance.

    NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [temporaryContext setParentContext:[[CDMDataManager sharedManager] mainContext]];
    
    // Perform background queue operations
    
    // This call writes your changes to CDMDataManager's mainContext
    BOOL successfulSave = [temporaryContext save:&error];
    if ( successfulSave )
    {
      // This call writes your changes to the store
      [[CDMDataManager sharedManager] persist:YES];
    }

Remember: Your data is not fully persisted until the `CDMDataManager` instance is persisted. This persist call is the permanent persist call.

## Author

Todd Grooms, todd.grooms@gmail.com

## License

CoreDataMate is available under the MIT license. See the LICENSE file for more info.

