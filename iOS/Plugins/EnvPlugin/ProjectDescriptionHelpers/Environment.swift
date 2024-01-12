import ProjectDescription

public extension Project {
    enum Environmnet {
        public static let workspace = "traveline"
        public static let deploymentTarget = DeploymentTarget.iOS(targetVersion: "16.0", devices: [.iphone])
        public static let bundleName = "com.boostcamp8.traveline"
    }
}
