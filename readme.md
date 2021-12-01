# Currency Convertor
    This is test app to demostrate my Swift skills :) 

# Screens
    1. Currency convertor screen to show currency rates for selected base currency and target currency

# Design
    Design done using Storyboard and custom classes, functions, extensions, etc.

# Supported 
    iOS 9.0+

# Implemented following things: 
    1. Extensions - For Font, Color, Views, String, etc. to add additional property or feature
    2. Singlton classes - To create object of classes once and used many times for functionality like read json file and parse it, get array of tracks data
    3. Assets - To store icons used in the app

# Architecuter 
    ## AppDelegates
        For Legendary AppDelegate file and newly introduced SceneDelegate classes
    ## Managers
        For Data manager classes 
    ## Models
        For represeting data item classes
    ## Views
        For representing All the screens related classes, storyboard, etc.
    ## ViewModels
        For representing All the views business logic related classes
    ## Helpers
        For Helper classes like Extensions, API calling class, Constants, Utilities, etc.
    ## Resources
        For app resources like fonts, assets, etc.
    ## SupportingFiles
        For app supporting files like info.plist, GoogleInfoPlist.plist, etc.
        
        
# SDKs
    Third party SDK added using CocoaPods
        1. Alamofire - To fire API calls
        2. IQKeyboardManagerSwift - To handle keyboard related changes in UI 
