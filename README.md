## CanvasKit by Instructure iOS

CanvasKit is a library that will help you integrate your own third party app with [Canvas by Instructure](https://instructure.com/).

CanvasKit is built on the [Canvas API](https://canvas.instructure.com/doc/api/index.html). CanvasKit is designed to allow for great flexibility while providing an easy to use interface. You can use CanvasKit to build apps for open source versions of Canvas as well as instances hosted by Instructure.

## How To Get Started

- [Download CanvasKit](https://github.com/instructure/CanvasKit/archive/master.zip) and try out the included iPhone example app
- Take a look at the [Canvas API](https://canvas.instructure.com/doc/api/index.html) for a complete list of endpoints

### Installation with CocoaPods

***
NOTE: Canvas Kit is not yet a cocoapod but will be soon
***

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like CanvasKit in your projects. See the ["Getting Started" guide for more information](https://github.com/AFNetworking/AFNetworking/wiki/Getting-Started-with-AFNetworking).

#### Podfile

```ruby
platform :ios, '7.0'
pod "CanvasKit", "~> 2.0"
```

## 2.0

CanvasKit 2.0 is a major refactor from the previous version of CanvasKit. Until now CanvasKit has only been used on internal projects at [Instructure](http://www.instructure.com/). One of our major goals of the recent refactor was to make CanvasKit open source and easy to use for third party developers.

## Usage

### Setup

In order to use CanvasKit with Instructure mangaged instances of [Canvas LMS](https://github.com/instructure/canvas-lms) you must obtain a Client ID and Shared Secret. CanvasKit uses [OAuth 2](https://canvas.instructure.com/doc/api/file.oauth.html) for authentication. Request your Client ID and Shared Secret by sending an email to <mike@instructure.com>. Make sure to give us your name, email, and what you are hoping to do with the CanvasKit.

Once you have your Client ID and Shared Secret you can start using CanvasKit. Somewhere in your App Delegate's `didFinishLaunchingWithOptions` method setup CanvasKit with your Client ID and Shared Secret.

```objc
[CanvasKit prepareWithClientID:@"yourclientid" sharedSecret:@"yoursharedsecret"];
```

### User Authentication


#### CKILocalUser

CanvasKit uses the concept of a 'Local User', or the user currently using the device. `CKILocalUser` is a singleton, giving you access to the current user anywhere in your application by calling:

```objc
[CKILocalUser sharedInstance]
```

Before you can use any other CanvasKit methods to access the Canvas LMS API you must authenticate the current user. CanvasKit makes this easy by handling the OAuth 2 authentication flow for you. All you have to do is call the following method to prompt the user to authenticate.

```objc
[[CKILocalUser sharedInstance] performLoginWithDomain:@"yourschooldomain" success:^{
    [self dismissViewControllerAnimated:YES completion:nil];
    // Success the user was authenticated
} failure:^(NSError *error) {
    [self dismissViewControllerAnimated:YES completion:nil];
    // Authentication failed 
}];
```

#### Keychain

Once authentication succeeds, an authentication token will be added to your application's keychain. If you would like to use a shared keychain with CanvasKit make sure you prepare CanvasKit with your shared keychain id:

```objc
[CanvasKit prepareWithClientID:@"yourclientid" sharedSecret:@"yoursharedsecret" keyChainId:@"yourkeychainid"];
```
The authentication token will remain in the keychain until you logout the `CKILocalUser`.

```objc
[[CKILocalUser sharedInstance] logout];
```

### Accessing the API

#### Architecture Overview

CanvasKit includes classes for many of the objects found in the Canvas LMS. Along with these model classes CanvasKit includes networking categories for accessing the API endpoints. This means if you wanted to get data from the API related to courses you would start with the CKICourse class and envoke one of the networking methods. For example:

```objc
[CKICourse fetchCoursesForCurrentUserWithSuccess:^(CKIPagedResponse *response) {
    // Success fetching courses
} failure:^(NSError *error) {
    // Failed to fetch courses
}];
```

Each networking method begins with 'fetch' making it easy for you to see all available options with Xcode auto-complete.

#### Pagination

For performance reasons, many of the Canvas API endpoints that return lists of items do not return all items at once—they instead return chunks (pages) of items. As you need more items in the list, you can request more pages. More information on the specific implementation details for pagination can be found in the [API Pagination Documentation](https://canvas.instructure.com/doc/api/file.pagination.html), but fortunately CanvasKit abstracts most of this away from you with `CKIPagedResponse`.

The `CKIPagedResponse` provides you with three important things:

1. `items` - the list of items returned by the API
2. `isLastPage` - tells you if you there are more pages to grab
3. `- fetchNextPageWithSuccess:failure:` - fetches the next CKIPagedResponse

So, how might this work? Let's look at an example where we want to fetch the assignments for a course (assuming we already have the course object)

```objc
- (void)loadMoreAssignmentsWithCompletion:(void (^)())completion
{
    // if we haven't fetched any data yet, fetch the first page
    if (!self.currentPage) {
        [CKIAssignment fetchAssignmentsForCourse:self.course withSuccess:^(CKIPagedResponse *pagedResponse) {
            self.currentPage = pagedResponse;
            [self.assignments addObjectsFromArray:pagedResponse.items];
            
            if (completion) {
                completion();
            }
        } failure:^(NSError *error) {
            // handle error
        }];
    }
    // if we've alread fetched some data, but we haven't fetched the last page yet, fetch more data
    else if (!self.currentPage.isLastPage) {
        [self.currentPage fetchNextPageWithSuccess:^(CKIPagedResponse *pagedResponse) {
            self.currentPage = pagedResponse;
            [self.assignments addObjectsFromArray:pagedResponse.items];
            
            if (completion) {
                completion();
            }
        } failure:^(NSError *error) {
            // handle error
        }];
    }
}
```

CanvasKit treats all API endpoints that may return multiple items as if they were paginated, regardless of whether or not they are currently paginated. This means you cannot make assumptions about the maximum number of items in a response—typically paginated APIs will default to 10 items per page, but non paginated APIs have no limit.

CanvasKit is available under the MIT license. See the LICENSE file for more info.
