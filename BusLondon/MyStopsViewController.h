//
//  MyStopsViewController.h
//  BusLondon
//
//  Created by Rubén Albiach on 2/12/14.
//  Copyright (c) 2014 Rubén Albiach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Stop.h"
#import "StopDAO.h"
#import "StopViewCell.h"


@interface MyStopsViewController : UITableViewController <NSFetchedResultsControllerDelegate>{
    
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
