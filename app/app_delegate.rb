class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    rootViewController = ViewController.alloc.init
    rootViewController.title = 'VCTransitionsLibraryDemo'
    rootViewController.view.backgroundColor = UIColor.whiteColor

    navigationController = NavigationController.alloc.initWithRootViewController(rootViewController)

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = navigationController
    @window.makeKeyAndVisible

    true
  end
end
