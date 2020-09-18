//
//  SceneDelegate.swift
//  CurrencyConverterApp
//
//  Copyright © 2020 Stormwright. All rights reserved.
//

import UIKit
import MoneyConverterEngine
import ExchangeRatesFeediOS
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var store: RatesFeedStore = {
        try! CoreDataRatesFeedStore(
            storeURL: NSPersistentContainer
                .defaultDirectoryURL()
                .appendingPathComponent("rates-feed-store.sqlite"))
    }()
    
    private lazy var localFeedLoader: LocalRatesFeedLoader = {
        LocalRatesFeedLoader(store: store, currentDate: Date.init)
    }()
    
    convenience init(httpClient: HTTPClient, store: RatesFeedStore) {
        self.init()
        self.httpClient = httpClient
        self.store = store
    }


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        configureWindow()
        self.window?.makeKeyAndVisible()
    }
    
    func configureWindow() {
        let url = URL(string: "https://pastebin.com/raw/gg4BAg5z")!
        let remoteRatesFeedLoader = RemoteRatesFeedLoader(url: url, client: httpClient)
        window?.rootViewController = UINavigationController(
            rootViewController: MainFeedUIComposer.mainFeedComposedWith(
                ratesLoader: RatesFeedLoaderWithFallbackComposite(
                    primary: RatesFeedLoaderCacheDecorator(
                        decoratee: remoteRatesFeedLoader,
                        cache: localFeedLoader),
                    fallback: localFeedLoader)))
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

