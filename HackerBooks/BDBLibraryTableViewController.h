//
//  BDBLibraryTableViewController.h
//  HackerBooks
//
//  Created by Bruno Domínguez on 25/03/15.
//  Copyright (c) 2015 brunodominguez. All rights reserved.
//

@import UIKit;
@class BDBLibrary;
@class BDBBook;

#define NOTIFICATION_DID_SELECT_ROW @"book"
#define KEY @"book"


@protocol BDBLibraryTableViewControllerDelegate <NSObject>

@optional

-(void)libraryTableviewSelectedBook:(BDBBook*)book arrayOfBooks:(NSArray*)books;

@end


@interface BDBLibraryTableViewController : UITableViewController<BDBLibraryTableViewControllerDelegate>

@property (strong, nonatomic)BDBLibrary *model;
@property (weak, nonatomic)id<BDBLibraryTableViewControllerDelegate>delegate;

-(id)initWithModel:(NSArray*)model style:(UITableViewStyle)style;

@end
