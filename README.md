# desktop-app-template
This template is designed to be forked for Desktop App repos built on Pankosmia.

Choose a repo-name of 30 characters or less to prevent **Windows developers** from needing to clone to a shorter local repo name. The windows cargo build c compiler requires repos names of 30 characters or less.

## Environment requirements for this repo

Tested on:
| Ubuntu 24.04 with: | Windows 11 with: | MacOS with: |
|-------|---------|-------|
|- npm 9.2.0<br />- node 18.19.1<br />- rustc 1.83.0 -- `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \| sh` | - npm 10.7.0<br />- node 18.20.4<br />- rustc 1.83.0 -- See https://www.rust-lang.org/tools/install<br />- cmake 3.31.0 -- Version 3 is required. See https://cmake.org/download/ | - npm 10.7.0 (tested on Monterey)<br />- npm 10.8.2 (tested on Sequoia)<br />- node 18.20.4<br />- rustc 1.86.0 -- `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \| sh`<br />- OpenSSL 3.5.0 -- `brew install openssl` |

## Setup

1. Recommended directory structure:

<ul><pre>
|-- repos
    |-- pankosmia
        |-- [your-desktop-app-repo-name] <b><em>(30 characters or less on windows!)</em></b>
</pre></ul>

2. Replace all instances of "desktop-app-template" in packages.json with "[your-desktop-app-repo-name]" and update the name and description.
3. At the root of your clone of this repo, run

<ul><pre>
npm install
</pre></ul>

