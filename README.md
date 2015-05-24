# RBSentinel

RBSentinel helps is filling the communication gap between the applewatch and the parent application. 
It opens up a REST based handler to handle information needed by the watchapp

#Installation

1. RBSentinel can be added to your project manually by adding the RBSentinel.h and .m to the project folder.
2. Cocopods

#Usage

RBSentinel was inspired by <a href="https://github.com/mutualmobile/MMWormhole">MWormhole</a>, with a way to perfom CRUD operations over a specific resource. Sentinel has the ability to listen to updates on specific resource. 

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

For example if the resource type is post, then sentinel looks for a PostHandler class, and fires  get, post, update, remove methods. A typical handler looks like

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

# Lincense



  


