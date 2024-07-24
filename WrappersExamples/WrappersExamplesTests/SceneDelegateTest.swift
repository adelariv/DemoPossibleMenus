//
//  SceneDelegateTest.swift
//  WrappersExamplesTests
//
//  Created by Andres de la Riva Lamas on 04/07/2024.
//

import XCTest
@testable import WrappersExamples

@objc(MockSceneDelegate)
class MockSceneDelegate: NSObject, UISceneDelegate {
  var sceneWillConnectToCalled: Bool = false
  var userActivity: NSUserActivity?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    sceneWillConnectToCalled = true
    userActivity = connectionOptions.userActivities.first
  }
}


final class SceneDelegateTest: XCTestCase {
    
    func testDeepLinkHandlingInSceneDelegate() {
        let mockSceneDelegate = MockSceneDelegate()
        let scene = UIWindow().windowScene!

        // Simulate a deep link URL
        let deepLinkURLString = "yourApp://path/to/content?param1=value1"
        let deepLinkURL = URL(string: deepLinkURLString)!
        let userActivity = NSUserActivity(activityType: NSUserActivityTypeBrowsingWeb)
        userActivity.webpageURL = deepLinkURL

        // Create connection options with the deep link activity
//        let connectionOptions = UIScene.ConnectionOptions(userActivities: [userActivity])


        // Act - Simulate scene connection with deep link
//        mockSceneDelegate.scene(scene, willConnectTo: scene.session, options: connectionOptions)

        // Assert
        XCTAssertTrue(mockSceneDelegate.sceneWillConnectToCalled)
        XCTAssertEqual(mockSceneDelegate.userActivity?.webpageURL, deepLinkURL)

        // Replace with your logic to handle the deep link URL
        handleDeepLink(mockSceneDelegate.userActivity!.webpageURL!)
      }

      // Replace with your actual function to handle the deep link URL
      private func handleDeepLink(_ url: URL) {
        // Your logic to extract information from the URL and perform actions
        print("Deep link URL received: \(url)")
      }
    
    
    
}
