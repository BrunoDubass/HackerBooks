//
//  BDBLibraryTableViewController.h
//  HackerBooks
//
//  Created by Bruno Domínguez on 25/03/15.
//  Copyright (c) 2015 brunodominguez. All rights reserved.
//

@import UIKit;
@class BDBLibrary;
#import "BDBBookViewController.h"


@interface BDBLibraryTableViewController : UITableViewController//<BDBBookViewControllerDelegate>

@property (strong, nonatomic)BDBLibrary *model;

-(id)initWithModel:(NSArray*)model style:(UITableViewStyle)style;

@end