4. Edit app_config.env, entering the App Name, version number, theme, assets (might not change), and clients.
5. `cd [os]/scripts`
6. Run<sup id="a1">[[1]](#f1)</sup> the `clone` script to clone all repos listed in `app_config.env` (assets and clients)
7. Run<sup id="a1">[[1]](#f1)</sup> the `app_setup` script to generate the config files to match `app_config.env`. Re-run<sup id="a1">[[1]](#f1)</sup> the `app_setup` script anytime `app_config.env` is modified.
8. Run<sup id="a1">[[1]](#f1)</sup> the `build_clients` script to build all clients. Be patient. This will take a while.
   - This script is intended for setting all clients up for <b>first use</b>, or for rebuilding <b>all</b> clients to their <b>latest main</b> branch. It changes to the main<sup id="a2">[[2]](#f2)</sup> branch, pulls the latest, and builds (or rebuilds) every client every time it is run.<br />
   - Build client manually when you want to use a branch or when you only need to rebuild one client or when you do not want all clients built from their latest main branch!
9. Run<sup id="a1">[[1]](#f1)</sup> the `build_server` script to build the Pankosmia server and assemble the build environment. (be patient. This will also take a while.)
10.  Plan at some point to customize this readme for your project.  At minimum:
    - rewrite the top most "# desktop-app-template" section
    - replace all instances of "[your-desktop-app-repo-name]" with your desktop app repo name"
    - delete 2., 4., and 10., and re-number.

## Use

 - Run<sup id="a1">[[1]](#f1)</sup> the `run` script to start the server without a browser launch.
    - Consider also if you need to delete ~/pankosmia_working first.
   - You'll want to restart the server if deleting ~/pankosmia_working after starting the server. To restart, exit the terminal window where the server is running the run the `run` script<sup id="a1">[[1]](#f1)</sup> again.
   - Only one instance of the server can be running at a time.<sup id="a3">[[3]](#f3)</sup>
 - Client development: Manually build the client(s) changed, stop the server it is is running, then start the server (`run`).  The `run` script will re-assemble the environment to include your build.
 - To generate a release package for the OS you are using, edit the version number for the release in `app_config.env` then run<sup id="a1">[[1]](#f1)</sup> the `bundle_...` script.
 - To generate artifacts:
   1. [Run each workflow manually](https://docs.github.com/en/actions/how-tos/managing-workflow-runs-and-deployments/managing-workflow-runs/manually-running-a-workflow#running-a-workflow) (Actions > [select workflow] > Run workflow).
      - The current main branch of client repo and resource at the time of running the workflow will be used.
   2. Download resulting artifacts (Actions > click the name of a run to see the workflow run summary > scroll down to the bottom to the Artifacts section > to download, click either the name of each artifact or the down arrow on each row
   3. Any double-compressed artifacts should have one layer uncompressed before release:
      - *.tgz.zip -> *.tgz
      - *.zip.zip -> *.zip
      - If working from windows, avoid releasing a re-zipping a macos or linux zip package if a .pkg, .sh, .bsh, .zsh was in the layer re-zipped in windows. Doing so would otherwise remove file permission settings of `chmod +x` where they are needed.
      - Release the *.pkg.zip layer as .zip as it includes a README file in the same layer as the pkg, which contains installation and upgrade instructions / info.
   4. Upload releases manually by going to the Release section of your repo and selecting "Draft a new release".

## Maintenance:
 - To update the server, change the [latest version](https://crates.io/search?q=pankosmia-web) of [panksomia-web](https://docs.rs/pankosmia_web/latest/pankosmia_web/) in `/local_server/Cargo.toml` and re-run the `build_server` script.
 - To sync this repo with its upstream, run the `sync` script.

## Setup, Use, and Maintenance Footnotes
[<b id="f1">1</b>] ...  Windows developers, run <b>.bat</b> scripts from a <b>Powershell or Command terminal</b>:<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;_...repos\pankosmia\[your-desktop-app-repo-name]\windows\scripts>_ `.\[scriptname].bat`<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Use a **powershell** terminal for the **.ps1** build scripts.
<br />
MacOS developers, run .bsh scripts from a **linux terminal**:<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;_...repos/pankosmia/[your-desktop-app-repo-name]/linux/scripts>_ `./[scriptname].bsh`
<br />
Linux developers, run .zsh scripts from a **MacOS terminal**:<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;_...repos/pankosmia/[your-desktop-app-repo-name]/macos/scripts>_ `./[scriptname].zsh`

[<b id="f2">2</b>] ... The build script will fail on any clients set to a different branch with uncommitted changes or with conflicts vs, the latest main pull. Scroll back up in the terminal to find any build errors and address them.

[<b id="f3">3</b>] ... If running into an error saying that another instance is running, you can either find the other instance and stop it, or simply reboot. Another instance could be one started from a .zip, .tgz, installed version, run from a different repo, or a manually started panksomia-web.

## Additional Info TL;DR - For reference when needed!
### Ecosystem setup and configuration
This repo pulls together several libraries and projects into a single app. The projects are spread across several repos to allow modular reuse. Scripts follow for assisting in setup, though it can also all be setup manually. The following assume [the repos](https://github.com/pankosmia/repositories) are installed with the following directory structure.

This is an example. Clients in use may vary. Configuration is handled via `app_config.env`and the `app_setup` script. If you prefer to set this up manually, then see the configuration section under Scripts, towards the bottom of this readme.

<pre>
|-- repos
    |-- pankosmia
        |-- core-client-content repository
        |-- core-client-dashboard repository
        |-- core-client-i18n-editor repository
        |-- core-client-remote-repos repository
        |-- core-client-settings repository
        |-- core-client-workspace repository
        |-- [your-desktop-app-repo-name] <b><em>(30 characters or less on windows!)</em></b>
        |-- resource-core
        |-- webfonts-core
</pre>

### Installing the clients
The local_server (pankosmia_web) serves compiled files from the `build` directory of each client, each client must be built. 

This is handled by the `clone` and `build_clients` scripts, though can also all be run manually which is helpful during development.
```
# In each client repo, NOT this repo!
npm install
npm run build
```
Running `run`, `build_server`, or `bundle_...` all copy the latest build to the build environment.

### Scripts

#### Configuration

Config files must match clients and assets utilized. Scripts that write them are provided, or you can adjust them manually. The configuration files are:

| Linux | Windows | MacOS |
|-------|---------|-------|
| <pre>buildSpec.json<br />/globalBuildResources/i18nPatch.json<br />/globalBuildResources/theme.json<br />/linux/buildResources/setup/app_setup.json</pre> | <pre>buildSpec.json<br />/globalBuildResources/i18nPatch.json<br />/globalBuildResources/theme.json<br />/windows/buildResources/setup/app_setup.json</pre> | <pre>buildSpec.json<br />/globalBuildResources/i18nPatch.json<br />/globalBuildResources/theme.json<br />/macos/buildResources/setup/app_setup.json</pre> 

To setup config files using one of the scripts that follow, first update `app_config.env`.

##### Config scripts:
Run from the provided location:
| Description | Linux | Windows | MacOS |
|-------------|-------|---------|-------|
| Uses app_config.env to generate/rebuild/replace app_setup.json, buildSpec.json, and i18nPatch.json| `/linux/scripts/app_setup.bsh` | `/windows/scripts/app_setup.bat` | `/macos/scripts/app_setup.zsh` |

##### Setup scripts:
Run from the provided location:
| Description | Linux | Windows | MacOS |
|-------|-------|---------|-------|
| Clones all repos in `/app_config.env` if a directly by that name does not already exit | /linux/scripts/clone.bsh | /windows/scripts/clone.bat | /macos/scripts/clone.zsh |
| For each asset repo in `/app_config.env`: git checkout main, git pull<br />For each client repo in  `/app_config.env`: `git checkout main`, `git pull`, `npm install`, and `npm run build`.<br />***Dev's should build manually when testing branch(es).*** | /linux/scripts/build_clients.bsh | /windows/scripts/build_clients.bat | /macos/scripts/build_clients.zsh |

##### Usage scripts:

| Description | Linux | Windows | MacOS |
|-------|-------|---------|-------|
| removes the build directory and runs `cargo clean` | /linux/scripts/clean.bsh | /windows/scripts/clean.bat | /macos/scripts/clean.zsh |
| runs `clean.bat`, cargo build, and `node build.js` | /linux/scripts/build_server.bsh | /windows/scripts/build_server.bat | /macos/scripts/build_server.zsh |
| Assembles the build environment (clients) and starts the server **(*)** | /linux/scripts/run.bsh | /windows/scripts/run.bat | /macos/scripts/run.zsh |
| Deletes the last .zip release bundle if it it exists, runs `app_setup.bat` to ensure version consistency, then on this repo runs `git checkout main`, `git pull`, and `npm install`, runs `node build.js`, then makes a zip release bundle **(*)** | /linux/scripts/bundle_tgz.bsh | /windows/scripts/bundle_zip.ps1 | /macos/scripts/bundle_zip.zsh |
| Deletes the last .exe release bundle if it it exists, runs `app_setup.bat` to ensure version consistency, then on this repo runs `git checkout main`, `git pull`, and `npm install`, runs `node build.js`, then makes an exe installer **(*)** **(&bull;)** | | /windows/scripts/bundle_exe.ps1 **(&bull;)** | |

**(*)** ***Ensure the server (build_server.bat) is current!***<br />
**(&bull;)** ***Environment prerequisite for running the exe build locally: Install [Inno Setup](https://jrsoftware.org/isdl.php) -tested with v6.4.3***
***

##### Maintenance scripts:
Run from the provided location:
| Description | Linux | Windows | MacOS |
|-------|-------|---------|-------|
| Facilitates syncing with upstream with exclusion of files expected to differ: | /linux/scripts/sync.bsh | /windows/scripts/sync.bat | /macos/scripts/sync.zsh |
