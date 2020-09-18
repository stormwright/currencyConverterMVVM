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

    func sceneWillResignActive(_ scene: UIScene) {
        localFeedLoader.validateCache { (_) in  }
    }

}

