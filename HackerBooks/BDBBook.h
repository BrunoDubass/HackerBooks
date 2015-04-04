//
//  BDBBook.h
//  HackerBooks
//
//  Created by Bruno Domínguez on 24/03/15.
//  Copyright (c) 2015 brunodominguez. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface BDBBook : NSObject

#pragma mark - PROPERTIES

@property (copy, nonatomic)NSString *title;
@property (strong, nonatomic)NSArray *authors;
@property (strong, nonatomic)NSArray *tags;
@property (strong, nonatomic)UIImage *bookImg;
@property (strong, nonatomic)NSData *bookPDF;
@property (strong, nonatomic)NSURL *bookImgURL;
@property (strong, nonatomic)NSURL *bookPDFURL;
@property (nonatomic)BOOL isFavorite;
@property (nonatomic)BOOL isDefault;

#pragma mark - INITS

//Designate
-(id)initWithTitle:(NSString*)aTitle
           authors:(NSArray*)aAuthors
              tags:(NSArray*)aTags
           bookImg:(UIImage*)aBookImg
        bookPDFURL:(NSURL*)bookPDFURL
           bookPDF:(NSData*)aBookPDF
        bookImgURL:(NSURL*)aBookImgURL;
@end
