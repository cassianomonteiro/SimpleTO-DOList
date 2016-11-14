//
//  ConnectionManager.m
//  SimpleTO-DOList
//
//  Created by Cassiano Monteiro on 21/10/16.
//  Copyright © 2016 Cassiano Monteiro. All rights reserved.
//

#import "ConnectionManager.h"

@interface ConnectionManager()
@property (nonatomic, strong) RKObjectManager *objectManager;
@property (nonatomic, strong) NSMutableArray<RKObjectRequestOperation *> *operations;
@end

@implementation ConnectionManager

#pragma mark - Initializers

static ConnectionManager *_sharedInstance;
static NSString *DefaultBaseURL = @"https://todo-api-warmup.herokuapp.com";

#pragma mark - Path patterns

static NSString *userPathPattern    = @"/user";
static NSString *listsPathPattern   = @"/api/lists";

#pragma mark - Route names

static NSString *userListsRoute     = @"userListsRoute";

+ (ConnectionManager *)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[ConnectionManager alloc] initWithBaseURL:[NSURL URLWithString:DefaultBaseURL]];
    });
    
    return _sharedInstance;
}

- (instancetype)initWithBaseURL:(NSURL *)baseURL
{
    self = [super init];
    if (self) {
        self.baseURL = baseURL;
        self.operations = [NSMutableArray array];
    }
    return self;
}

- (NSURL *)baseURL
{
    return self.objectManager.baseURL;
}

- (void)setBaseURL:(NSURL *)baseURL
{
    // Instantiate object manager with webservice base url,
    // and add default routes and response descriptors
    self.objectManager = [RKObjectManager managerWithBaseURL:baseURL];
    self.objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
    self.objectManager.managedObjectStore = [RKManagedObjectStore defaultStore];
    [self.objectManager.router.routeSet addRoutes:[self defaultClassRoutes]];
    [self.objectManager addRequestDescriptorsFromArray:[self defaultRequestDescriptors]];
    [self.objectManager addResponseDescriptorsFromArray:[self defaultResponseDescriptors]];
}

- (NSArray *)defaultClassRoutes
{
    return @[
             [RKRoute routeWithClass:[User class] pathPattern:userPathPattern method:RKRequestMethodPOST],
             [RKRoute routeWithName:userListsRoute pathPattern:listsPathPattern method:RKRequestMethodGET]
             ];
}

- (NSArray *)defaultRequestDescriptors
{
    return @[
             [RKRequestDescriptor requestDescriptorWithMapping:[User requestMapping] objectClass:[User class] rootKeyPath:nil method:RKRequestMethodPOST],
             ];
}

- (NSArray *)defaultResponseDescriptors
{
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    
    return @[
             [RKResponseDescriptor responseDescriptorWithMapping:[User responseMapping] method:RKRequestMethodPOST pathPattern:userPathPattern keyPath:@"data" statusCodes:statusCodes],
             [RKResponseDescriptor responseDescriptorWithMapping:[List responseMapping] method:RKRequestMethodGET pathPattern:listsPathPattern keyPath:@"data" statusCodes:statusCodes],
             
             // Add error response descriptor to be tried last
             [self errorResponseDescriptor]
             ];
}

/**
 * Response descriptor default for 4xx and 5xx errors with JSON content {"errorMessage": "xxx"}
 *
 * @returns RKResponseDescriptor object
 */
- (RKResponseDescriptor *)errorResponseDescriptor
{
    // Error JSON looks like {"errorMessage": "xxx"}
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[RKErrorMessage class]];
    // The entire value at the source key path containing the errors maps to the message
    [errorMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"errorMessage"]];
    
    // Index status codes for 4xx and 5xx ranges
    NSMutableIndexSet *errorCodes = [[NSMutableIndexSet alloc] initWithIndexSet:RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError)];
    [errorCodes addIndexes:RKStatusCodeIndexSetForClass(RKStatusCodeClassServerError)];
    
    // Any error response with an "errorMessage" key path uses this mapping
    return [RKResponseDescriptor responseDescriptorWithMapping:errorMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"errorMessage" statusCodes:errorCodes];
}

