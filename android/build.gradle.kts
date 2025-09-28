buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.google.gms:google-services:4.3.5")
        classpath("com.google.firebase:firebase-crashlytics-gradle:2.7.1")
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
