//
//  DataManager.m
//  CoreDataMate
//
//  Created by Todd Grooms on 6/1/13.
//  Copyright (c) 2013 Groomsy Dev. All rights reserved.
//

#import "DataManager.h"

@interface DataManager ()
{
    NSManagedObjectContext *_mainContext;
    NSManagedObjectContext *_privateContext;
}

@end

@implementation DataManager

static NSString *_dataModelName = nil;
static NSString *_storeName = nil;
static NSString *_persistenceType = nil;

+ (void)setupWithDataModelName:(NSString *)dataModelName storeName:(NSString *)storeName persistenceType:(NSString *)persistenceType
{
    _dataModelName = dataModelName;
    _storeName = storeName;
    _persistenceType = persistenceType;
}

+ (instancetype)sharedManager
{
    __strong static id instance = nil;

    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{

        instance = [[[self class] alloc] initPrivate];
    });

    return instance;
}

- (id)init
{
    [NSException raise:NSMallocException format:@"Cannot instantiate DataManager Singleton."];
    return nil;
}

- (id)initPrivate
{
    self = [super init];
    if ( self != nil )
    {
        NSURL *modelURL = [[NSBundle bundleForClass:[self class]] URLForResource:_dataModelName withExtension:@"momd"];
        NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        
        NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
        NSAssert(persistentStoreCoordinator != nil, @"Failed to initialize the persistent store coordinator.");

        NSString *storeName = [NSString stringWithFormat:@"%@.sqlite", _storeName];
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:storeName];

        NSString *storeType = _persistenceType;

        NSDictionary *options = @{
                                  NSMigratePersistentStoresAutomaticallyOption : @YES,
                                  NSInferMappingModelAutomaticallyOption : @YES
                                  };
        
        NSError *error = nil;
        NSPersistentStore *store = [persistentStoreCoordinator addPersistentStoreWithType:storeType
                                                                            configuration:nil
                                                                                      URL:storeURL
                                                                                  options:options
                                                                                    error:&error];
        if ( store == nil )
        {
            DDLogError(@"Failed to add store type: %@\n%@", [error localizedDescription], [error userInfo]);
            [NSException raise:NSInternalInconsistencyException format:@"Store must be set up correctly."];
        }
        
        _privateContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_privateContext setPersistentStoreCoordinator:persistentStoreCoordinator];
        
        _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_mainContext setParentContext:_privateContext];
    }
    return self;
}

- (void)dealloc
{
    [self persist:YES];
    
    [_mainContext setParentContext:nil];
    _mainContext = nil;
    
    [_privateContext setPersistentStoreCoordinator:nil];
    _privateContext = nil;
}

#pragma mark -
#pragma mark Public Accessible Properties
- (NSManagedObjectContext *)mainContext
{
    return _mainContext;
}

#pragma mark -
#pragma mark Save
- (void)persist:(BOOL)wait
{
    if ( _mainContext == nil )
    {
        DDLogWarn(@"No main context found.");
        return;
    }
    
    if ( [_mainContext hasChanges] == YES )
    {
        [_mainContext performBlockAndWait:^{
            
            NSError *error = nil;
            BOOL successful = [_mainContext save:&error];
            if ( successful == NO )
            {
                DDLogError(@"Error saving main context: %@\n%@", [error localizedDescription], [error userInfo]);
            }
        }];
    }
    
    void (^savePrivateContext) (void) = ^{
        
        NSError *error = nil;
        BOOL successful = [_privateContext save:&error];
        if ( successful == NO )
        {
            DDLogError(@"Error saving main context: %@\n%@", [error localizedDescription], [error userInfo]);
        }
    };

    if ( [_privateContext hasChanges] == YES )
    {
        if ( wait == YES )
        {
            [_privateContext performBlockAndWait:savePrivateContext];
        }
        else
        {
            [_privateContext performBlock:savePrivateContext];
        }
    }
}

#pragma mark - Application's Documents directory
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
