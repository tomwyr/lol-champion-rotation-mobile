allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.layout.buildDirectory = file("../build")

subprojects {
    project.layout.buildDirectory = file("${rootProject.layout.buildDirectory.get()}/${project.name}")
    evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
