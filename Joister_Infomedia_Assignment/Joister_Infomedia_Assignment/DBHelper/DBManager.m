//
//  DBManager.m
//  C5
//
//  Created by Akshay S Shrirao on 10/02/16.
//  Copyright © 2016 Apero Technologies. All rights reserved.
//

#import "DBManager.h"
#import <sqlite3.h>

@interface DBManager()
{
	sqlite3 *sqlite3Database;
	NSString *databasePath;
}
@property (nonatomic, strong) NSString *documentsDirectory;

@property (nonatomic, strong) NSString *databaseFilename;

@property (nonatomic, strong) NSMutableArray *resultsArray;

-(void)copyDatabaseIntoDocumentsDirectory;

-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable;

@end

@implementation DBManager

#pragma mark - Initialization

-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename{
	self = [super init];
	if (self) {
		// Set the documents directory path to the documentsDirectory property.
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		//  NSLog(@"Paths for domian %@",paths);
		self.documentsDirectory = [paths objectAtIndex:0];
		
		// Keep the database filename.
		self.databaseFilename = dbFilename;
		
		// Copy the database file into the documents directory if necessary.
		//  NSLog(@"document direcotory Path - %@",self.documentsDirectory);
		[self copyDatabaseIntoDocumentsDirectory];
	}
	return self;
}


#pragma mark - Private method implementation

-(void)copyDatabaseIntoDocumentsDirectory{
	// Check if the database file exists in the documents directory.
	// NSString *destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
	/*  if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
	 // The database file does not exist in the documents directory, so copy it from the main bundle now.
	 NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseFilename];
	 NSError *error;
	 [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
	 
	 // Check if any error occurred during copying and display it.
	 if (error != nil) {
	 NSLog(@"%@", [error localizedDescription]);
	 }
	 }*/
	
	// Set the database file path.
	databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
 NSFileManager *filemgr = [NSFileManager defaultManager];
	
	if ([filemgr fileExistsAtPath: databasePath ] == NO)
	{
		//creating database tables if not available
		//const char *dbpath = [databasePath UTF8String];
		if (sqlite3_open([databasePath UTF8String], &sqlite3Database) == SQLITE_OK)
		{

			char *errMsg;
			//Query to create Location table
			const char *sql_stmt_Fabric = "CREATE TABLE IF NOT EXISTS Location (availability_id INTEGER PRIMARY KEY NOT NULL,availability_type INTEGER ,address_one VARCHAR ,address_two VARCHAR,landmark VARCHAR,country VARCHAR,states VARCHAR,city VARCHAR,pincode VARCHAR,latitude VARCHAR,longitude VARCHAR,node_id INTEGER,product_id INTEGER,updated VARCHAR)";
			
			if (sqlite3_exec(sqlite3Database,sql_stmt_Fabric, NULL, NULL, &errMsg) != SQLITE_OK) {
				NSLog( @"Failed to create table Location %s",errMsg);
			} else
			{
				   NSLog(@"Location table created successfully");
			}
			
			sqlite3_close(sqlite3Database);
			
		} else {
			NSLog(@"Failed to open/create database");
		}
	}
}

-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable{
	// Create a sqlite object.
	//  sqlite3 *sqlite3Database;
	
	// Set the database file path.
	//NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
	
	// Initialize the results array.
	if (self.resultsArray != nil) {
		[self.resultsArray removeAllObjects];
		self.resultsArray = nil;
	}
	self.resultsArray = [[NSMutableArray alloc] init];
	
	// Initialize the column names array.
	if (self.arrayColumnNames != nil) {
		[self.arrayColumnNames removeAllObjects];
		self.arrayColumnNames = nil;
	}
	self.arrayColumnNames = [[NSMutableArray alloc] init];
 
	// Open the database.
	BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
	if(openDatabaseResult == SQLITE_OK) {
		// Declare a sqlite3_stmt object in which will be stored the query after having been compiled into a SQLite statement.
		sqlite3_stmt *compiledStatement;
		
		// Load all data from database to memory.
		BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, NULL);
		if(prepareStatementResult == SQLITE_OK) {
			// Check if the query is non-executable.
			
			if (!queryExecutable){
				// In this case data must be loaded from the database.
				
				// Declare an array to keep the data for each fetched row.
				NSMutableArray *arrDataRow;
				
				// Loop through the results and add them to the results array row by row.
				while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
					// Initialize the mutable array that will contain the data of a fetched row.
					arrDataRow = [[NSMutableArray alloc] init];
					
					// Get the total number of columns.
					int totalColumns = sqlite3_column_count(compiledStatement);
					
					// Go through all columns and fetch each column data.
					for (int i=0; i<totalColumns; i++){
						// Convert the column data to text (characters).
						char *dbDataAsChars = (char *)sqlite3_column_text(compiledStatement, i);
						
						// If there are contents in the currenct column (field) then add them to the current row array.
						if (dbDataAsChars != NULL) {
							// Convert the characters to string.
							[arrDataRow addObject:[NSString  stringWithUTF8String:dbDataAsChars]];
						}
						// Keep the current column name.
						if (self.arrayColumnNames.count != totalColumns) {
							dbDataAsChars = (char *)sqlite3_column_name(compiledStatement, i);
							[self.arrayColumnNames addObject:[NSString stringWithUTF8String:dbDataAsChars]];
						}
					}
					// Store each fetched data row in the results array, but first check if there is actually data.
					if (arrDataRow.count > 0) {
						[self.resultsArray addObject:arrDataRow];
					}
				}
			}
			else {
				// This is the case of an executable query (insert, update, ...).
				// Execute the query.
				// BOOL executeQueryResults = sqlite3_step(compiledStatement);
				if (sqlite3_step(compiledStatement)) {
					// Keep the affected rows.
					self.affectedRows = sqlite3_changes(sqlite3Database);
					
					// Keep the last inserted row ID.
					self.lastInsertedRowID = sqlite3_last_insert_rowid(sqlite3Database);
				}
				else {
					// If could not execute the query show the error message on the debugger.
					NSLog(@"DB Error: %s", sqlite3_errmsg(sqlite3Database));
				}
			}
		}//here is else
		else {
			/**** Enter Here *****/
			// In the database cannot be opened then show the error message on the debugger.
			NSLog(@"error In DB %s", sqlite3_errmsg(sqlite3Database));
		}
		sqlite3_finalize(compiledStatement);
		
		
	}
	// Close the database.
	sqlite3_close(sqlite3Database);
}

#pragma mark - Public method implementation

-(NSArray *)loadDataFromDB:(NSString *)query{
	// Run the query and indicate that is not executable.
	// The query string is converted to a char* object.
	[self runQuery:[query UTF8String] isQueryExecutable:NO];
		// Returned the loaded results.
	return (NSArray *)self.resultsArray;
}

-(void)executeQuery:(NSString *)query{
	// Run the query and indicate that is executable.
	[self runQuery:[query UTF8String] isQueryExecutable:YES];
}



@end
