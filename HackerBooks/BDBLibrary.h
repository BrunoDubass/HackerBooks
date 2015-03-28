//
//  BDBLibrary.h
//  HackerBooks
//
//  Created by Bruno Domínguez on 24/03/15.
//  Copyright (c) 2015 brunodominguez. All rights reserved.
//

@import Foundation;
@class BDBBook;

@interface BDBLibrary : NSObject

#pragma mark - PROPERTIES

@property (strong, nonatomic)NSArray *books;

#pragma mark - INITS

-(id)initWithBooks:(NSArray*)aBooks;

#pragma mark - METHODS


-(NSUInteger)booksCount;
-(NSArray*)tags;
//Tags en orden alfabético SIN REPETIR
-(NSUInteger)bookCountForTag:(NSString*)tag;
//Número de libros para una temática.
//Si el tag no existe, DEVUELVE CERO.
-(NSArray*)booksForTag:(NSString*)tag;
//Array de libros para una temática
//Si no hay libros, DEVUELVE NIL.
-(BDBBook*)bookForTag:(NSString*) tag atIndex:(NSUInteger)index;
//Libro en la posición INDEX de aquellos para un TAG
//Utilizar método anterior
//Si el INDEX o TAG no existe, DEVUELVE NIL.

@end
