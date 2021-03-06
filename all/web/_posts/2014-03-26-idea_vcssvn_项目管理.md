---
layout: post
title: idea_vcssvn_项目管理
---

## [How to manage projects under Version Control Systems](https://intellij-support.jetbrains.com/entries/23393067)

If you decide to share IDE project files with other developers, follow these guidelines:

Directory based project format (.idea directory)
This format is used by all the recent IDE versions by default. Here is what you need to share:

All the files under .idea directory in the project root except the workspace.xml and tasks.xml files which store user specific settings
All the .iml module files that can be located in different module directories (applies to IntelliJ IDEA)
Be careful about sharing the following:

Android artifacts that produce a signed build (will contain keystore passwords)
dataSources.ids, datasources.xml (can contain database passwords)
You may consider not to share the following:

gradle.xml file, see this discussion
user dictionaries folder (to avoid conflicts if other developer has the same name)
XML files under .idea/libraries in case they are generated from Gradle project
Legacy project format (.ipr/.iml/.iws files)
Share the project .ipr file and all the .iml module files, don't share the .iws file as it stores user specific settings