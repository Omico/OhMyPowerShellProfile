@file:DependsOn("org.jetbrains.kotlinx:kotlinx-serialization-json:1.5.0")
@file:Suppress("PLUGIN_IS_NOT_ENABLED")

import kotlinx.serialization.Serializable
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json
import kotlin.io.path.Path
import kotlin.io.path.writeText

val exampleProfiles = Profiles(
    profiles = listOf(
        Profile(
            id = "pc",
            features = listOf(
                "Client-ProjFS",
                "Containers",
                "HypervisorPlatform",
                "Microsoft-Hyper-V-All",
                "NetFx3",
                "NetFx4-AdvSrvs",
                "VirtualMachinePlatform",
                "WorkFolders-Client",
            ),
            wsl = Profile.Wsl(
                distribution = "Ubuntu",
            ),
            winget = Profile.Winget(
                groups = listOf(
                    "development",
                    "extra",
                ),
                packages = listOf(
                    "Git.Git",
                ),
            ),
            environments = mapOf(
                // Use absolute paths in actual use
                // Path(".").normalize().absolutePathString()
                "OMPSPrivateDirectory" to "",
            ),
        ),
    ),
    winget = Profiles.Winget(
        core = listOf(
            "JanDeDobbeleer.OhMyPosh",
            "Microsoft.OneDrive",
            "Microsoft.PowerShell",
            "Microsoft.VisualStudioCode",
        ),
        groups = listOf(
            Profiles.Winget.Group(
                id = "development",
                packages = listOf(
                    "Axosoft.GitKraken",
                ),
            ),
            Profiles.Winget.Group(
                id = "extra",
                packages = listOf(),
            ),
        ),
    ),
)

private val json = Json {
    prettyPrint = true
    prettyPrintIndent = "  "
}

Path("profiles.json.example").writeText(json.encodeToString(exampleProfiles))

@Serializable
data class Profiles(
    val profiles: List<Profile> = listOf(),
    val winget: Winget,
) {
    @Serializable
    data class Winget(
        val core: List<String>,
        val groups: List<Group> = listOf(),
    ) {
        @Serializable
        data class Group(
            val id: String,
            val packages: List<String> = listOf(),
        )
    }
}

@Serializable
data class Profile(
    val id: String,
    val features: List<String> = listOf(),
    val wsl: Wsl = Wsl(),
    val winget: Winget,
    val environments: Map<String, String> = mapOf(),
) {
    @Serializable
    data class Wsl(
        val distribution: String = "Ubuntu",
    )

    @Serializable
    data class Winget(
        val groups: List<String> = listOf(),
        val packages: List<String> = listOf(),
    )
}
