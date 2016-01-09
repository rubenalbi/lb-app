//
//  MyStopsService.m
//  BusLondon
//
//  Created by Ruben Albiach on 09/01/2016.
//  Copyright © 2016 Rubén Albiach. All rights reserved.
//

#import "MyStopsService.h"

@implementation MyStopsService

@synthesize managedObjectContext;

- (id)init {
    self = [super init];
    if (self) {
        
        // CORE DATA
        id delegate = [[UIApplication sharedApplication] delegate];
        self.managedObjectContext = [delegate managedObjectContext];

    }
    
    return self;
}

- (void)saveStop:(Stop *)stop{
    StopDAO *stopDAO = [NSEntityDescription
                        insertNewObjectForEntityForName:@"Stop"
                        inManagedObjectContext:[self managedObjectContext]];
    stopDAO.stopPointName = stop.stopPointName;
    stopDAO.stopID = stop.stopID;
    stopDAO.stopPointType = stop.stopPointType;
    stopDAO.towards = stop.towards;
    stopDAO.bearing = [NSString stringWithFormat:@"%@", stop.bearing];
    stopDAO.stopPointIndicator = stop.stopPointIndicator;
    stopDAO.latitude = [NSString stringWithFormat:@"%@", stop.latitude];
    stopDAO.longitude = [NSString stringWithFormat:@"%@", stop.longitude];
    stopDAO.busNumbers = stop.busNumbers;
    stopDAO.distance = stop.distance;
    
    NSError *error;
    if (![[self managedObjectContext] save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

- (void)deleteStop:(Stop *)stop{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription
                           entityForName:@"Stop" inManagedObjectContext:managedObjectContext];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"stopID == %@", stop.stopID];
    NSError *error;
    NSMutableArray *myStopsToDelete = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    for (NSManagedObject *managedObject in myStopsToDelete) {
        [managedObjectContext deleteObject:managedObject];
    }
    if (![managedObjectContext save:&error])
    {
        NSLog(@"Error deleting stop, %@", [error userInfo]);
    }
}

- (NSMutableArray*) getMyStops{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Stop" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    return [[managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
}


#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

@end
