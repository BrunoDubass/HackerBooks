//
//  BDBLibraryTableViewController.m
//  HackerBooks
//
//  Created by Bruno Domínguez on 25/03/15.
//  Copyright (c) 2015 brunodominguez. All rights reserved.
//

#import "BDBLibraryTableViewController.h"
#import "BDBBook.h"
#import "BDBLibrary.h"
#import "BDBLibraryTableViewCell.h"
#import "BDBBookViewController.h"


@interface BDBLibraryTableViewController (){
    
    NSURL *documentsURL;
    NSUserDefaults *d;
     __block NSURL *imgDocumentsURL;
    NSURL *dataDocumentsURL;
    NSData *dataFromJSON;
    NSIndexPath *iP;
}


@property (strong, nonatomic)NSMutableArray *booksJSON;
@property (strong, nonatomic)BDBBook *bookP;
@property (strong, nonatomic)NSIndexPath *indexP;

@end

@implementation BDBLibraryTableViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerNib];
    self.model = [[BDBLibrary alloc]initWithBooks:[[NSMutableArray alloc]init]];
    
    d = [NSUserDefaults standardUserDefaults];
    iP = [NSIndexPath indexPathForRow:[[[d objectForKey:@"keyBook"]objectForKey:@"row"]integerValue] inSection:[[[d objectForKey:@"keyBook"]objectForKey:@"section"]integerValue]];
    //Descarga JSON y modelo
    
    NSFileManager *fm = [NSFileManager defaultManager];
    documentsURL = [[fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject];
    
    
    //Ruta y fichero donde guardo el JSON
    dataDocumentsURL = [documentsURL URLByAppendingPathComponent:@"data.dat"];
    
    
    
     dispatch_queue_t load1 = dispatch_queue_create("l1", 0);
    dispatch_async(load1, ^{
        //Primera carga. No defaults. Descargo JSON de la red.
        [self getJSON];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
            
            dispatch_queue_t load2 = dispatch_queue_create("l2", 0);
            dispatch_async(load2, ^{
                //Parseo datos de JSON
                [self dataToModel:dataFromJSON];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    
                    dispatch_queue_t load = dispatch_queue_create("l", 0);
                    dispatch_async(load, ^{
                        
                        
                        
                        [self getPictures];
                        
                        
                        
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            //[self.tableView reloadData];
                            [self selectLastBook];
                            [self viewWillAppear:YES];
                            
                        });
                    });
                    
                });
            });
            
        });
        

    });
            
            
    
    

    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //Alta en notificación
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateTableViewTags:) name:NOTIFICATION_DID_CHANGE_ISFAVORITE object:nil];
    
    
    //Recargamos datos de la tabla
    
    [self.tableView reloadData];
    
    
    //Seleccionamos último libro elegido
    
    
    iP = [NSIndexPath indexPathForRow:[[[d objectForKey:@"keyBook"] objectForKey:@"row"]integerValue] inSection:[[[d objectForKey:@"keyBook"]objectForKey:@"section"]integerValue]];
    
    [self.tableView selectRowAtIndexPath:iP animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - INITS


-(id)initWithModel:(NSMutableArray*)model style:(UITableViewStyle)style{
    if (self = [super initWithStyle:style]) {
        _model = [[BDBLibrary alloc]initWithBooks:model];
        self.title = @"HackerBooks";
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.model.tags.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.model bookCountForTag:[self.model.tags objectAtIndex:section]];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    // En qué libro estamos
    
    BDBBook *b = [self.model bookForTag:[self.model.tags objectAtIndex:indexPath.section] atIndex:indexPath.row];
    
    //Reutilizamos celda personalizada
    
    BDBLibraryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[BDBLibraryTableViewCell cellId] forIndexPath:indexPath];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor blackColor];
    [cell setSelectedBackgroundView:bgColorView];
    cell.titleLabel.highlightedTextColor = [UIColor whiteColor];
    cell.authorsLabel.highlightedTextColor = [UIColor yellowColor];

    //Config de imagen estrella para favoritos
    
    if (indexPath.section == 0 && [self.model booksForTag:@"Favorites"]) {
        
        cell.starImage.image = [UIImage imageNamed:@"StarAlpha"];

        cell.backgroundColor = [UIColor yellowColor];
        cell.titleLabel.textColor = [UIColor blackColor];
        cell.authorsLabel.textColor = [UIColor lightGrayColor];
        
    }else{
        if (b.isFavorite) {
            cell.starImage.image = [UIImage imageNamed:@"Star1"];
            cell.backgroundColor = [UIColor whiteColor];
        }else{
             cell.starImage.image = [UIImage imageNamed:@"Star2"];
            cell.backgroundColor = [UIColor whiteColor];
        }

    }
        
    //Sync Modelo y Vista
    
    cell.bookImageLabel.image = b.bookImg;
    cell.titleLabel.text = b.title;
    cell.authorsLabel.text = [[b.tags componentsJoinedByString:@", "]capitalizedString];
 
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //User defaults para última fila seleccionada
    
    NSNumber *section = [NSNumber numberWithInteger:indexPath.section];
    NSNumber *row = [NSNumber numberWithInteger:indexPath.row];
    
    [[NSUserDefaults standardUserDefaults]setObject:@{@"section":section , @"row":row} forKey:@"keyBook"];
    
    iP = [NSIndexPath indexPathForRow:[[[d objectForKey:@"keyBook"]objectForKey:@"row"]integerValue] inSection:[[[d objectForKey:@"keyBook"]objectForKey:@"section"]integerValue]];
    
    //Envío al delegado del tableView
    
    BDBBook *bk = [self.model bookForTag:[self.model.tags objectAtIndex:indexPath.section] atIndex:indexPath.row];
    [self.delegate libraryTableviewSelectedBook:bk arrayOfBooks:self.model.books];
    
    //Envío de notificación
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    NSDictionary *dic = @{KEY:bk};
    NSNotification *n = [[NSNotification alloc]initWithName:NOTIFICATION_DID_SELECT_ROW object:self userInfo:dic];
    [nc postNotification:n];
    
    

}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return [[[self.model tags]objectAtIndex:section]capitalizedString];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [BDBLibraryTableViewCell cellHigh];
}

