//
//  BDBLibrary.m
//  HackerBooks
//
//  Created by Bruno Domínguez on 24/03/15.
//  Copyright (c) 2015 brunodominguez. All rights reserved.
//

#import "BDBLibrary.h"
#import "BDBBook.h"

@implementation BDBLibrary

#pragma mark - INITS

-(id)initWithBooks:(NSArray*)aBooks{
    
    if (self = [super init]) {
        _books = aBooks;
    }
    return self;
}

#pragma mark - METHODS

-(NSUInteger)booksCount{
    return self.books.count;
}

-(NSArray*)tags{
    //Tags en orden alfabético SIN REPETIR
    NSMutableArray *tagsLookUp = [[NSMutableArray alloc]init];
    
    for (BDBBook* book in self.books) {
        for (NSString* tag in book.tags) {
            
                if (![tagsLookUp containsObject:tag]) {
                    [tagsLookUp addObject:tag];
            }
        }
    }
    tagsLookUp = [[tagsLookUp sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]mutableCopy];
    [tagsLookUp insertObject:@"Favorites" atIndex:0];
    return tagsLookUp;
}

-(NSUInteger)bookCountForTag:(NSString*)tag{
    //Número de libros para una temática.
    //Si el tag no existe, DEVUELVE CERO.
    
    int n = 0;
    if (![[self tags]containsObject:tag]) {
        return 0;
    }else{
        for (BDBBook* book in self.books) {
                if ([book.tags containsObject:tag]) {
                    n+=1;
                }
        }
        return n;
    }
}

-(NSArray*)booksForTag:(NSString*)tag{
    //Array de libros para una temática
    //Si no hay libros, DEVUELVE NIL.
    
    NSMutableArray *booksForTag = [[NSMutableArray alloc]init];
    

        for (BDBBook* book in self.books) {
            if ([book.tags containsObject:tag]) {
                [booksForTag addObject:book];
            }
        }
        return [booksForTag sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            NSString *first = [(BDBBook*)obj1 title];
            NSString *second = [(BDBBook*)obj2 title];
            return [first localizedCaseInsensitiveCompare:second];
        }];


}

-(BDBBook*)bookForTag:(NSString*) tag atIndex:(NSUInteger)index{
    //Libro en la posición INDEX de aquellos para un TAG
    //Utilizar método anterior
    //Si el INDEX o TAG no existe, DEVUELVE NIL.
    
    return [[self booksForTag:tag]objectAtIndex:index];
}



@end
