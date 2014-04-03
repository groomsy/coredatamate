//
//  CDMDataManager.h
//  CoreDataMate
//
//  Created by Todd Grooms on 6/1/13.
//  Copyright (c) 2013 Groomsy Dev. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@interface CDMDataManager : NSObject

+ (void)setupWithDataModelName:(NSString *)dataModelName
                     storeName:(NSString *)storeName
               persistenceType:(NSString *)persistenceType;

+ (instancetype)sharedManager;

- (NSManagedObjectContext *)mainContext;

- (void)persist:(BOOL)wait;

- (NSURL *)applicationDocumentsDirectory;

@end
