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
The completion handler will get called when ever there is an update posted on that specific resource.

  


