/**
 * @fileoverview Electron startup script for managing application lifecycle, server process, and window creation.
 *
 * @synopsis
 * This script serves as the main entry point for an Electron application, handling:
 * - Application window management
 * - Backend server process lifecycle
 * - Custom menu creation (especially for macOS)
 * - Application events and shutdown procedures
 *
 * @description
 * The script manages the lifecycle of both the Electron frontend and a backend server process.
 * It creates the main application window, starts/stops a backend server on port 19119,
 * and handles various application events like window creation, activation, and shutdown.
 * For macOS, it creates a custom application menu with standard operations.
 *
 * @requirements
 * - Electron.js
 * - A compatible backend server binary (server.bin for macOS/Linux or server.exe for Windows)
 * - Port 19119 must be available for the backend server
 * - For macOS/Linux: lsof command must be available for port checking
 * - Environment variable APP_NAME must be set for proper application naming
 */

const { app, BrowserWindow, Menu, shell} = require('electron');
const { spawn, execSync } = require('child_process');
const path = require('path');

let serverProcess = null;
app.name = '${APP_NAME}';
const port = '19119';

// Function to check if server is running (on port)
function isServerRunning() {
  try {
    // macOS & Linux: use lsof; Windows would require a different approach
    execSync(`lsof -i:${port} | grep LISTEN`, { stdio: 'ignore' });
    return true;
  } catch {
    return false;
  }
}

/**
 * wraps timer in a Promise to make an async function that continues after a specific number of milliseconds.
 * @param {number} ms
 * @returns {Promise<unknown>}
 */
function delay(ms) {
  return new Promise((resolve) =>
    setTimeout(resolve, ms)
  );
}

const MAC_SERVER_PATH = './bin/server.bin';
const WIN_SERVER_PATH = './bin/server.exe';

function startServer() {
  if (!isServerRunning()) {
    const serverPath = process.platform === 'win32' ? WIN_SERVER_PATH : MAC_SERVER_PATH;
    const resourcesDir = './lib/';
    const workingDir =  path.join(__dirname, '..');
    console.log('startServer() - workingDir is ' + workingDir);

    console.log('startServer() - resourcesDir is ' + resourcesDir);
    const env = {
      ...process.env,
      APP_RESOURCES_DIR: resourcesDir,
      ROCKET_PORT: port
    };

    console.log('startServer() - env is ', env);
    
    serverProcess = spawn(serverPath, [], {
      stdio: 'ignore',
      detached: true,
      env: env,
      cwd: workingDir
    });
    serverProcess.unref();
    console.log('startServer() - Server started at ' + path.join(workingDir, serverPath));
  } else {
    console.log(startServer() - 'Server already running.');
  }
}

function stopServer() {
  if (serverProcess) {
    // Kill the process we spawned (or use another mechanism if you need gentle shutdown)
    try {
      process.kill(serverProcess.pid);
      console.log('stopServer() - Server stopped.');
    } catch (e) {
      // It may have already exited
      console.error('stopServer() - Server Failed to stop - process ID kill failed.');
    }
  } else {
    // Optionally: kill whatever is listening on port
    try {
      console.log('stopServer() - Trying to stop server forcefully.');
      execSync(`lsof -t -i:${port} | xargs kill -9`);
      console.log('stopServer() - Server stopped forcefully.');
    } catch {
      // ignore if nothing is running
      console.error(`stopServer() - Server Failed to stop - process at port ${port} ID kill failed.`);
    }
  }
}

function createWindow () {
  delay(500).then( () =>
  {
    console.log('createWindow() - after delay');
    const win = new BrowserWindow({
      width: 1024,
      height: 768,
      show: false  // Don't show until ready to maximize
    });

    win.once('ready-to-show', () => {
      win.maximize();
      win.show();
    });

    win.loadURL(`http://127.0.0.1:${port}`);
  })
}

app.whenReady().then(() => {
  // Set a custom menu with desired app name
  const isMac = process.platform === 'darwin';
  if (isMac) {
    const template = [
      {
        label: app.name, // <--- This name will show in the macOS app menu
        submenu: [
          {role: 'about'},
          {type: 'separator'},
          {role: 'services'},
          {type: 'separator'},
          {role: 'hide'},
          {role: 'hideothers'},
          {role: 'unhide'},
          {type: 'separator'},
          {role: 'quit'}
        ]
      },
      {
        label: 'Edit',
        submenu: [
          {role: 'undo'},
          {role: 'redo'},
          {type: 'separator'},
          {role: 'cut'},
          {role: 'copy'},
          {role: 'paste'},
          {role: 'pasteAndMatchStyle'},
          {role: 'delete'},
          {role: 'selectAll'}
        ]
      },
      {
        label: 'View',
        submenu: [
          {role: 'reload'},
          {role: 'forcereload'},
          {role: 'toggledevtools'},
          {type: 'separator'},
          {role: 'resetzoom'},
          {role: 'zoomin'},
          {role: 'zoomout'},
          {type: 'separator'},
          {role: 'togglefullscreen'}
        ]
      },
      {
        label: 'Window',
        submenu: [
          {role: 'minimize'},
          {role: 'zoom'},
          {type: 'separator'},
          {role: 'front'},
          {role: 'window'}
        ]
      },
      {
        label: 'Help',
        submenu: [
          {
            label: 'Learn More',
            click: async () => {
              await shell.openExternal('https://electronjs.org');
            }
          }
        ]
      }
    ];
    const menu = Menu.buildFromTemplate(template);
    Menu.setApplicationMenu(menu);
  }
  
  startServer();
  setTimeout(createWindow, 2000); // Wait 2 seconds for server to start (adjust as needed)
});

app.on('window-all-closed', () => {
  console.log('window-all-closed() - app quitting');
  // On macOS, apps are expected to stay alive until explicitly quit
  // but we quit anyway so server doesn't remain running
  app.quit();
});

app.on('will-quit', () => {
  console.log('will-quit() - app quitting');
  stopServer();
});

app.on('before-quit', () => {
  console.log('before-quit() - app quitting');
  stopServer();
});

app.on('activate', () => {
  if (BrowserWindow.getAllWindows().length === 0) {
    console.log('activate() - app creating window since there are none');
    createWindow();
  } else {
    console.log('activate() - app not creating window since there are already windows');
  }
});