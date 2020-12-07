//
//  SceneDelegate.swift
//  scrap
//
//  Created by Matt Roberts on 11/15/20.
//
import UIKit
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	var window: UIWindow?
	static var mainsSplitViewController: MainSplitViewController?
	#if targetEnvironment(macCatalyst)
		var toolbarDelegate = ToolbarDelegate()
		static var toolbar: NSToolbar?
	#endif
	func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
			   options connectionOptions: UIScene.ConnectionOptions) {
		// Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
		// If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
		// This delegate does not imply the connecting scene or session are new (see
		//`application:configurationForConnectingSceneSession` instead).
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		guard let mainSplitViewController=storyboard.instantiateViewController(withIdentifier:
																					"MainSplitViewController") as? MainSplitViewController else {
			print("Failed to instantiate mainSplitViewController")
			return
		}
		SceneDelegate.mainsSplitViewController=mainSplitViewController
		window?.rootViewController = mainSplitViewController
		if scene as? UIWindowScene != nil {
		} else {
			return
		}
		#if targetEnvironment(macCatalyst)
			guard let windowScene = scene as? UIWindowScene else {
				return }
			SceneDelegate.toolbar = NSToolbar(identifier: "main")
			SceneDelegate.toolbar?.delegate = toolbarDelegate
			SceneDelegate.toolbar?.displayMode = .iconOnly
			SceneDelegate.enableValidToolbarItems()
		if let titlebar = windowScene.titlebar {
			titlebar.toolbar = SceneDelegate.toolbar
			titlebar.toolbarStyle = .automatic
			}
		#endif
		print("Should have added toolbar")
	}

	func sceneDidDisconnect(_ scene: UIScene) {
		// Called as the scene is being released by the system.
		// This occurs shortly after the scene enters the background, or when its session is discarded.
		// Release any resources associated with this scene that can be re-created the next time the scene connects.
		// The scene may re-connect later, as its session was not necessarily discarded (see
		//`application:didDiscardSceneSessions` instead).
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
	static func enableValidToolbarItems() {
		guard let splitViewController = SceneDelegate.mainsSplitViewController else {
			return
		}
		guard let contactCardViewController=splitViewController.viewController(for: .secondary)
				as? ContactCardViewController else {
			return
		}
		guard let appDelegate=UIApplication.shared.delegate as? AppDelegate else {
			return
		}
		guard let toolbar=SceneDelegate.toolbar else {
			return
		}
		for item in toolbar.items {
			switch item.itemIdentifier {
			case .editCard, .deleteCard, .exportCard, .showQRCode, .shareCard:
				if let _=contactCardViewController.contactCard {
					item.target=appDelegate
					item.isEnabled=true
				} else {
					item.target=self
					item.isEnabled=false
				}
			default:
				print(item.itemIdentifier.rawValue)
			}
		}
	}
}
