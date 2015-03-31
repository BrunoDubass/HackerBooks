//
//  BDBBookViewController.m
//  HackerBooks
//
//  Created by Bruno Domínguez on 26/03/15.
//  Copyright (c) 2015 brunodominguez. All rights reserved.
//

#import "BDBBookViewController.h"
#import "BDBBook.h"
#import "ReaderDocument.h"
#import "ReaderViewController.h"


@interface BDBBookViewController ()

@end

@implementation BDBBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //Actualizamos User Defaults con los Favoritos
    
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    NSMutableArray *favs = [[NSMutableArray alloc]init];
    for (BDBBook* b in self.books) {
        if (b.isFavorite == YES) {
            [favs addObject:b.title];
        }
    }
    [d setObject:favs forKey:@"defaults"];
    
    //Actualizamos título para favorito
    
    if (self.book.isFavorite == YES) {
        self.title = [self.book.title stringByAppendingString:@" (Favorite)"];
    }else{
    self.title = self.book.title;
    }
    
    //Mostramos barra de navigation puesto que si viene de visor PDF está oculta
    
    [self.navigationController.navigationBar setHidden:NO];
    
    //Configuramos botón PDF
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"PDF" style:UIBarButtonItemStylePlain target:self action:@selector(pdfView:)];
    
    //Sincro Modelo Vista
    
    [self syncViewModel];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
        

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id)initWithModel:(BDBBook *)aBook books:(NSArray*)books{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _book = aBook;
        _books = books;
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

-(void)syncViewModel{
    
    self.titleLabel.text = self.book.title;
    self.authorsLabel.text = [[self.book.authors componentsJoinedByString:@", "]capitalizedString];
    self.tagsLabel.text = [[self.book.tags componentsJoinedByString:@", "]capitalizedString];
    self.bookImg.image = self.book.bookImg;
    
    if (self.book.isFavorite) {
        [self.buttonFav setBackgroundImage:[UIImage imageNamed:@"Star1"] forState:UIControlStateNormal];
    }else{
        [self.buttonFav setBackgroundImage:[UIImage imageNamed:@"Star2"] forState:UIControlStateNormal];
    }
    
}

//Botón Favorito

-(IBAction)favorite:(id)sender{
    
    //Si no es favorito, lo hacemos favorito y al revés, y lo añadimos o eliminamos del array de tags
    
    if (self.book.isFavorite == NO) {
        NSMutableArray *mutableTags = [[NSMutableArray alloc]initWithArray:self.book.tags];
        [mutableTags addObject:@"Favorites"];
            self.book.isFavorite = YES;
            self.book.tags = mutableTags;
        
            [self.buttonFav setBackgroundImage:[UIImage imageNamed:@"Star1"] forState:UIControlStateNormal];
        
         }else{
             
             NSMutableArray *mutableTags = [[NSMutableArray alloc]initWithArray:self.book.tags];
            self.book.isFavorite = NO;
             for (int i = 0; i<self.book.tags.count; i++) {
                 if ([[mutableTags objectAtIndex:i]isEqualToString:@"Favorites"]) {
                     [mutableTags removeObjectAtIndex:i];
                 }
             }
             self.book.tags = mutableTags;
            [self.buttonFav setBackgroundImage:[UIImage imageNamed:@"Star2"] forState:UIControlStateNormal];
         }
    
    //Actualizamos vista
    
    [self viewWillAppear:YES];
}

//Botón PDF

-(void)pdfView:(BDBBook*)book{
    
    NSString *filePath = [self.book.bookPDFURL path];
    
    //Uso de Framework vfrReader. Push a ReaderViewController.
    
    ReaderDocument *readerDoc = [[ReaderDocument alloc]initWithFilePath:filePath password:nil];
    ReaderViewController *readerVC = [[ReaderViewController alloc]initWithReaderDocument:readerDoc];
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController pushViewController:readerVC animated:YES];
    

}


#pragma mark - UISplitViewControllerDelegate

-(void)splitViewController:(UISplitViewController *)svc willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode{
    
    if (displayMode == UISplitViewControllerDisplayModePrimaryHidden) {
        self.navigationItem.leftBarButtonItem = svc.displayModeButtonItem;
    }else{
        self.navigationItem.leftBarButtonItem = nil;
    }
}

#pragma mark - BDBLibraryTableViewControllerDelegate

-(void)libraryTableviewSelectedBook:(BDBBook *)book arrayOfBooks:(NSArray *)books{
    self.book = book;
    self.books = books;
    [self syncViewModel];
}

@end
