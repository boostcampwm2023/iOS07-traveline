import ProjectDescription

let config = Config(
    plugins: [
        .local(path: .relativeToManifest("../../Plugins/EnvPlugin")),
        .local(path: .relativeToManifest("../../Plugins/ConfigPlugin"))
    ]
)
