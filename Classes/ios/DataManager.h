//
//  DataManager.h
//  CoreDataMate
//
//  Created by Todd Grooms on 6/1/13.
//  Copyright (c) 2013 Groomsy Dev. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@interface DataManager : NSObject

+ (void)setupWithDataModelName:(NSString *)dataModelName
                     storeName:(NSString *)storeName
               persistenceType:(NSString *)persistenceType;

+ (DataManager *)sharedManager;

- (NSManagedObjectContext *)mainContext;

- (void)persist:(BOOL)wait;

- (NSURL *)applicationDocumentsDirectory;

@end
