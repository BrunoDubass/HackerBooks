//
//  BDBSimplePDFViewController.h
//  HackerBooks
//
//  Created by Bruno Domínguez on 27/03/15.
//  Copyright (c) 2015 brunodominguez. All rights reserved.
//

@import UIKit;
@class BDBBook;

@interface BDBSimplePDFViewController : UIViewController<UIWebViewDelegate>

@property (strong, nonatomic)BDBBook *book;
@property (weak, nonatomic) IBOutlet UIWebView *browser;

-(id)initWithModel:(BDBBook*)book;

@end
