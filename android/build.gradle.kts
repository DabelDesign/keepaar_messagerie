// 🔥 Ajout des référentiels nécessaires pour Firebase
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// 🔧 Configuration du répertoire de build
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// 📌 Assurer la dépendance au projet `app`
subprojects {
    project.evaluationDependsOn(":app")
}

// 🚀 Ajout du plugin Google Services pour Firebase
plugins {
    id("com.google.gms.google-services") // Indispensable pour Firebase
}

// 📌 Définition de la tâche de nettoyage du projet
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}