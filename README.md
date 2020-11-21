
# SwiftRequesto
Requesto it's a lightweight network layer for iOS application that can execute async and sync URLRequests.

Install via CocoaPods:
```swift
 pod 'Requesto'
```
https://cocoapods.org/pods/Requesto

First of all you need to make import:
```swift
import Requesto
```

For common REST requests please use Request().

Example:
```swift
let request = Request(owner: ObjectIdentifier.init(self),
          url: "...your url...",
          requestType: .get,
          onSuccess: { response in
               //...response here
          }, onFail: { error in
               //...error here
          })
```

For synchronous execution use:

```swift
request.executeSync(parseAs: ...your type for parsing...)
```

For asynchronous execution use:

```swift
request.executeAsync(parseAs: ...your type for parsing...)
```

For download operation if you need to download some file:
```swift
DownloadRequest.init(owner: ObjectIdentifier(self), url: "https://compote.slate.com/images/18ba92e4-e39b-44a3-af3b-88f735703fa7.png?width=1440&rect=1560x1040&offset=0x0", requestType: .get) { progress in
      // progress
  } onDownloadSuccess: { response in
      let data = try? Data(contentsOf: (response?.location!)!) 
  } onFail: { error in
      // error
  }.executeSync()
  ```
  
  We're still working on this network layer, new updates will be available soon. 
  If you have any propositions fell free to contact me: pavlo.dumiak@gmail.com
