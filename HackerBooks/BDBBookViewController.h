//
//  BDBBookViewController.h
//  HackerBooks
//
//  Created by Bruno Domínguez on 26/03/15.
//  Copyright (c) 2015 brunodominguez. All rights reserved.
//

@import UIKit;
@class BDBBook;
#import "BDBLibraryTableViewController.h"

#define NOTIFICATION_DID_CHANGE_ISFAVORITE @"isFavorite"

@interface BDBBookViewController : UIViewController<BDBLibraryTableViewControllerDelegate ,UISplitViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bookImg;
@property (weak, nonatomic) IBOutlet UILabel *authorsLabel;
@property (strong, nonatomic)BDBBook *book;
@property (strong, nonatomic)NSArray *books;


@property (weak, nonatomic) IBOutlet UIButton *buttonFav;


-(id)initWithModel:(BDBBook*)aBook books:(NSArray*)books;

-(IBAction)favorite:(id)sender;

@end
