//
//  BDBBook.m
//  HackerBooks
//
//  Created by Bruno Domínguez on 24/03/15.
//  Copyright (c) 2015 brunodominguez. All rights reserved.
//

#import "BDBBook.h"

@implementation BDBBook

#pragma mark - INITS

-(id)initWithTitle:(NSString*)aTitle
           authors:(NSArray*)aAuthors
              tags:(NSArray*)aTags
           bookImg:(UIImage*)aBookImg
        bookPDFURL:(NSURL*)bookPDFURL
           bookPDF:(NSData*)aBookPDF
        bookImgURL:(NSURL*)aBookImgURL{
    
    if (self = [super init]) {
        _title = aTitle;
        _authors = aAuthors;
        _tags = [self removeWhitespaceFromArray:aTags];
        _bookImg = aBookImg;
        _bookPDFURL = bookPDFURL;
        _bookPDF = aBookPDF;
        _bookImgURL = aBookImgURL;
    }
    return self;
}

-(NSArray*)removeWhitespaceFromArray:(NSArray*)tgs{
    
    NSMutableArray *m = [[NSMutableArray alloc]initWithCapacity:tgs.count];
    for (NSString* obj in tgs) {
        
        [m addObject:[obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    }
    return m;
}


@end
