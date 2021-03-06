//
//  CKIExternalTool+NetworkingSpec.m
//  CanvasKit
//
//  Created by nlambson on 10/10/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "CKIClient+TestingClient.h"
#import "CKIExternalTool+Networking.h"
#import "CKICourse.h"

SPEC_BEGIN(CKIExternalTool_NetworkingSpec)

describe(@"A CKIExternalTool", ^{
    CKICourse *course = [CKICourse mock];
    
    [course stub:@selector(id) andReturn:@"123"];
    [course stub:@selector(path) andReturn:@"/api/v1/courses/123"];
    
    context(@"when fetching all external tools for a course", ^{
        NSString *testPath = @"/api/v1/courses/123/external_tools";
        [[CKIClient currentClient] returnResponseObject:@[] forPath:testPath];
        
        it(@"should call the CKIClient helper method with the correct path", ^{
            [[[CKIClient currentClient] should] receive:@selector(fetchPagedResponseAtPath:parameters:modelClass:context:success:failure:) withArguments:testPath, any(), any(), any(), any(), any()];

            [CKIExternalTool fetchExternalToolsForCourse:course success:nil failure:nil];
        });
    
    });
    
    context(@"when fetching a sessionless launch url for an external tool with url", ^{
        NSString *testPath = @"/api/v1/courses/123/external_tools/sessionless_launch";
        [[CKIClient currentClient] returnResponseObject:@{} forPath:testPath];
        
        it(@"should call the CKIClient helper method with the correct path", ^{
            [[[CKIClient currentClient] should] receive:@selector(fetchModelAtPath:parameters:modelClass:context:success:failure:) withArguments:testPath, any(), any(), any(), any(), any()];
            
            [CKIExternalTool fetchSessionlessLaunchURLWithURL:@"http://lti-tool-provider.herokuapp.com/lti_tool" andCourse:course success:nil failure:nil];
        });
    });
    
    context(@"when fetching a single external tool for a course with an external tool id", ^{
        NSString *testPath = @"/api/v1/courses/123/external_tools/24506";
        [[CKIClient currentClient] returnResponseObject:@{} forPath:testPath];
        
        it(@"should call the CKIClient helper method with the correct path", ^{
            [[[CKIClient currentClient] should] receive:@selector(fetchModelAtPath:parameters:modelClass:context:success:failure:) withArguments:testPath, any(), any(), any(), any(), any()];

            [CKIExternalTool fetchExternalToolForCourseWithExternalToolID:@"24506" andCourse:course success:nil failure:nil];
        });
    });
    
});

SPEC_END