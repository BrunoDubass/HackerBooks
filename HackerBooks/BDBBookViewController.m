//
//  BDBBookViewController.m
//  HackerBooks
//
//  Created by Bruno Domínguez on 26/03/15.
//  Copyright (c) 2015 brunodominguez. All rights reserved.
//

#import "BDBBookViewController.h"
#import "BDBBook.h"
#import "BDBSimplePDFViewController.h"
#import "ReaderDocument.h"
#import "ReaderViewController.h"

@interface BDBBookViewController ()

@end

@implementation BDBBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    NSMutableArray *favs = [[NSMutableArray alloc]init];
    for (BDBBook* b in self.books) {
        if (b.isFavorite == YES) {
            [favs addObject:b.title];
        }
    }
    [d setObject:favs forKey:@"defaults"];
    
    if (self.book.isFavorite == YES) {
        self.title = [self.book.title stringByAppendingString:@" (Favorite)"];
    }else{
    self.title = self.book.title;
    }
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"PDF" style:UIBarButtonItemStylePlain target:self action:@selector(pdfView:)];
    
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
    }
}

-(IBAction)favorite:(id)sender{
    
    
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
    //[self.delegate bookViewDidChangeFavoriteState:self.book];
    [self viewWillAppear:YES];
}

-(void)pdfView:(BDBBook*)book{
    
    NSString *filePath = [self.book.bookPDFURL path];
    
    ReaderDocument *readerDoc = [[ReaderDocument alloc]initWithFilePath:filePath password:nil];
    ReaderViewController *readerVC = [[ReaderViewController alloc]initWithReaderDocument:readerDoc];
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController pushViewController:readerVC animated:YES];
    
//    BDBSimplePDFViewController *pdfVC = [[BDBSimplePDFViewController alloc]initWithModel:self.book];
//    [self.navigationController pushViewController:pdfVC animated:YES];
}

@end
