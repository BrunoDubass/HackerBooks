//
//  AppDelegate.m
//  HackerBooks
//
//  Created by Bruno Domínguez on 24/03/15.
//  Copyright (c) 2015 brunodominguez. All rights reserved.
//

#import "AppDelegate.h"
#import "BDBLibraryTableViewController.h"
#import "BDBBook.h"

@interface AppDelegate (){
    
    NSURL *documentsURL;
}

@property (strong, nonatomic)NSMutableArray *booksJSON;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //Descarga JSON y modelo
    
    NSFileManager *fm = [NSFileManager defaultManager];
    documentsURL = [[fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject];
    NSData *dataFromJSON;
    NSURL *dataDocumentsURL = [documentsURL URLByAppendingPathComponent:@"data.dat"];
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    
    NSError *error = nil;
    NSArray *contents;
    contents = [fm contentsOfDirectoryAtURL:documentsURL includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsSubdirectoryDescendants error:&error];
    
    if (![d objectForKey:@"defaults"]) {
        
        NSURL *urlJSON = [NSURL URLWithString:@"https://t.co/K9ziV0z3SJ"];
        dataFromJSON = [NSData dataWithContentsOfURL:urlJSON];
        [dataFromJSON writeToURL:dataDocumentsURL atomically:YES];
        
    }
    dataFromJSON = [NSData dataWithContentsOfURL:dataDocumentsURL];
    [self dataToModel:dataFromJSON];

    
    //Controlador
    
    BDBLibraryTableViewController *tVC = [[BDBLibraryTableViewController alloc]initWithModel:self.booksJSON style:UITableViewStylePlain];
    
    //Combinador
    
    UINavigationController *nC = [[UINavigationController alloc]initWithRootViewController:tVC];
    
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];

    
    self.window.rootViewController = nC;
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - DATA FROM JASON TO MODEL

-(void)dataToModel:(NSData*)data{
    
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    NSError *error = nil;
    NSArray *dataToJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    self.booksJSON = [[NSMutableArray alloc]init];
    
    for (NSDictionary* dic in dataToJSON) {
        
                if (![d objectForKey:@"defaults"]) {
                    
                    
                    //Descarga de la imagen del libro nombrando el fichero con el título del libro
                    NSURL *imgURL = [NSURL URLWithString:[dic objectForKey:@"image_url"]];
                    NSData *dt = [NSData dataWithContentsOfURL:imgURL];
                    NSURL *imgDocumentsURL = [documentsURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@", [dic objectForKey:@"title"]]];
                    [dt writeToURL:imgDocumentsURL  atomically:YES];
                    
        
                    //Descarga del PDF nombrando el fichero con el título del libro
                    NSURL *pdfURL = [NSURL URLWithString:[dic objectForKey:@"pdf_url"]];
                    NSData *dtPDF = [NSData dataWithContentsOfURL:pdfURL];
                    NSURL *pdfDocumentsURL = [documentsURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf", [dic objectForKey:@"title"]]];
                    [dtPDF writeToURL:pdfDocumentsURL atomically:YES];
        
        
        
        
                }
        BDBBook *book = [[BDBBook alloc]initWithTitle:[dic objectForKey:@"title"]
                                              authors:[[dic objectForKey:@"authors"]componentsSeparatedByString:@","]
                                                 tags:[[dic objectForKey:@"tags"]componentsSeparatedByString:@","]
                                              bookImg:[UIImage imageWithData: [NSData dataWithContentsOfURL:[documentsURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@", [dic objectForKey:@"title"]]]]]
                                           bookPDFURL:[documentsURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf", [dic objectForKey:@"title"]]]
                                              bookPDF:[NSData dataWithContentsOfURL:[documentsURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf", [dic objectForKey:@"title"]]]]];
        
        if ([[d objectForKey:@"defaults"]containsObject:book.title]) {
            book.isFavorite = YES;
            NSMutableArray *mTags = [[NSMutableArray alloc]initWithArray:book.tags];
            [mTags addObject:@"Favorites"];
            book.tags = mTags;
        }
                [self.booksJSON addObject:book];
    }
    if (![d objectForKey:@"defaults"]) {
        [self setDefaults];
    }
}

-(void)setDefaults{
    
    NSArray *indexes = [[NSArray alloc]init];
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    [d setObject:indexes forKey:@"defaults"];
}


@end
