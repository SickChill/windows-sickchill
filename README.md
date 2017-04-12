SickRageInstaller [![Build status](https://ci.appveyor.com/api/projects/status/yub1d59qlfub8uvb/branch/master?svg=true)](https://ci.appveyor.com/project/sharkykh/sickrageinstaller/branch/master)
=========
A Windows Installer for SickRage

**NOTE:** This installer intentionally ignores any existing installations of Git or Python you might already have installed on your system. If you would prefer to use those versions, we recommend installing SickRage manually.

Features
--------
Here are some of the features of SickRageInstaller:
- Downloads SickRage dependencies (Git, Python)
- Installs everything (SickRage and dependencies) in a self-contained directory
- Installs SickRage as a Windows service (handled by NSSM)
- Detects 32-bit and 64-bit architectures and installs appropriate dependencies
- Creates Start Menu shortcuts
- When uninstalling, asks user if they want to delete or keep their database and configuration
- Allows configuring the web UI port during install
- Automatically creates firewall rules in Windows Firewall

The install script is written using the excellent [Inno Setup](http://www.jrsoftware.org/isinfo.php) by Jordan Russell.

Download
--------
Head on over to the [releases](https://github.com/SickRage/SickRageInstaller/releases/latest) tab.

How It Works
------------
First, the installer will grab a 'seed' file, located [here](https://raw.github.com/SickRage/SickRageInstaller/master/seed.ini). This has a list of the dependencies, the URLs they can be downloaded from, their size, and an SHA1 hash. It also uses this file to make sure the user is running the latest version of the installer.

Once the user steps through the pages of the wizard, the installer downloads the dependency files and verifies the SHA1 hash. It then installs them into the directory chosen by the user. Once the dependencies are installed, it uses Git to clone the SickRage repository.
