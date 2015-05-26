# RBSentinel

RBSentinel helps is filling the communication gap between the applewatch and the parent application. It opens up a REST based interface to handle information needed by the watchapp.

<p align="center">
<img src="https://raw.githubusercontent.com/RoshanNindrai/RBSentinel/master/sentinel.gif?token=ADUjbOmsarofVeQbbK5LYyR5gxtHTf7Sks5VbaZCwA%3D%3D" width=400px height=400px />
</p>
<p align="center">
<img src="https://raw.githubusercontent.com/RoshanNindrai/RBSentinel/master/sentinel_rest.gif?token=ADUjbOUVOonZz4nzL2aGx79L2HMnRTieks5VbabwwA%3D%3D" width=660px height=300px />
</p>

#Installation

1. RBSentinel can be added to your project manually by adding the RBSentinel.h and .m to the project folder.
2. Cocopods

#Usage

RBSentinel was inspired by <a href="https://github.com/mutualmobile/MMWormhole">MMWormhole</a>, with a way to perfom CRUD operations over a specific resource. Sentinel has the ability to listen to updates on specific resource even when the app is not open or in background. 

Initialization

```
self.sentinel = [[Sentinel alloc] initWithGroupIdentifier:@"group.sentinel"];
```

with groupIdentifier being the app groups identifier

To add a listener to a specific resource
```
[self.sentinel addListenerForResource:@"message" withCompletionHandler:^(id response) {
        [weakSelf.parentAppMessage setText:response];
}];
```
The completion handler will get called when ever there is an update posted on that specific resource. Multiple listeners can be added to a same resouce. These listener basically listens for updates on a specific resource. To post an update to a specific resouce

```
[self.sentinel didUpdateResource:@"message" withContent:self.userInput.text];
```
The above update triggers the listener that was added previously to that specific topic.

# Handlers

Apart from listeners, Sentinel enables us to perfrom get, post, update, remove operations over a specific resource type.
To enable handlers the appdelegate needs to have the following line
```
[Sentinel handleWatchKitExtensionRequest:userInfo reply:reply];
```

For example if the resource type is post, then sentinel looks for a PostHandler class, and fires either get, post, update, remove methods. A typical request looks like

```
[self.sentinel performRequestofType:GET forResource:@"post" withParameters:@{@"1":@"2"} andCompletionHander:^(id response) {
        NSLog(@"RESPONSE %@", response);
    }];

```

The above request invokes the post method with PostHander class. The following is the way how Sentinel resolves resource to handlers.

Post => PostHandler
message => MessageHandler

```
@interface PostHandler : NSObject<SentinelHandlerProtocol>

@end

@implementation PostHandler

-(id)get:(id)parameters {
    
    // gets called for request type get
    
}

-(id)post:(id)parameters {
    
     // gets called for request type post

}

-(id)remove:(id)parameters {
    
     // gets called for request type remove
    
}

-(id)update:(id)parameters {
    
     // gets called for request type update
    
}
```

#TODO
1. Looking into more cleaner Handler implementation

# Lincense

The MIT License (MIT)

Copyright (c) 2014 RoshanNindrai

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

  


