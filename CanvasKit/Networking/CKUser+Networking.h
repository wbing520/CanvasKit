//
//  CKUser+Networking.h
//  CanvasKit
//
//  Created by Jason Larsen on 10/8/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import "CKUser.h"

@class CKPagedResponse;
@class CKCourse;

@interface CKUser (Networking)

/**
 Fetch all the users for the current course.
 
 @param course the course to fetch the users for
 @param success the block to be executed if the API call succeeds
 @param failure the block to be executed if the API call fails
 */
+ (void)fetchUsersForCourse:(CKCourse *)course success:(void(^)(CKPagedResponse *pagedResponse))success failure:(void(^)(NSError *error))failure;


/**
 Fetch all the users for the current course.
 
 @param searchTerm the search term for searching users in the course
 @param course the course to fetch the users for
 @param success the block to be executed if the API call succeeds
 @param failure the block to be executed if the API call fails
 */
+ (void)fetchUsersMatchingSearchTerm:(NSString *)searchTerm course:(CKCourse *)course success:(void(^)(CKPagedResponse *))success failure:(void(^)(NSError *error))failure;
@end
