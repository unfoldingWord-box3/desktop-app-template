#%%APP_NAME%%-macos-[type]-%%APP_VERSION%% USAGE

To upgrade:

1. Backup `~/panksomia_working/repos` where "~" is the OS user home directory.
2. Delete `~/panksomia_working/`
3. Move %%APP_NAME%%-macos-[type]-%%APP_VERSION%%.zip to your Desktop.
4. Double-click %%APP_NAME%%-macos-[type]-%%APP_VERSION%%.zip to expand its contents into a '%%APP_NAME%%-macos-[type]-%%APP_VERSION%%' folder.
5. Open a terminal -- Launchpad (Application) > Utilities > Terminal
6. Type the following then enter:
     cd Desktop/%%APP_NAME%%-macos-[type]-%%APP_VERSION%%
          Use the values of [type] from the folder name expanded on your Desktop in step 4 above.
7. Type the following then enter:
     ./%%APP_NAME%%.%%APP_EXT%%
8. This will should to a message saying "server.bin" Not Opened. If instead you get "can't open the file" or something else similar, then:
  * Look under Settings > Privacy and Security > Files & Folders > Terminal, and see if you need to turn on permissions for Desktop, OR, move your liminal folder to another location or re-unzip in another location and run from there in a terminal.
  * Or, another possibility is that 'Move to Trash' could have been selected on server.bin on a prior attempt to run. If this was done, then you can find it in your trash and 'put back', or re-unzip.
9. Click either "Done" or "Cancel", depending on which of those options you have.
10. Go to Apple menu > System Preference >  Privacy and Security > General > and at the bottom, after "server.bin" was blocked, click "Allow Anyway" .
11. Wait until the "server.bin was blocked" message disappears from the settings page.
12. In the terminal type the following again then enter:
     ./%%APP_NAME%%.%%APP_EXT%%
    Watch following load in the terminal window:
     OS = 'macos'
     Rocket has launched from http://127.0.0.1:19119
    This will also launch http://localhost:19119 in Firefox (if available) or in your default web browser.
13. Restore backup from step 1 to `~/panksomia_working/repos`
14. Reconnect to http://localhost:19119 from Firefox (or an alternate web browser) as needed.

First time use (not an upgrade):

1. Move %%APP_NAME%%-macos-[type]-%%APP_VERSION%%.zip to your Desktop.
2. Double-click %%APP_NAME%%-macos-[type]-%%APP_VERSION%%.zip to expand its contents into a '%%APP_NAME%%-macos-[type]-%%APP_VERSION%%' folder.
3. Open a terminal -- Launchpad (Application) > Utilities > Terminal
4. Type the following then enter:
     cd Desktop/%%APP_NAME%%-macos-[type]-%%APP_VERSION%%
          Use the values of [type] from the folder expanded on your Desktop in step 2 above.
5. Type the following then enter:
     ./%%APP_NAME%%.%%APP_EXT%%
6. This will lead to a message saying "server.bin" Not Opened
7. Click either "Done" or "Cancel", depending on which of those options you have.
8. Go to Apple menu > System Preference >  Privacy and Security > General > and at the bottom, after "server.bin" was blocked, click "Allow Anyway" .
9. Wait until the "server.bin was blocked" message disappears from the settings page.
10. In the terminal type the following again then enter:
     ./%%APP_NAME%%.%%APP_EXT%%
    Watch following load in the terminal window:
     OS = 'macos'
     Rocket has launched from http://127.0.0.1:19119
    This will also launch http://localhost:19119 in Firefox (if available) or in your default web browser.
11. Reconnect to http://localhost:19119 from Firefox (or an alternate web browser) as needed.

Best viewed with a Graphite-enabled browser such as Firefox, Zen Browser, LibreWolf or via Electronite.