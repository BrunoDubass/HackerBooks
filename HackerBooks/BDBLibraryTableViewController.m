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
    
    d = [NSUserDefaults standardUserDefaults];
    
    //Primera carga. Descargo imágenes y PDFs en Documents
    NSFileManager *fm = [NSFileManager defaultManager];
    documentsURL = [[fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject];
    
    
                            if (![[self.model.books objectAtIndex:0]isDefault]) {
                                
                                dispatch_queue_t images;
                                images = dispatch_queue_create("img", 0);
                                dispatch_async(images, ^{
                                    
                                    for (BDBBook* bk in self.model.books){
                                    
                                    //Descarga de la imagen del libro nombrando el fichero con el título del libro
                                    NSURL *imgURL = bk.bookImgURL;
                                    NSData *dt = [NSData dataWithContentsOfURL:imgURL];
                                    imgDocumentsURL = [documentsURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@", bk.title]];
                                    [dt writeToURL:imgDocumentsURL  atomically:YES];
                                        bk.bookImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:imgDocumentsURL]];
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        
                                        
                                        [self.tableView reloadData];
                                    });
                                    
                                    }
                                });


                            }else{
                                for (BDBBook* bk in self.model.books){
                                    imgDocumentsURL = [documentsURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@", bk.title]];
                                    bk.bookImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:imgDocumentsURL]];

                                }
                            }

    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //Alta en notificación
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateTableViewTags:) name:NOTIFICATION_DID_CHANGE_ISFAVORITE object:nil];
    
    
    //Recargamos datos de la tabla
    
    [self.tableView reloadData];
    
    //Seleccionamos último libro elegido
    
    d = [NSUserDefaults standardUserDefaults];
    NSIndexPath *iP = [NSIndexPath indexPathForRow:[[[d objectForKey:@"keyBook"] objectForKey:@"row"]integerValue] inSection:[[[d objectForKey:@"keyBook"]objectForKey:@"section"]integerValue]];
    
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

-(id)initWithModel:(NSArray*)model style:(UITableViewStyle)style{
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

    //Config de imagen estrella para favoritos
    
    if (indexPath.section == 0) {
          cell.starImage.image = [UIImage imageNamed:@"StarAlpha"];

        cell.backgroundColor = [UIColor yellowColor];
        
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
    [d setObject:@{@"section":@1, @"row":@0} forKey:@"keyBook"];
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
    //Seleccionamos último libro elegido
    
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    NSIndexPath *iP = [NSIndexPath indexPathForRow:[[[d objectForKey:@"keyBook"] objectForKey:@"row"]integerValue] inSection:[[[d objectForKey:@"keyBook"]objectForKey:@"section"]integerValue]];
    
    [self.tableView selectRowAtIndexPath:iP animated:YES scrollPosition:UITableViewScrollPositionNone];
}

@end