- (void)requestUserCreation:(User *)user forDelegate:(id<ConnectionManagerDelegate>)delegate
{
    [self sendRequestForObject:user withMethod:RKRequestMethodPOST andRouteName:nil andBodyParameters:nil andHeaderParameters:nil forDelegate:delegate];
}

- (void)requestUserListsForDelegate:(id<ConnectionManagerDelegate>)delegate
{
    [self sendRequestForObject:nil withMethod:RKRequestMethodGET andRouteName:userListsRoute andBodyParameters:nil andHeaderParameters:nil forDelegate:delegate];
}

#pragma mark - Helpers

// Helper method to forward calls to class routes (no path)
- (void)sendRequestForObject:(id)object withMethod:(RKRequestMethod)requestMethod andBodyParameters:(NSDictionary *)bodyParameters andHeaderParameters:(NSDictionary<NSString *, NSString *> *)headerParameters forDelegate:(id<ConnectionManagerDelegate>)delegate
{
    [self sendRequestForObject:object withMethod:requestMethod andRouteName:nil andBodyParameters:bodyParameters andHeaderParameters:headerParameters forDelegate:delegate];
}

- (void)sendRequestForObject:(id)object withMethod:(RKRequestMethod)requestMethod andRouteName:(NSString *)routeName andBodyParameters:(NSDictionary *)bodyParameters andHeaderParameters:(NSDictionary<NSString *, NSString *> *)headerParameters forDelegate:(id<ConnectionManagerDelegate>)delegate
{
    // Create a request
    NSMutableURLRequest *request = [self requestForObject:object withMethod:requestMethod andRouteName:routeName andBodyParameters:bodyParameters];
    
    // Set request fixed HTTP header fields
    [request setValue:self.firebaseKey?:@"" forHTTPHeaderField:@"firebase_key"];
    
    // Set request custom HTTP header fields
    if (headerParameters) {
        [headerParameters enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            [request setValue:obj forHTTPHeaderField:key];
        }];
    }
    
    RKObjectRequestOperation *operation = [self operationForObject:object withRequest:request andDelegate:delegate];
    
    
    // Add metadata for base URL
    operation.mappingMetadata = @{@"baseURL" : self.baseURL};
    
    // Hold onto operation with a strong pointer
    [self.operations addObject:operation];
    
    // DEBUG: Useful command to debug HTTPBody of a HTTP POST Request
    // po [[NSString alloc] initWithData:operation.HTTPRequestOperation.request.HTTPBody encoding:NSUTF8StringEncoding]
    
    // Start request operation asynchronously
    [operation start];
}

- (NSMutableURLRequest *)requestForObject:(id)object withMethod:(RKRequestMethod)requestMethod andRouteName:(NSString *)routeName andBodyParameters:(NSDictionary *)bodyParameters
{
    if (routeName) {
        // Get route with given path as route name
        return [self.objectManager requestWithPathForRouteNamed:routeName object:object parameters:bodyParameters];
    }
    else {
        // Get route by class
        return [self.objectManager requestWithObject:object method:requestMethod path:nil parameters:bodyParameters];
    }
}

- (RKObjectRequestOperation *)operationForObject:(id)object withRequest:(NSURLRequest *)request andDelegate:(id<ConnectionManagerDelegate>)delegate
{
    
    RKObjectRequestOperation *operation;
    
    if (object && ![object isKindOfClass:[NSManagedObject class]]) {
        operation = [self.objectManager objectRequestOperationWithRequest:request success:nil failure:nil];
    }
    else {
        operation = [self.objectManager managedObjectRequestOperationWithRequest:request managedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext success:nil failure:nil];
    }
    
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        // Release executed operation
        [self.operations removeObject:operation];
        
        [delegate connectionManager:self didCompleteRequestWithReturnedObjects:mappingResult.array];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        // Release executed operation
        [self.operations removeObject:operation];
        
        [delegate connectionManager:self didFailRequestWithError:error];
        
    }];
    
    return operation;
}

@end
