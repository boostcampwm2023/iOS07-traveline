import ProjectDescription

public extension Project {
    enum Environmnet {
        public static let workspace = "traveline"
        public static let deploymentTarget = DeploymentTarget.iOS(targetVersion: "15.0", devices: [.iphone])
        public static let bundleName = "kr.codesquad.boostcamp8.traveline"
    }
}
