//
//  BDBSimplePDFViewController.m
//  HackerBooks
//
//  Created by Bruno Domínguez on 27/03/15.
//  Copyright (c) 2015 brunodominguez. All rights reserved.
//

#import "BDBSimplePDFViewController.h"
#import "BDBBook.h"

@interface BDBSimplePDFViewController ()

@end

@implementation BDBSimplePDFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.browser.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.book.isFavorite == YES) {
        self.title = [self.book.title stringByAppendingString:@" (Favorite)"];
    }else{
        self.title = self.book.title;
    }

    [self.browser loadData:self.book.bookPDF MIMEType:@"application/pdf" textEncodingName:@"UTF-8" baseURL: self.book.bookPDFURL];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id)initWithModel:(BDBBook*)book{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _book = book;
    }
    return self;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIWebViewDelegate





@end
