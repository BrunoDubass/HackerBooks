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

@interface BDBLibraryTableViewController ()

@property (strong, nonatomic)NSMutableArray *booksJSON;
@property (strong, nonatomic)BDBBook *bookP;
@property (strong, nonatomic)NSIndexPath *indexP;



@end

@implementation BDBLibraryTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    
    //Registrar NIB
    UINib *cellNib = [UINib nibWithNibName:@"BDBLibraryTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib
         forCellReuseIdentifier:[BDBLibraryTableViewCell cellId]];
    
    
    
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
    
    
    BDBLibraryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[BDBLibraryTableViewCell cellId]];

    
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
        

    
    
    cell.bookImageLabel.image = b.bookImg;
    cell.titleLabel.text = b.title;
    cell.authorsLabel.text = [[b.tags componentsJoinedByString:@", "]capitalizedString];
 
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BDBBook *bk = [self.model bookForTag:[self.model.tags objectAtIndex:indexPath.section] atIndex:indexPath.row];
    
    BDBBookViewController *bVC = [[BDBBookViewController alloc]initWithModel:bk books:self.model.books];
    //bVC.delegate = self;
    [self.navigationController pushViewController:bVC animated:YES];
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return [[[self.model tags]objectAtIndex:section]capitalizedString];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [BDBLibraryTableViewCell cellHigh];
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - BDBBookViewControllerDelegate

//-(void)bookViewDidChangeFavoriteState:(BDBBook *)book{
//    BDBBook *b;
//    NSArray *bs = self.model.books;
//    for (int i = 0; i<bs.count; i++) {
//        if ([[[bs objectAtIndex:i]title]isEqual:book.title]) {
//            b = book;
//        }
//    }
//    
//}


@end
