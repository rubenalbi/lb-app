//
//  MyStopsService.h
//  BusLondon
//
//  Created by Ruben Albiach on 09/01/2016.
//  Copyright © 2016 Rubén Albiach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GenericService.h"
#import <CoreData/CoreData.h>

@interface MyStopsService : GenericService<NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void)saveStop:(Stop *)stop;

- (void)deleteStop:(Stop *)stop;

- (NSMutableArray*) getMyStops;

@end
