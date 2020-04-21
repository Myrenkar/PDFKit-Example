import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // MARK: Properties

    var window: UIWindow?
    private let applicationDependencies = DefaultApplicationDependenciesProvider()
    private lazy var applicationController = ApplicationController(dependencies: self.applicationDependencies)

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        if let windowScene = scene as? UIWindowScene {
            window = UIWindow(windowScene: windowScene)
        }

        window!.rootViewController = applicationController.rootViewController
        window!.makeKeyAndVisible()
    }
}
