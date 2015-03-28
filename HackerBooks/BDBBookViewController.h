//
//  BDBBookViewController.h
//  HackerBooks
//
//  Created by Bruno Domínguez on 26/03/15.
//  Copyright (c) 2015 brunodominguez. All rights reserved.
//

@import UIKit;
@class BDBBook;

//@protocol BDBBookViewControllerDelegate <NSObject>
//
//-(void)bookViewDidChangeFavoriteState:(BDBBook*)book;
//
//@end
@class BDBBook;

@interface BDBBookViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bookImg;
@property (weak, nonatomic) IBOutlet UILabel *authorsLabel;
@property (strong, nonatomic)BDBBook *book;
@property (strong, nonatomic)NSArray *books;
//@property (weak, nonatomic)id<BDBBookViewControllerDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIButton *buttonFav;


-(id)initWithModel:(BDBBook*)aBook books:(NSArray*)books;

-(IBAction)favorite:(id)sender;

@end