-(void)setDefaults{
    
    NSArray *indexes = [[NSArray alloc]init];
    d = [NSUserDefaults standardUserDefaults];
    [d setObject:indexes forKey:@"defaults"];
    [d setObject:@{@"section":@0, @"row":@0} forKey:@"keyBook"];
}


-(void)registerNib{
    
    //Registrar NIB celda personalizada
    
    UINib *cellNib = [UINib nibWithNibName:@"BDBLibraryTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib
         forCellReuseIdentifier:[BDBLibraryTableViewCell cellId]];
}

#pragma mark - BDBLibraryTableViewControllerDelegate

-(void)libraryTableviewSelectedBook:(BDBBook *)book arrayOfBooks:(NSArray *)books{
    
        BDBBookViewController *bVC = [[BDBBookViewController alloc]initWithModel:book books:books];
    
        [self.navigationController pushViewController:bVC animated:YES];
}

#pragma mark - Notifications

//NOTIFICATION_DID_CHANGE_ISFAVORITE

-(void)updateTableViewTags:(NSNotification*)notification{
    
    [self.tableView reloadData];
    
    //[self selectLastBook];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    BDBBook *bk = [self.model bookForTag:[self.model.tags objectAtIndex:0] atIndex:0];
    [self.delegate libraryTableviewSelectedBook:bk arrayOfBooks:self.model.books];
}

#pragma mark - DATA FROM JASON TO MODEL

-(void)dataToModel:(NSData*)data{
    
    
    d = [NSUserDefaults standardUserDefaults];
    NSError *error = nil;
    
    //JSON en array de diccionarios
    NSArray *dataToJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
//    self.booksJSON = [[NSMutableArray alloc]init];
    self.model.books = [[NSMutableArray alloc]init];
    
    //Recorro array del JSON
    for (NSDictionary* dic in dataToJSON) {
        
        
        //Parseo a BDBBook con datos de Documents
        
        BDBBook *book = [[BDBBook alloc]initWithTitle:[dic objectForKey:@"title"]
                                              authors:[[dic objectForKey:@"authors"]componentsSeparatedByString:@","]
                                                 tags:[[dic objectForKey:@"tags"]componentsSeparatedByString:@","]
                                              bookImg:[UIImage imageNamed:@"noimage.png"]
                                           bookPDFURL:[NSURL URLWithString:[dic objectForKey:@"pdf_url"]]
                                              bookPDF:nil
                                           bookImgURL:[NSURL URLWithString:[dic objectForKey:@"image_url"]]];
        
        if (![d objectForKey:@"defaults"]) {
            book.isDefault = NO;
        }else{
            book.isDefault = YES;
        }
        
         //Cargo favoritos de User Defaults
        
        if ([[d objectForKey:@"defaults"]containsObject:book.title]) {
            book.isFavorite = YES;
            NSMutableArray *mTags = [[NSMutableArray alloc]initWithArray:book.tags];
            [mTags addObject:@"Favorites"];
            book.tags = mTags;
        }
    
        [self.model.books addObject:book];
    }
    
}

-(void) getJSON{
    
    if (![d objectForKey:@"defaults"]) {
        
        NSURL *urlJSON = [NSURL URLWithString:@"https://t.co/K9ziV0z3SJ"];
        dataFromJSON = [NSData dataWithContentsOfURL:urlJSON];
        //Guardo JSON en Documents
        [dataFromJSON writeToURL:dataDocumentsURL atomically:YES];
        
    }
    
    //Recupero JSON de Documents
    dataFromJSON = [NSData dataWithContentsOfURL:dataDocumentsURL];

}

-(void)getPictures{
    
    if (![d objectForKey:@"defaults"]) {
        
        [self setDefaults];
        for (BDBBook* bk in self.model.books){
            
            //Descarga de la imagen del libro nombrando el fichero con el título del libro
            NSURL *imgURL = bk.bookImgURL;
            NSData *dt = [NSData dataWithContentsOfURL:imgURL];
            imgDocumentsURL = [documentsURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@", bk.title]];
            [dt writeToURL:imgDocumentsURL  atomically:YES];
            bk.bookImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:imgDocumentsURL]];
            }

        }else
        
        {
            
            for (BDBBook *bk in self.model.books){
                imgDocumentsURL = [documentsURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@", bk.title]];
                bk.bookImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:imgDocumentsURL]];
                
            
        }
        
        
    }
    
    
}

-(void)selectLastBook{
    
    //Seleccionamos último libro elegido
    
    [self.tableView selectRowAtIndexPath:iP animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    
    //Envío al delegado del tableView
 
    BDBBook *bk = [self.model bookForTag:[self.model.tags objectAtIndex:iP.section] atIndex:iP.row];
    [self.delegate libraryTableviewSelectedBook:bk arrayOfBooks:self.model.books];
}



@end
